//
//  PVPresentViewCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPresentViewCell.h"

#define Duration 0.2

@interface PVPresentViewCell ()

/** 选择的礼物数量 */
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, weak) PVPresentLable *shakeLable;
/** 记录cell最初始的frame(即开始展示动画前的frame) */
@property (nonatomic, assign) CGRect originalFrame;
/** shake动画的缓存数组 */
@property (nonatomic, strong) NSMutableArray *caches;

@end

@implementation PVPresentViewCell

#pragma mark - Setter/Getter
- (NSMutableArray *)caches
{
    if (!_caches) {
        _caches = [NSMutableArray array];
    }
    return _caches;
}

#pragma mark - Initial(初始化)
- (instancetype)initWithRow:(NSInteger)row
{
    if (self = [super init]) {
        _row              = row;
        _state            = AnimationStateNone;
    }
    return self;
}

-(void)setGiftNum:(NSInteger)giftNum{
    _giftNum = giftNum;
//    self.gitfModel.giftNumber = giftNum;
    YYLog(@"self.gitfModel.giftNumber -- %ld",(long)self.gitfModel.giftNumber);
}

#pragma mark - Private
/**
 *  添加连乘lable
 */
- (void)addShakeLable
{
    PVPresentLable *lable   = [[PVPresentLable alloc] init];
    lable.backgroundColor   = [UIColor clearColor];
    lable.borderColor       = kColorWithRGB(228,152,54);    // X数字描边颜色
    lable.textColor         = kColorWithRGB(252,255,179);    // X数字字体颜色
    lable.font              = [UIFont systemFontOfSize:15.0];
    lable.textAlignment     = NSTextAlignmentCenter;
    lable.alpha             = 0.0;
    CGFloat w               = 60;
    CGFloat h               = 20;
    CGFloat x               = CGRectGetWidth(self.frame);
    CGFloat y               = 10;
    lable.frame             = CGRectMake(x, y, w, h);
    self.shakeLable         = lable;
    [self addSubview:lable];
}

/**
 *  开始连乘动画(利用递归实现连乘动画)
 *
 *  @param number 连乘次数
 *  @param block  当前number次连乘动画执行完成回调
 */
- (void)startShakeAnimationWithNumber:(NSInteger)number completion:(void (^)(BOOL finished))block
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];//取消上次的延时隐藏动画
    [self performSelector:@selector(hiddenAnimationOfShowShake:) withObject:@(YES) afterDelay:self.showTime];
    self.number++;
    if ([self.gitfModel giftNumber] > 0) {
        
//        self.number        = [self.gitfModel giftNumber];
        self.number = self.gitfModel.giftTotal - number + [self.gitfModel giftNumber];
    }
    _state                 = AnimationStateShaking;
    NSString *txtStr   = [NSString stringWithFormat:@"x%ld", self.number];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:txtStr];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:15.0]
                    range:NSMakeRange(0, 1)];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:22.0]
                    range:NSMakeRange(1, txtStr.length-1)];
    self.shakeLable.attributedText = attrStr;
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180), 1, 0, 0);
    self.shakeLable.transform = matrix;
    
    __weak typeof(self) ws = self;
    [self.shakeLable startAnimationDuration:Duration completion:^(BOOL finish) {
        if (number > 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ws startShakeAnimationWithNumber:(number - 1) completion:block];
            });
        }else {
            _state = AnimationStateShaked;
            if (block) {
                block(YES);
            }
        }
    }];
}

#pragma mark - Public
- (void)showAnimationWithModel:(id<PVPresentModelAble>)model showShakeAnimation:(BOOL)flag prepare:(void (^)(void))prepare completion:(void (^)(BOOL))completion
{
    _sender            = [model sender];
    _giftName          = [model giftName];
    _gitfModel         = model;
    _state             = AnimationStateShowing;
    self.originalFrame = self.frame;
    self.number        = 0;
    if (prepare) {
        prepare();
    }
    [UIView animateWithDuration:Duration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self customDisplayAnimationOfShowShakeAnimation:flag];
    } completion:^(BOOL finished) {
        if (flag) {
            if (!self.shakeLable) {
                [self addShakeLable];
            }
            self.shakeLable.alpha = 1.0;
        }
        if (completion) {
            completion(flag);
        }
    }];
}

- (void)shakeAnimationWithNumber:(NSInteger)number
{
    if (number > 0) [self.caches addObject:@(number)];
    if (self.caches.count > 0 && _state != AnimationStateShaking) {
        NSInteger cache        = [self.caches.firstObject integerValue];
        // 不能删除对象，因为可能有相同的对象
        [self.caches removeObjectAtIndex:0];
        __weak typeof(self) weakSelf = self;//
        [self startShakeAnimationWithNumber:cache completion:^(BOOL finished) {
            // 传-1是为了缓存不被重复添加
            [weakSelf shakeAnimationWithNumber:-1];
        }];
    }
}

- (void)hiddenAnimationOfShowShake:(BOOL)flag
{
    _state = AnimationStateHiding;
    [UIView animateWithDuration:Duration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self customHideAnimationOfShowShakeAnimation:flag];
    } completion:^(BOOL finished) {
        // 恢复cell的初始状态
        self.frame            = self.originalFrame;
        _state                = AnimationStateNone;
        _sender               = nil;
        _giftName             = nil;
        self.shakeLable.alpha = 0.0;
        [self.caches removeAllObjects];
        
        //通知代理
        if ([self.delegate respondsToSelector:@selector(presentViewCell:showShakeAnimation:shakeNumber:)]) {
            [self.delegate presentViewCell:self showShakeAnimation:flag shakeNumber:self.number];
        }
    }];
}

//目前还没有使用
- (void)releaseVariable
{
//    [self.shakeLable removeFromSuperview];
}

@end

@implementation PVPresentViewCell (OverWrite)

- (void)customDisplayAnimationOfShowShakeAnimation:(BOOL)flag
{
    self.alpha     = 1.0;
    CGRect selfF   = self.frame;
    selfF.origin.x = 0;
    self.frame     = selfF;
}

- (void)customHideAnimationOfShowShakeAnimation:(BOOL)flag
{
    self.alpha     = 0.0;
    CGRect selfF   = self.frame;
    selfF.origin.y -= (CGRectGetHeight(selfF) * 0.5);
    self.frame     = selfF;
}

@end

@implementation PVPresentLable

- (void)drawTextInRect:(CGRect)rect
{
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 5);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.borderColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
}

- (void)startAnimationDuration:(NSTimeInterval)interval completion:(void (^)(BOOL finish))completion
{
    // 相对于3秒(Duration)所开始的时间（第0秒开始动画）
    [UIView animateKeyframesWithDuration:interval delay:0 options:0 animations:^{
         // 相对于3秒(Duration)动画的持续时间（动画持续2秒）
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1/2.0 animations:^{
            self.transform = CGAffineTransformMakeScale(2, 2);
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations:^{
            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        }];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
        
    }];
}

@end
