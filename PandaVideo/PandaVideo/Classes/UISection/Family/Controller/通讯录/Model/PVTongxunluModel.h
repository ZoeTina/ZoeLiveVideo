//
//  PVTongxunluModel.h
//  PandaVideo
//
//  Created by Ensem on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVTongxunluModel : NSObject


@property (strong, nonatomic) NSString     *name;
@property (strong, nonatomic) NSString     *phone;
@property (nonatomic, assign) NSInteger     state;
@property (assign, nonatomic) NSInteger     index;

+ (NSMutableArray *)getModelData;

@end
