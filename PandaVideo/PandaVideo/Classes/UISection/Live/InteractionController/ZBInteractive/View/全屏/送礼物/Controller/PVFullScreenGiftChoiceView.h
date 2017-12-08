//
//  PVFullScreenGiftChoiceView.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/8.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVGiftsListModel.h"
#import "PVPopoverView.h"
@class PVGiftsListModel,PVGiftList;
//typedef void(^JumpCallBackBlcok) (NSInteger idx);//1:跳转充值，2:跳转登录
@interface PVFullScreenGiftChoiceView : UIView

@property(nonatomic, strong) PVGiftsListModel *listModel;

///** 熊猫币余额 */
//@property(nonatomic,copy) NSString *balance;

@property (nonatomic, copy) void (^fullGiftClick)(NSInteger tag);


@property(nonatomic,strong) PVPopoverView *popoverView;
@property (nonatomic, copy) NSString    *liveId;
//充值
@property(nonatomic,copy)void(^rechargeBlock)(void);


//赠送 isHaveMoney 是否有足够多的钱
@property(nonatomic,copy)void(^zengsongBlock)(NSInteger reuse,BOOL isHaveMoney);
//
//@property (nonatomic,copy) JumpCallBackBlcok jumpCallBackBlcok;//2

- (void) requestPresentGift:(NSInteger) idx;

/** 获取账户余额-金币(动态) */
- (void)getBalance;

@end

