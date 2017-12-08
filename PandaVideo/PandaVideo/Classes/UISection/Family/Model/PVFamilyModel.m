//
//  PVFamilyModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyModel.h"
#import "HKLocalCacheTool.h"

static PVFamilyModel *familyModel = nil;

@implementation PVFamilyModel
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        familyModel = [[PVFamilyModel alloc] init];
    });
    return familyModel;
}

/**
 * 归档 将user对象保存到本地文件夹
 */
- (void)dump {
    NSString *familyDataPath = [HKLocalCacheTool userDataDirectoryWithFileName:@"family"];
    [HKLocalCacheTool createUserLocalDirectory:familyDataPath];
    NSString *userDataFile = [familyDataPath stringByAppendingPathComponent:@"familyInfo.dat"];
    
    BOOL b = [NSKeyedArchiver archiveRootObject:[PVFamilyModel shared] toFile:userDataFile];
    
    if (b) {
        SCLog(@"PVUserModel dump 成功");
    } else {
        SCLog(@"PVUserModel dump 失败");
    }
}

/**
 * 取档 从本地文件夹中获取user对象
 */
- (void)load {
    NSString *userDataPath = [HKLocalCacheTool userDataDirectoryWithFileName:@"family"];
    NSString *filePath = [userDataPath stringByAppendingPathComponent:@"familyInfo.dat"];
    PVFamilyModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (user) {
//        SCLog(@"HKSettingsModel load 成功");
//        SCLog(@"userID:%@", [PVUserModel shared].userId);
    } else {
        SCLog(@"HKSettingsModel load 失败");
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [PVFamilyModel shared].familyregidterArray = [aDecoder decodeObjectForKey:@"familyregidterArray"];
        [PVFamilyModel shared].familyArray = [aDecoder decodeObjectForKey:@"familyArray"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[PVFamilyModel shared].familyregidterArray forKey:@"familyregidterArray"];
    [aCoder encodeObject:[PVFamilyModel shared].familyArray forKey:@"familyArray"];
    
}

- (NSMutableArray *)familyregidterArray {
    if (!_familyregidterArray) {
        _familyregidterArray = [[NSMutableArray alloc] init];
    }
    return _familyregidterArray;
        
}

- (NSMutableArray *)familyArray {
    if (!_familyArray) {
        _familyArray = [[NSMutableArray alloc] init];
    }
    return _familyArray;
}
@end
