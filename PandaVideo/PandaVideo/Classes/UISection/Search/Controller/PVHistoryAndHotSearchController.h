//
//  PVHistoryAndHotSearchController.h
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HistoryAndHotSearchControllerBlock)(NSString * keyString);


@interface PVHistoryAndHotSearchController : UIViewController


@property(nonatomic, strong)NSArray* historyDataSource;


-(void)setHistoryAndHotSearchControllerBlock:(HistoryAndHotSearchControllerBlock)block;

@end
