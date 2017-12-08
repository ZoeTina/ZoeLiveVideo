//
//  PVGiftGivingViewController.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVInteractiveZBViewController.h"
#import "PVInteractiveZBViewController.h"
#import "PVGiftsListModel.h"

@protocol LZSendGiftGivingDelegate <NSObject>

/** 代理 */
-(void)sendGiftButtonOnClick:(UIButton *)sender;

@end

/** 类型自定义 */
typedef void (^JumpReturnCallBlock) (void);

@interface PVGiftGivingViewController : UIViewController

/** 礼物模型 */
@property(nonatomic,strong) PVGiftsListModel *lzListModel;
///** 熊猫币余额 */
//@property(nonatomic,copy) NSString *balance;

@property(nonatomic,assign) CGFloat currentViewHeight;

- (id)initWithDictionary:(NSDictionary *)dictionary;
/** 获取账户余额-金币(动态) */
- (void)getBalance;
@property (nonatomic,copy) NSString *parentLiveId;

/** 设置代理 */
@property(nonatomic,assign)id<LZSendGiftGivingDelegate>delegate;

@property (nonatomic, copy) void (^giftClick)(NSInteger tag,NSInteger giftCount);
/** 声明一个ReturnValueBlock属性，这个Block是获取传值的界面传进来的 */
@property(nonatomic, copy) JumpReturnCallBlock jumpReturnCallBlock;

@end
