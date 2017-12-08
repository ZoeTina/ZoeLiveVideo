//
//  PVConsumptionModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVConsumptionModel : NSObject
@property (nonatomic, copy) NSString *propName;
@property (nonatomic, copy) NSString *propId;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) NSInteger balance;
@property (nonatomic, copy) NSString *date;
@end

@interface PVConsumptionListModel : NSObject
@property (nonatomic, strong) NSArray <PVConsumptionModel *> *consumeList;
@end
