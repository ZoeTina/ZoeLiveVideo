//
//  PVShowShareView.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVShowShareView.h"

@interface PVShowShareView ()
{
    UIView *_contentView;
    
}

@property (nonatomic, assign) CGFloat    viewHeight;
@property (nonatomic, assign) CGFloat    viewY;
@property (nonatomic, strong) IBOutlet UIButton *weixin;

@property (nonatomic, strong) UIView *lineView;     // 分割线
@property (nonatomic, strong) PVShowShareView *showShareView;
@end


@implementation PVShowShareView
- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        _viewHeight = 274;  // 弹出View的高度
        _viewY = YYScreenHeight - _viewHeight;
        
//        [self initContent];
    }
    
    return self;
}

+ (PVShowShareView *)loadXibView {
    return [[[NSBundle mainBundle] loadNibNamed:@"PVShowShareView" owner:nil options:nil] lastObject];
}

- (void)initContent
{
    self.frame = CGRectMake(0, 0, YYScreenWidth, YYScreenHeight);
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, _viewY, YYScreenWidth, _viewHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    
        [_contentView addSubview:self.showShareView];
    }
}

/** 分享 */
-(PVShowShareView *)showShareView{
    if (!_showShareView) {
        _showShareView = [PVShowShareView loadXibView];
        _showShareView.frame = CGRectMake(0, 0, ScreenWidth, _viewHeight);
        _showShareView.backgroundColor = [UIColor clearColor];
    }
    return _showShareView;
}


//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, YYScreenHeight, YYScreenWidth, _viewHeight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, _viewY, YYScreenWidth, _viewHeight)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    [_contentView setFrame:CGRectMake(0, _viewY, YYScreenWidth, _viewHeight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, YYScreenHeight, YYScreenWidth, _viewHeight)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
}

@end
