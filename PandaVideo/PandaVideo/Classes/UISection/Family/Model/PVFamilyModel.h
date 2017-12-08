//
//  PVFamilyModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVFamilyModel : NSObject
+ (instancetype)shared;

@property (nonatomic, strong) NSMutableArray *familyArray;
@property (nonatomic, strong) NSMutableArray *familyregidterArray;

/**
 * 归档 将user对象保存到本地文件夹
 */
- (void)dump;

/**
 * 取档 从本地文件夹中获取user对象
 */
- (void)load;
@end
