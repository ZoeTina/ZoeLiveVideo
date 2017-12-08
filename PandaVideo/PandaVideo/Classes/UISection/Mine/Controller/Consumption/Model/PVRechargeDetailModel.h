//
//  PVRechargeDetailModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVRechargeDetailModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *date;

@end

@interface PVRechargeDetailListModel : NSObject
@property (nonatomic, strong) NSArray <PVRechargeDetailModel *> *rechargeList;
@end
