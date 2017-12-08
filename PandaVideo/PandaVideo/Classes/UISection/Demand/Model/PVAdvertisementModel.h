//
//  PVAdvertisementModel.h
//  PandaVideo
//
//  Created by cara on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

@interface PVAdvertisementModel : PVBaseModel

@property(nonatomic, copy)NSString* imgUrl;
@property(nonatomic, copy)NSString* name;
@property(nonatomic, copy)NSString* kId;
@property(nonatomic, copy)NSString* type;
@property(nonatomic, copy)NSString* jumpUrl;

@end
