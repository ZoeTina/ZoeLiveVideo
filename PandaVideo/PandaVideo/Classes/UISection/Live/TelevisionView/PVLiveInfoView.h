//
//  PVLiveInfoView.h
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义block类型把点击事件传入到Controller中
typedef void (^ProgramBtnClickedBlock) (UIButton*);
typedef void (^ScreenBtnClickedBlock) ();
typedef void (^ShakeBtnClickedBlock) ();


@interface PVLiveInfoView : UIView

@property(nonatomic, strong)UILabel* titleLabel;

@property(nonatomic, strong)UIButton* programeBtn;


///各种点击事件回调
-(void) setProgramBtnClickedBlock:(ProgramBtnClickedBlock)block;
-(void) setScreenBtnClickedBlock:(ScreenBtnClickedBlock)block;
-(void) setShakeBtnClickedBlock:(ShakeBtnClickedBlock)block;

@end
