//
//  PVPackageListModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVPackageModel;
@interface PVPackageListModel : NSObject
@property (nonatomic, strong) NSArray <PVPackageModel *> *packageList;
@end

@interface PVPackageModel : NSObject
@property (nonatomic, assign) NSInteger exchangePrice;
@property (nonatomic, assign) NSInteger iosPackageId;
@property (nonatomic, assign) NSInteger isDiscountTag;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger packageId;
@property (nonatomic, assign) NSInteger price;
@end
