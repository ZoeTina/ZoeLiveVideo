//
//  PVAppStorePurchaseModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVAppStorePurchaseModel : NSObject
@property (nonatomic, copy) NSString *purchaseOrderId;//交易ID
@property (nonatomic, copy) NSString *orderTestStr;
@property (nonatomic, copy) NSString *code;
@end
