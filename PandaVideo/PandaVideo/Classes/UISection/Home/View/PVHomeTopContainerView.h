//
//  PVHomeTopContainerView.h
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSegmentTitleView.h"
#import "PVSearchBar.h"
#import "PVHomModel.h"
#import "PVHistoryModel.h"

//定义block类型把点击事件传入到Controller中
typedef void (^SearchBarBlock) (void);
typedef void (^TimeBtnClickedBlock) (void);
typedef void (^ShakeBtnClickedBlock) (void);
typedef void (^EditColumnBlock) (void);
typedef void(^ContinueVideoTapGestureClicked)(PVHistoryModel* historyModel);

@interface PVHomeTopContainerView : UIView

///标题栏
@property(nonatomic, strong)SCSegmentTitleView* titleView;
///搜索框
@property(nonatomic, strong)PVSearchBar* searchBar;
///第一个按钮
@property(nonatomic, strong)UIButton* timeBtn;
///第二个按钮
@property(nonatomic, strong)UIButton* shakeBtn;
///哪个类型
@property(nonatomic, assign)NSInteger type;
///是否要隐藏titleView
@property(nonatomic, assign)BOOL isHiddenTitleView;
///数据源
@property(nonatomic, strong)PVHomModel* model;
///续看view
@property(nonatomic, strong)UIView* continueVideoView;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr delegate:(id<SCSegmentTitleViewDelegate>)delegate;

///各种点击事件回调
-(void) setSearchBarClickedBlock:(SearchBarBlock)block;
-(void) setTimeBtnClickedBlock:(TimeBtnClickedBlock)block;
-(void) setShakeBtnClickedBlock:(ShakeBtnClickedBlock)block;
-(void) setEditBtnClickedBlock:(EditColumnBlock)block;
-(void) setContinueVideoTapGestureClickedBlock:(ContinueVideoTapGestureClicked)block;

@end
