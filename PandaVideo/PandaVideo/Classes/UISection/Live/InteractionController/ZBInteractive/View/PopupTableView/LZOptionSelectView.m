//
//  LZOptionSelectView.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "LZOptionSelectView.h"

static NSInteger maxOption = 6;//默认最大6行

static CGFloat arrow_H = 8;//箭头高
static CGFloat arrow_W = 15;//箭头宽

@interface LZOptionSelectView () <UITableViewDelegate,UITableViewDataSource>
{
    /** 向下或者向上展开超出屏幕时偏移的距离 */
    CGFloat _start_offSetY;
    CGFloat _start_offSetX;
    
    
    /** 箭头的三个顶点坐标 */
    CGPoint arrow1;
    CGPoint arrow2;
    CGPoint arrow3;
    
    CAShapeLayer *arrow_layer;
    /** 弹出动画点 */
    CGPoint point;
    /** 弹出之后的宽高 */
    CGFloat viewHeight;
    CGFloat viewWidth;
    /** 弹出之后的起点 */
    CGPoint startPoint;
    /** 箭头高 */
    CGFloat arrowHeight;
    /** 显示时的行数 */
    CGFloat end_Line;
    /** cell行高 */
    CGFloat cell_height;
    
    /** 是否有参照view */
    UIView *_targetView;
    /** targetRect */
    CGRect _targetRect;
    /** 弹出点在对应方向上的比例 */
    CGFloat _target_scale;
    /** 是否翻转 */
    BOOL overturn;
    /** 锚点 */
    CGPoint anchorPoint;
}
/** 弹出朝向 */
@property (nonatomic, assign) LZOptionSelectViewDirection diretionType;
/** 显示的view */
@property (nonatomic, strong) UIView *showView;
/** 背景层(遮盖层) */
@property (nonatomic, strong) UIView *coverView;
/** 箭头顶点的位置和动画开始位置 */
@property (nonatomic, assign) CGFloat arrow_offset;//(0 - 1之间)

@end

@implementation LZOptionSelectView

#pragma mark - 初始化
- (instancetype)initOptionView {
    if (self = [super initWithFrame:CGRectZero style:UITableViewStylePlain]) {
        self.delegate = self;
        self.dataSource = self;
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = YES;// 是否禁止回弹
        self.scrollEnabled = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self initSetting];
    }
    return self;
}

#pragma mark - 默认设置
- (void)initSetting {
    _maxLine = maxOption;
    cell_height = 40.f;
    _cornerRadius = 5;
    self.backColor = [UIColor whiteColor];
    _coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    _edgeInsets = UIEdgeInsetsZero;
}

- (void)setIsScrollEnabled:(BOOL)isScrollEnabled{
    
    _isScrollEnabled = isScrollEnabled;
    self.scrollEnabled = _isScrollEnabled;
}

- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    self.backgroundColor = _backColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

#pragma mark - 计算弹出位置
+ (CGRect)targetView:(UIView *)targetView {
    CGRect rect = [kKeyWindow convertRect:targetView.frame fromView:targetView.superview];
    return rect;
}

#pragma mark - 显示多少行
- (CGFloat)showLine {
    NSInteger row = _rowNumber?_rowNumber():0;
    NSInteger line = MIN(row, _maxLine);
    return line;
}


#pragma mark - 弹出之前计算行数、高度等
- (void)beforeShowWidth:(CGFloat)width
             targetView:(UIView *)targetView {
    
    //显示行数
    end_Line = [self showLine];
    if (end_Line == 0) {
        return;
    }
    [self reloadData];
    _targetView = targetView;
    
    //箭头高度
    if (_optionType == LZOptionSelectViewTypeArrow) {
        arrowHeight = arrow_H;
    } else {
        arrowHeight = 0;
    }
    //宽高
    cell_height = _optionCellHeight?_optionCellHeight():cell_height;
    viewWidth = MIN(width,kScreenWidth - _edgeInsets.left - _edgeInsets.right);
    end_Line = MIN(end_Line, (kScreenHeight - _edgeInsets.top - _edgeInsets.bottom)/cell_height);
    viewHeight = end_Line * cell_height;
    
    
    //添加视图
    [self.showView addSubview:self];
//    [self addConstraintToCover];
}

#pragma mark - 弹出的方法
- (void)showTapPoint:(CGPoint)tapPoint
           viewWidth:(CGFloat)width
           direction:(LZOptionSelectViewDirection)directionType {
    //优先弹出方向
    [kKeyWindow addSubview:self.coverView];
    self.coverView.frame =kKeyWindow.bounds;
    _diretionType = directionType;
    [self beforeShowWidth:width targetView:nil];
    point = tapPoint;
    //调节显示
    [self showByDiretionType];
    
    [self showAndDraw];
}
//弹出视图 - 横图
- (void)showHoTapPoint:(CGPoint)tapPoint
             viewWidth:(CGFloat)width
             direction:(LZOptionSelectViewDirection)directionType
            fatherView:(UIView *)fatherView{
    
    [fatherView addSubview:self.coverView];
    self.coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //优先弹出方向
    _diretionType = directionType;
    [self beforeShowWidth:width targetView:nil];
    point = tapPoint;
    //调节显示
    [self showByDiretionType];
    
    self.showView.layer.anchorPoint = anchorPoint;
    self.size = CGSizeMake(viewWidth, viewHeight);
    //startPoint计算是以self为准，此处变换为backView
    CGRect showFrame;
    switch (_diretionType) {
        case LZOptionSelectViewTop:
        case LZOptionSelectViewBottom:
        {
            viewHeight = viewHeight + arrowHeight;
            self.origin = CGPointMake(0, arrowHeight * (1 - anchorPoint.y));
        }
            break;
        case LZOptionSelectViewLeft:
        case LZOptionSelectViewRight:
        {
            viewWidth = viewWidth + arrowHeight;
            self.origin = CGPointMake(arrowHeight * (1 - anchorPoint.x), 0);
        }
            break;
        default:
            break;
    }
    startPoint = CGPointMake(MIN(kScreenWidth - _edgeInsets.right - viewWidth, MAX(_edgeInsets.left, point.x - viewWidth * anchorPoint.x)), MIN(kScreenHeight - _edgeInsets.bottom - viewHeight, MAX(_edgeInsets.top, point.y - viewHeight* anchorPoint.y)));
    showFrame = CGRectMake(startPoint.x, startPoint.y, viewWidth, viewHeight);
    self.showView.frame = showFrame;
    [fatherView addSubview:self.showView];
    
    if (_optionType == LZOptionSelectViewTypeArrow) {
        [self drowArrow];
    } else {
        if (arrow_layer) {
            [arrow_layer removeFromSuperlayer];
            arrow_layer = nil;
        }
    }
    [self animation_show];
}
#pragma mark - 弹出的方法
- (void)showOffSetScale:(CGFloat)offset_Scale
              viewWidth:(CGFloat)width
             targetView:(UIView *)targetView
              direction:(LZOptionSelectViewDirection)directionType {
    //优先弹出方向
    _diretionType = directionType;
    [self beforeShowWidth:width targetView:targetView];
    _targetRect = [LZOptionSelectView targetView:targetView];
    switch (_diretionType) {
        case LZOptionSelectViewTop:
        case LZOptionSelectViewBottom:
        {
            CGFloat edgeScale = _cornerRadius/_targetRect.size.width;
            _target_scale = MIN(1 - edgeScale, MAX(edgeScale, offset_Scale));
            point = CGPointMake(_targetRect.origin.x + _targetRect.size.width * _target_scale, _targetRect.origin.y + (directionType == LZOptionSelectViewTop?0:_targetRect.size.height));
        }
            break;
        case LZOptionSelectViewLeft:
        case LZOptionSelectViewRight:
        {
            CGFloat edgeScale = _cornerRadius/_targetRect.size.height;
            _target_scale = MIN(1 - edgeScale, MAX(edgeScale, offset_Scale));
            point = CGPointMake(_targetRect.origin.x + (directionType == LZOptionSelectViewLeft?0:_targetRect.size.width), _targetRect.origin.y + _targetRect.size.height * _target_scale);
        }
            break;
        default:
            break;
    }
    
    //调节显示
    [self showByDiretionType];
    
    [self showAndDraw];
}

#pragma mark - 弹出的方法
- (void)showViewCenter:(CGPoint)viewCenter
             viewWidth:(CGFloat)width {
    _optionType = LZOptionSelectViewTypeCustom;
    [self beforeShowWidth:width targetView:nil];
    anchorPoint = CGPointMake(.5,.5);
    point = viewCenter;
    viewWidth = MIN(viewWidth, MIN(viewCenter.x - _edgeInsets.left, kScreenWidth - viewCenter.x - _edgeInsets.right)*2);
    CGFloat maxHeight = MIN(end_Line * cell_height, kScreenHeight - _edgeInsets.top - _edgeInsets.bottom);
    viewHeight = MIN(maxHeight, MIN(viewCenter.y - _edgeInsets.top, kScreenHeight - viewCenter.y - _edgeInsets.bottom)*2);
    [self showAndDraw];
}

#pragma mark - 改变弹出方向
- (void)showByDiretionType {
    _start_offSetY = _targetView?_targetView.height:0;
    _start_offSetX = _targetView?_targetView.width:0;
    viewHeight = end_Line * cell_height;
    switch (_diretionType) {
        case LZOptionSelectViewBottom:
        {
            if ((kScreenHeight - point.y - arrowHeight - _edgeInsets.bottom) > viewHeight ||(point.y - _edgeInsets.top - _start_offSetY) < (kScreenHeight - _edgeInsets.top - _edgeInsets.bottom - _start_offSetY)/2 ) {
                self.diretionType = LZOptionSelectViewBottom;
            } else {
                point.y -= _start_offSetY;
                self.diretionType = LZOptionSelectViewTop;
            }
        }
            break;
        case LZOptionSelectViewTop:
        {
            if ((point.y - arrowHeight - _edgeInsets.top) > viewHeight || (point.y - _edgeInsets.top) > (kScreenHeight - _edgeInsets.top - _edgeInsets.bottom - _start_offSetY)/2) {
                self.diretionType = LZOptionSelectViewTop;
            } else {
                point.y += _start_offSetY;
                self.diretionType = LZOptionSelectViewBottom;
            }
        }
            break;
        case LZOptionSelectViewLeft:
        {
            if ((point.x- arrowHeight - _edgeInsets.left) >viewWidth || (point.x - _edgeInsets.left) > (kScreenWidth - _edgeInsets.left - _edgeInsets.right- _start_offSetX)/2) {//左
                self.diretionType = LZOptionSelectViewLeft;
            } else {
                point.x += _start_offSetX;
                self.diretionType = LZOptionSelectViewRight;
            }
        }
            break;
        case LZOptionSelectViewRight:
        {
            if ((kScreenWidth-point.x-arrowHeight - _edgeInsets.right)>viewWidth || (point.x - _edgeInsets.left - _start_offSetX) < (kScreenWidth - _edgeInsets.left - _edgeInsets.right - _start_offSetX)/2 ) {
                self.diretionType = LZOptionSelectViewRight;
            } else {
                point.x -= _start_offSetX;
                self.diretionType = LZOptionSelectViewLeft;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 计算后的展示方向
- (void)setDiretionType:(LZOptionSelectViewDirection)diretionType {
    _diretionType = diretionType;
    switch (diretionType) {
        case LZOptionSelectViewBottom:
        case LZOptionSelectViewTop:
        {
            if (point.x <= (viewWidth/2 + _edgeInsets.left)) {
                _arrow_offset = (point.x - _edgeInsets.left)/ viewWidth;
            } else if (point.x > (viewWidth/2 + _edgeInsets.left)&& point.x <= (kScreenWidth - viewWidth/2  - _edgeInsets.right)) {
                _arrow_offset = .5;
            } else {
                _arrow_offset = (1 - (kScreenWidth - point.x - _edgeInsets.right) / viewWidth);
            }
            CGFloat edgeScale = _cornerRadius/viewWidth;
            _arrow_offset = MIN(1 - edgeScale, MAX(edgeScale, _arrow_offset));
            if (_diretionType == LZOptionSelectViewTop) {
                end_Line = MIN(end_Line, (point.y-arrowHeight- _edgeInsets.top)/cell_height);
                anchorPoint = CGPointMake(_arrow_offset, 1);
            } else {
                end_Line = MIN(end_Line, (kScreenHeight - point.y-arrowHeight - _edgeInsets.bottom)/cell_height);
                anchorPoint = CGPointMake(_arrow_offset,0);
            }
            viewHeight = end_Line * cell_height;
        }
            break;
        case LZOptionSelectViewLeft:
        case LZOptionSelectViewRight:
        {
            if (point.y <= (viewHeight/2 + _edgeInsets.top)) {
                _arrow_offset = (point.y - _edgeInsets.top)/ viewHeight;
            } else if (point.y > (viewHeight/2 + _edgeInsets.top)&& point.y <= (kScreenHeight - viewHeight/2 - _edgeInsets.bottom)) {
                _arrow_offset = .5;
            } else {
                _arrow_offset = (1 - (kScreenHeight - point.y - _edgeInsets.bottom) / viewHeight);
            }
            CGFloat edgeScale = _cornerRadius/viewWidth;
            _arrow_offset = MIN(1 - edgeScale, MAX(edgeScale, _arrow_offset));
            if (_diretionType == LZOptionSelectViewLeft) {
                viewWidth = MIN(viewWidth, point.x - arrowHeight - _edgeInsets.left);
                anchorPoint = CGPointMake(1, _arrow_offset);
            } else {
                viewWidth = MIN(viewWidth, kScreenWidth - point.x-arrowHeight-_edgeInsets.right);
                anchorPoint = CGPointMake(0, _arrow_offset);
            }
        }
            break;
        default:
            break;
    }
    
}


#pragma mark - showAndDraw
- (void)showAndDraw {
    self.showView.layer.anchorPoint = anchorPoint;
    self.size = CGSizeMake(viewWidth, viewHeight);
    //startPoint计算是以self为准，此处变换为backView
    CGRect showFrame;
    switch (_diretionType) {
        case LZOptionSelectViewTop:
        case LZOptionSelectViewBottom:
        {
            viewHeight = viewHeight + arrowHeight;
            self.origin = CGPointMake(0, arrowHeight * (1 - anchorPoint.y));
        }
            break;
        case LZOptionSelectViewLeft:
        case LZOptionSelectViewRight:
        {
            viewWidth = viewWidth + arrowHeight;
            self.origin = CGPointMake(arrowHeight * (1 - anchorPoint.x), 0);
        }
            break;
        default:
            break;
    }
    startPoint = CGPointMake(MIN(kScreenWidth - _edgeInsets.right - viewWidth, MAX(_edgeInsets.left, point.x - viewWidth * anchorPoint.x)), MIN(kScreenHeight - _edgeInsets.bottom - viewHeight, MAX(_edgeInsets.top, point.y - viewHeight* anchorPoint.y)));
    showFrame = CGRectMake(startPoint.x, startPoint.y, viewWidth, viewHeight);
    self.showView.frame = showFrame;
    [kKeyWindow addSubview:self.showView];
    
    if (_optionType == LZOptionSelectViewTypeArrow) {
        [self drowArrow];
    } else {
        if (arrow_layer) {
            [arrow_layer removeFromSuperlayer];
            arrow_layer = nil;
        }
    }
    [self animation_show];
}



#pragma mark - showView
- (UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc] init];
        _showView.backgroundColor = [UIColor clearColor];
    }
    return _showView;
}
#pragma mark - 画箭头
- (void)drowArrow {
    //根据锚点的位置画箭头
    arrow1 = CGPointMake(viewWidth * anchorPoint.x , viewHeight * anchorPoint.y);
    switch (_diretionType) {
        case LZOptionSelectViewBottom:
        case LZOptionSelectViewTop:
        {
            CGFloat bottomY = anchorPoint.y==0?(arrowHeight):(viewHeight - arrowHeight);
            arrow2 = CGPointMake(arrow1.x + (arrow_W/2 >= viewWidth*(1-anchorPoint.x)?0:arrow_W/2),bottomY);
            arrow3 = CGPointMake(arrow1.x - (arrow_W/2 >= viewWidth*anchorPoint.x?0:arrow_W/2), bottomY);
        }
            break;
        case LZOptionSelectViewRight:
        case LZOptionSelectViewLeft:
        {
            CGFloat bottomX = anchorPoint.x==0?(arrowHeight):(viewWidth - arrowHeight);
            arrow2 = CGPointMake(bottomX, arrow1.y + (arrow_W/2 >= viewHeight*(1-anchorPoint.y)?0:arrow_W/2));
            arrow3 = CGPointMake(bottomX, arrow1.y - (arrow_W/2 >= viewHeight*anchorPoint.y?0:arrow_W/2));
        }
            break;
        default:
            break;
    }
    if (!arrow_layer) {
        arrow_layer = [[CAShapeLayer alloc] init];
        arrow_layer.fillColor = _backColor.CGColor;
        [self.showView.layer addSublayer:arrow_layer];
    }
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:arrow1];
    [arrowPath addLineToPoint:arrow2];
    [arrowPath addLineToPoint:arrow3];
    [arrowPath closePath];
    arrow_layer.path = arrowPath.CGPath;
}


#pragma mark - 动画
- (void)animation_show {
    [self zoomOrOn];
    [UIView animateWithDuration:.3 animations:^{
        self.coverView.alpha = .3;
        self.showView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        [self zoomOrOn];
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        self.showView.transform= CGAffineTransformIdentity;
        [self.showView removeFromSuperview];
        [self.coverView removeFromSuperview];
    }];
}

#pragma mark - 是缩放或者展开
- (void)zoomOrOn {
    if (_vhShow) {
        if (_diretionType==LZOptionSelectViewBottom || _diretionType==LZOptionSelectViewTop){
            self.showView.transform = CGAffineTransformMakeScale(1, 0.001);
        } else {
            self.showView.transform = CGAffineTransformMakeScale(0.001, 1);
        }
    } else {
        self.showView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    }
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rowNumber?_rowNumber():0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cell) {
        UITableViewCell *cell = _cell(indexPath);
        cell.contentView.backgroundColor = _backColor;
        cell.backgroundColor = _backColor;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    } else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _optionCellHeight?_optionCellHeight():cell_height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedOption) {
        self.selectedOption(indexPath);
    }
    if (!_multiSelect) {
        [self dismiss];
    }
}

#pragma mark - TableView 是否可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return _canEdit;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.removeOption) {
            self.removeOption(indexPath);
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf changgeFrame];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}


#pragma mark - 删除之后改变frame
- (void)changgeFrame {
    if ([self showLine] == 0) {
        [self dismiss];
    }
    if (end_Line <= [self showLine]) {
        return;
    }
    CGFloat less = MIN(1, end_Line - [self showLine]) * cell_height;
    viewHeight -= less;
    self.height -= less;
    self.showView.height = viewHeight;
    if (_optionType == LZOptionSelectViewTypeArrow) {
        [self drowArrow];
    }
    [UIView animateWithDuration:.3 animations:^{
        self.showView.y += less * anchorPoint.y;
    }];
}

#pragma mark - cover
- (void)setCoverColor:(UIColor *)coverColor {
    _coverColor = coverColor;
    self.coverView.backgroundColor = _coverColor;
}

//- (void)addConstraintToCover {
//    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:_coverView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem: attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
//    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:_coverView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
//    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:_coverView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
//    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:_coverView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
//    [self addConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
//}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = _coverColor;
        _coverView.alpha = 0;
        _coverView.translatesAutoresizingMaskIntoConstraints = NO;
        __weak typeof(self) weakself = self;
        [_coverView tapHandle:^{
            [weakself dismiss];
        }];
    }
    return _coverView;
}
@end
