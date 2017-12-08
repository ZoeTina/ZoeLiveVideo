//
//  PVOrderCenterModel.h
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PrivilegeModel;
@class OrderInfoModel;
@class OrderInfoModel;

@interface PVOrderCenterModel : NSObject

@property (nonatomic, strong) NSArray <PrivilegeModel *> *privilegeList;
@property (nonatomic, strong) NSArray <OrderInfoModel *> *orderInfo;
@property (nonatomic, copy) NSString *orderName;
@property (nonatomic, copy) NSString *agreementUrl;
@end


//优惠信息
@interface PrivilegeModel : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;

@end

//产品信息
@interface OrderInfoModel : NSObject

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, copy) NSString *timeLimit;

@end

@interface PVOrderCenterListModel : NSObject

@property (nonatomic, strong) NSArray <PVOrderCenterModel *> *orderList;


@end
