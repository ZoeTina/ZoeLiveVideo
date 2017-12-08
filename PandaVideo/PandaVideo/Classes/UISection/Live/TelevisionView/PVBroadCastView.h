//
//  PVBroadCastView.h
//  PandaVideo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PVBroadCastViewCallBlock)(BOOL isSelected);

@interface PVBroadCastView : UIView

@property (weak, nonatomic) IBOutlet UILabel *FMTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *FMPlayOrStopBtn;
@property (weak, nonatomic) IBOutlet UIButton *flowPlayCenterBtn;
@property (weak, nonatomic) IBOutlet UIView *orderView;

///2:显示内容只能自省内播放, 6:走订购流程
@property (nonatomic, assign)NSInteger authenticationType;

@property (nonatomic, weak) UIViewController* jumpVC;

//是否显示动画
@property(nonatomic, assign)BOOL isDispLayAnimate;

-(void)setPVBroadCastViewCallBlock:(PVBroadCastViewCallBlock)block;

@end
