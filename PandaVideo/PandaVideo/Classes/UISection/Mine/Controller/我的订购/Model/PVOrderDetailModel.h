//
//  PVOrderDetailModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVOrderDetailModel : NSObject
@property (nonatomic, copy) NSString *productNmae; //产品名称
@property (nonatomic, copy) NSString *timeLimit;  //产品时效
@property (nonatomic, copy) NSString *endTime;    //产品失效时间
@property (nonatomic, copy) NSString *price;      //实际购买价格
@property (nonatomic, copy) NSString *orderNo;    //订单号
@property (nonatomic, copy) NSString *productId;  //产品ID
@property (nonatomic, copy) NSString *startTime;  //购买时间(也是产品的生效开始时间)
@property (nonatomic, copy) NSString *orderType; //产品购买方式
@property (nonatomic, copy) NSString *orderTime; //购买时间
@end

@interface PVOrderDetailListModel : NSObject
@property (nonatomic, strong) NSArray <PVOrderDetailModel *> *orderList;
@end
