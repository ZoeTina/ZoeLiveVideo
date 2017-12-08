//
//  PVMineConfigModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/16.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMineConfigModel.h"
#import "HKLocalCacheTool.h"

@implementation PVMineConfigModel

static NSString *isFirstLogin = @"isFirstLogin";
static NSString *netPlayTips = @"netPlayTips";
static NSString *netUploadingTips = @"netUploadingTips";
static NSString *netCacheTips = @"netCacheTips";
static NSString *postTips = @"postTips";


static PVMineConfigModel *mineConfigModel = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mineConfigModel = [[PVMineConfigModel alloc] init];
    });
    return mineConfigModel;
}

- (void)dump {
    NSString *userDataPath = [HKLocalCacheTool userDataDirectoryWithFileName:@"MineConfig"];
    [HKLocalCacheTool createUserLocalDirectory:userDataPath];
    NSString *userDataFile = [userDataPath stringByAppendingPathComponent:@"MineConfig.dat"];
    
    BOOL b = [NSKeyedArchiver archiveRootObject:[PVMineConfigModel shared] toFile:userDataFile];
    
    if (b) {
        SCLog(@"PVUserModel dump 成功");
    } else {
        SCLog(@"PVUserModel dump 失败");
    }
}

- (void)load {
    NSString *userDataPath = [HKLocalCacheTool userDataDirectoryWithFileName:@"MineConfig"];
    NSString *filePath = [userDataPath stringByAppendingPathComponent:@"MineConfig.dat"];
    PVMineConfigModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (user) {
        SCLog(@"HKSettingsModel load 成功");
    } else {
        SCLog(@"HKSettingsModel load 失败");
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [PVMineConfigModel shared].netPlayTips = [[aDecoder decodeObjectForKey:netPlayTips] boolValue];
        [PVMineConfigModel shared].netCacheTips = [[aDecoder decodeObjectForKey:netCacheTips] boolValue];
        [PVMineConfigModel shared].netUploadingTips = [[aDecoder decodeObjectForKey:netUploadingTips] boolValue];
        [PVMineConfigModel shared].postTips = [[aDecoder decodeObjectForKey:postTips] boolValue];
        [PVMineConfigModel shared].isFirstLogin = [[aDecoder decodeObjectForKey:isFirstLogin] boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
//    [aCoder encodeObject:[PVMineConfigModel shared].netPlayTips forKey:netPlayTips];
    [aCoder encodeObject:[NSNumber numberWithBool:[PVMineConfigModel shared].netPlayTips] forKey:netPlayTips];
    
    [aCoder encodeObject:[NSNumber numberWithBool:[PVMineConfigModel shared].netUploadingTips] forKey:netUploadingTips];
    [aCoder encodeObject:[NSNumber numberWithBool:[PVMineConfigModel shared].postTips] forKey:postTips];
    [aCoder encodeObject:[NSNumber numberWithBool:[PVMineConfigModel shared].isFirstLogin] forKey:isFirstLogin];
}
@end
