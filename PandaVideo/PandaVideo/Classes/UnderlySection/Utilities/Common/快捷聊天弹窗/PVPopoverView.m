//
//  PVPopoverView.m
//  PandaVideo
//
//  Created by Ensem on 2017/11/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPopoverView.h"
#import "PVPopoverViewCell.h"

static CGFloat const kPopoverViewMargin = 8.f;        ///< 边距
static CGFloat const kPopoverViewCellHeight = 40.f;   ///< cell指定高度
static CGFloat const kPopoverViewArrowHeight = 13.f;  ///< 箭头高度

static NSString *kPopoverCellReuseId = @"_PopoverCellReuseId";

float PopoverViewDegreesToRadians(float angle)
{
    return angle*M_PI/180;
}

@interface PVPopoverView () <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

#pragma mark - UI
@property (nonatomic, weak) UIWindow *keyWindow;                ///< 当前窗口
@property(nonatomic,strong)UIView * fatherView;//父视图（解决旋转问题）
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView;                ///< 遮罩层
@property (nonatomic, weak) CAShapeLayer *borderLayer;          ///< 边框Layer
@property (nonatomic, weak) UITapGestureRecognizer *tapGesture; ///< 点击背景阴影的手势

#pragma mark - Data
@property (nonatomic, copy) NSArray<PVPopoverAction *> *popoverActions;
@property (nonatomic, assign) CGFloat windowWidth;   ///< 窗口宽度
@property (nonatomic, assign) CGFloat windowHeight;  ///< 窗口高度
@property (nonatomic, assign) BOOL isUpward;         ///< 箭头指向, YES为向上, 反之为向下, 默认为YES.

@end

@implementation PVPopoverView

#pragma mark - Lift Cycle
- (instancetype)initWithFrame:(CGRect)frame  fatherView:(UIView *)fatherView
{
    if (!(self = [super initWithFrame:frame])) return nil;
    self.fatherView = fatherView;
    [self initialize];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _tableView.frame = CGRectMake(0, _isUpward ? kPopoverViewArrowHeight : 0,
                                  CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kPopoverViewArrowHeight);
}

#pragma mark - Setter
- (void)setHideAfterTouchOutside:(BOOL)hideAfterTouchOutside
{
    _hideAfterTouchOutside = hideAfterTouchOutside;
    _tapGesture.enabled = _hideAfterTouchOutside;
}

- (void)setShowShade:(BOOL)showShade
{
    _showShade = showShade;
    
    _shadeView.backgroundColor = _showShade ? [UIColor colorWithWhite:0.f alpha:0.18f] : [UIColor clearColor];
    
    if (_borderLayer) {
        
        _borderLayer.strokeColor = _showShade ? [UIColor clearColor].CGColor : _tableView.separatorColor.CGColor;
    }
}

- (void)setStyle:(PopoverViewStyle)style {
    _style = style;
    _tableView.separatorColor = [PVPopoverViewCell bottomLineColorForStyle:_style];
    
    if (_style == PopoverViewStyleDefault) {
        
        self.backgroundColor = [UIColor whiteColor];
    } else {
        
        self.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.00];
    }
}

- (void) setCurrentWidth:(CGFloat)currentWidth{
    _currentWidth = currentWidth;
}

#pragma mark - Private
/*! @brief 初始化相关 */
- (void)initialize
{
    // data
    _popoverActions = @[];
    _isUpward = YES;
    _style = PopoverViewStyleDefault;
    _arrowStyle = PopoverViewArrowStyleRound;
    
    // current view
    self.backgroundColor = [UIColor whiteColor];
    
    // keyWindow
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.bounds);
    _windowHeight = CGRectGetHeight(_keyWindow.bounds);
    
    // shadeView
    _shadeView = [[UIView alloc] initWithFrame:self.bounds];
    _shadeView.backgroundColor = [UIColor orangeColor];
    [self setShowShade:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    tapGesture.delegate = self;
    [_shadeView addGestureRecognizer:tapGesture];
    _tapGesture = tapGesture;
    
    // tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [PVPopoverViewCell bottomLineColorForStyle:_style];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0.0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.userInteractionEnabled = YES;
    [_tableView registerClass:[PVPopoverViewCell class] forCellReuseIdentifier:kPopoverCellReuseId];
    [self addSubview:_tableView];
}

/**
 显示弹窗指向某个点
 */
- (void)showToPoint:(CGPoint)toPoint
{
    // 截取弹窗时相关数据
    CGFloat arrowWidth = 28;
    CGFloat cornerRadius = 6.f;
    CGFloat arrowCornerRadius = 2.5f;
    CGFloat arrowBottomCornerRadius = 4.f;
    
    // 如果是菱角箭头的话, 箭头宽度需要小点.
    if (_arrowStyle == PopoverViewArrowStyleTriangle) {
        arrowWidth = 22.0;
    }
    
    // 如果箭头指向的点过于偏左或者过于偏右则需要重新调整箭头 x 轴的坐标
    CGFloat minHorizontalEdge = kPopoverViewMargin + cornerRadius + arrowWidth/2 + 2;
    if (toPoint.x < minHorizontalEdge) {
        toPoint.x = minHorizontalEdge;
    }
    if (CrossScreenWidth_X - toPoint.x < minHorizontalEdge) {
        toPoint.x = CrossScreenWidth_X - minHorizontalEdge;
    }
    
    // 遮罩层
    _shadeView.alpha = 0.f;
    [self.fatherView addSubview:_shadeView];
    
    // 刷新数据以获取具体的ContentSize
    [_tableView reloadData];
    if (!_currentWidth) {
        _currentWidth = [self calculateMaxWidth];
    }
    // 根据刷新后的ContentSize和箭头指向方向来设置当前视图的frame
//    CGFloat currentW = [self calculateMaxWidth]; // 宽度通过计算获取最大值
    CGFloat currentW = _currentWidth; // 宽度通过计算获取最大值
    CGFloat currentH = _tableView.contentSize.height;
    
    // 如果 actions 为空则使用默认的宽高
    if (_popoverActions.count == 0) {
        currentW = 150.0;
        currentH = 20.0;
    }
    
    // 箭头高度
    currentH += kPopoverViewArrowHeight;
    
    // 限制最高高度, 免得选项太多时超出屏幕
    CGFloat maxHeight = _isUpward ? (CrossScreenHeight_X - toPoint.y - kPopoverViewMargin) : (toPoint.y - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    if (currentH > maxHeight) { // 如果弹窗高度大于最大高度的话则限制弹窗高度等于最大高度并允许tableView滑动.
        currentH = maxHeight;
        _tableView.scrollEnabled = YES;
        if (!_isUpward) { // 箭头指向下则移动到最后一行
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_popoverActions.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    CGFloat currentX = toPoint.x - currentW/2, currentY = toPoint.y;
    // x: 窗口靠左
    if (toPoint.x <= currentW/2 + kPopoverViewMargin) {
        currentX = kPopoverViewMargin;
    }
    // x: 窗口靠右
    if (CrossScreenWidth_X - toPoint.x <= currentW/2 + kPopoverViewMargin) {
        currentX = CrossScreenWidth_X - kPopoverViewMargin - currentW;
    }
    // y: 箭头向下
    if (!_isUpward) {
        currentY = toPoint.y - currentH;
    }
    
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    
    // 截取箭头
    CGPoint arrowPoint = CGPointMake(toPoint.x - CGRectGetMinX(self.frame), _isUpward ? 0 : currentH); // 箭头顶点在当前视图的坐标
    CGFloat maskTop = _isUpward ? kPopoverViewArrowHeight : 0; // 顶部Y值
    CGFloat maskBottom = _isUpward ? currentH : currentH - kPopoverViewArrowHeight; // 底部Y值
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    // 左上圆角
    [maskPath moveToPoint:CGPointMake(0, cornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius + maskTop)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(180)
                      endAngle:PopoverViewDegreesToRadians(270)
                     clockwise:YES];
    // 箭头向上时的箭头位置
    if (_isUpward) {
        
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, kPopoverViewArrowHeight)];
        // 菱角箭头
        if (_arrowStyle == PopoverViewArrowStyleTriangle) {
            
            [maskPath addLineToPoint:arrowPoint];
            [maskPath addLineToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, kPopoverViewArrowHeight)];
        }
        else {
            
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, arrowCornerRadius)
                             controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, kPopoverViewArrowHeight)];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, arrowCornerRadius)
                             controlPoint:arrowPoint];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, kPopoverViewArrowHeight)
                             controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, kPopoverViewArrowHeight)];
        }
    }
    // 右上圆角
    [maskPath addLineToPoint:CGPointMake(currentW - cornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskTop + cornerRadius)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(270)
                      endAngle:PopoverViewDegreesToRadians(0)
                     clockwise:YES];
    // 右下圆角
    [maskPath addLineToPoint:CGPointMake(currentW, maskBottom - cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(0)
                      endAngle:PopoverViewDegreesToRadians(90)
                     clockwise:YES];
    // 箭头向下时的箭头位置
    if (!_isUpward) {
        
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + arrowWidth/2, currentH - kPopoverViewArrowHeight)];
        // 菱角箭头
        if (_arrowStyle == PopoverViewArrowStyleTriangle) {
            
            [maskPath addLineToPoint:arrowPoint];
            [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, currentH - kPopoverViewArrowHeight)];
        }
        else {
            
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, currentH - arrowCornerRadius)
                             controlPoint:CGPointMake(arrowPoint.x + arrowWidth/2 - arrowBottomCornerRadius, currentH - kPopoverViewArrowHeight)];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, currentH - arrowCornerRadius)
                             controlPoint:arrowPoint];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowWidth/2, currentH - kPopoverViewArrowHeight)
                             controlPoint:CGPointMake(arrowPoint.x - arrowWidth/2 + arrowBottomCornerRadius, currentH - kPopoverViewArrowHeight)];
        }
    }
    // 左下圆角
    [maskPath addLineToPoint:CGPointMake(cornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, maskBottom - cornerRadius)
                        radius:cornerRadius
                    startAngle:PopoverViewDegreesToRadians(90)
                      endAngle:PopoverViewDegreesToRadians(180)
                     clockwise:YES];
    [maskPath closePath];
    // 截取圆角和箭头
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    // 边框 (只有在不显示半透明阴影层时才设置边框线条)
    if (!_showShade) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = self.bounds;
        borderLayer.path = maskPath.CGPath;
        borderLayer.lineWidth = 1;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = _tableView.separatorColor.CGColor;
        [self.layer addSublayer:borderLayer];
        _borderLayer = borderLayer;
    }
    
    [self.fatherView addSubview:self];
    // 弹出动画
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x/currentW, _isUpward ? 0.f : 1.f);
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        _shadeView.alpha = 1.f;
    }];
}

/*! @brief 计算最大宽度 */
- (CGFloat)calculateMaxWidth
{
    CGFloat maxWidth = 0.f, titleLeftEdge = 0.f, imageWidth = 0.f, imageMaxHeight = kPopoverViewCellHeight - PopoverViewCellVerticalMargin*2;
    CGSize imageSize = CGSizeZero;
    UIFont *titleFont = [PVPopoverViewCell titleFont];
    
    for (PVPopoverAction *popoverAction in _popoverActions) {
        
        imageWidth = 0.f;
        titleLeftEdge = 0.f;
        
        if (popoverAction.image) { // 存在图片则根据图片size和图片最大高度来重新计算图片宽度
            
            titleLeftEdge = PopoverViewCellTitleLeftEdge; // 有图片时标题才有左边的边距
            imageSize = popoverAction.image.size;
            
            if (imageSize.height > imageMaxHeight) {
                
                imageWidth = imageMaxHeight*imageSize.width/imageSize.height;
            }
            else {
                
                imageWidth = imageSize.width;
            }
        }
        
        CGFloat titleWidth;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) { // iOS7及往后版本
            titleWidth = [popoverAction.title sizeWithAttributes:@{NSFontAttributeName : titleFont}].width;
        } else { // iOS6
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            titleWidth = [popoverAction.title sizeWithFont:titleFont].width;
#pragma GCC diagnostic pop
        }
        
        CGFloat contentWidth = PopoverViewCellHorizontalMargin*2 + imageWidth + titleLeftEdge + titleWidth;
        if (contentWidth > maxWidth) {
            maxWidth = ceil(contentWidth); // 获取最大宽度时需使用进一取法, 否则Cell中没有图片时会可能导致标题显示不完整.
        }
    }
    
    // 如果最大宽度大于(窗口宽度 - kPopoverViewMargin*2)则限制最大宽度等于(窗口宽度 - kPopoverViewMargin*2)
    if (maxWidth > CGRectGetWidth(_keyWindow.bounds) - kPopoverViewMargin*2) {
        maxWidth = CGRectGetWidth(_keyWindow.bounds) - kPopoverViewMargin*2;
    }
    
    return maxWidth;
}

/**
 点击外部隐藏弹窗
 */
- (void)hide
{
    
    _shadeView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        _shadeView.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [_shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - Public
+ (instancetype)popoverView:(UIView *)fatherView
{
   
    return [[self alloc] initWithFrame:CGRectZero fatherView:fatherView];
}

- (void)showToView:(UIView *)pointView withActions:(NSArray<PVPopoverAction *> *)actions
{
    // 判断 pointView 是偏上还是偏下
    CGRect pointViewRect = [pointView.superview convertRect:pointView.frame toView:self.fatherView];
    CGFloat pointViewUpLength = CGRectGetMinY(pointViewRect);
    CGFloat pointViewDownLength = CrossScreenHeight_X - CGRectGetMaxY(pointViewRect);
    // 弹窗箭头指向的点
//    CGPoint toPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);
    CGPoint toPoint = CGPointMake(pointViewRect.origin.x + 20, 30);
    // 弹窗在 pointView 顶部
    if (pointViewUpLength > pointViewDownLength) {
        toPoint.y = pointViewUpLength - 10;
    }
    // 弹窗在 pointView 底部
    else {
        toPoint.y = CGRectGetMaxY(pointViewRect) + 5;
    }
    
    // 箭头指向方向
    _isUpward = pointViewUpLength <= pointViewDownLength;
    
    if (!actions) {
        _popoverActions = @[];
    } else {
        _popoverActions = [actions copy];
    }
    
    [self showToPoint:toPoint];
}

- (void)showToPoint:(CGPoint)toPoint withActions:(NSArray<PVPopoverAction *> *)actions
{
    if (!actions) {
        _popoverActions = @[];
    } else {
        _popoverActions = [actions copy];
    }
    
    // 计算箭头指向方向
    _isUpward = toPoint.y <= CrossScreenHeight_X - toPoint.y;
    
    [self showToPoint:toPoint];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _popoverActions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPopoverViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PVPopoverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopoverCellReuseId];
    cell.style = _style;
    [cell setAction:_popoverActions[indexPath.row]];
    // 最后一个不显示分割线
    //    [cell showBottomLine: indexPath.row < _actions.count - 1];
    // 不显示分割线
    [cell showBottomLine:0];
    
    return cell;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        _shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        PVPopoverAction *popoverAction = _popoverActions[indexPath.row];
        popoverAction.handler ? popoverAction.handler(popoverAction) : NULL;
        _popoverActions = nil;
        [_shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end

