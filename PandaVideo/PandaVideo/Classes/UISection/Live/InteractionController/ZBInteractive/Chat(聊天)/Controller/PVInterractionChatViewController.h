//
//  PVInterractionChatViewController.h
//  PandaVideo
//
//  Created by 寕小陌 on 2017/8/15.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVInterractionChatViewController : UITableViewController

//点赞个数
@property(nonatomic,copy)void(^dianzanBlock)(NSInteger total);

//在线个数
@property(nonatomic,copy)void(^zaiXianRenshuBlock)(NSInteger total);

-(id) initDictionary:(NSDictionary *)dictionary;

/** 移除定时器 */
- (void)removeTimer;
@end
