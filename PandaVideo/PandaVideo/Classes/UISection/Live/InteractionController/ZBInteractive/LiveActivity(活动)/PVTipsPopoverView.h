//
//  PVTipsPopoverView.h
//  PandaVideo
//
//  Created by Ensem on 2017/11/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CallBackBlcok) (NSInteger idx);//1

//@protocol PVTipsPopoverViewDelegate <NSObject>
//@optional
//- (void) didShowTipsPopoverButtonClick:(UIButton *) sender;
//@end
@interface PVTipsPopoverView : UIView

@property (nonatomic,copy)CallBackBlcok callBackBlock;//2
@property (nonatomic, copy) void (^jumpCallBlock)(NSInteger idx);
@property(nonatomic,strong)UIView * coverView;
////加载xib
//+ (PVTipsPopoverView *)loadXibView;

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view;
//展示从底部向上弹出的UIView（包含遮罩）
- (void)showNoWindowInView:(UIView *)view;
- (void)disMissView;
//@property (nonatomic, weak) id<PVTipsPopoverViewDelegate> delegate;  //实现代理

@end
