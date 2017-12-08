//
//  PVTopicModel.h
//  PandaVideo
//
//  Created by cara on 2017/10/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

@interface PVTopicModel : PVBaseModel

@property(nonatomic, copy)NSString*  topicCode;
@property(nonatomic, copy)NSString*  topicColumnName;
@property(nonatomic, copy)NSString*  topicColumnUrl;
@property(nonatomic, copy)NSString*  kId;
@property(nonatomic, copy)NSString*  sort;

@end
