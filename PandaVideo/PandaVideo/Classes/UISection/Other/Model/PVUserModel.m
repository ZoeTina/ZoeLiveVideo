//
//  PVUserModel.m
//  PandaVideo
//
//  Created by xiangjf on 2017/9/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUserModel.h"
#import "HKLocalCacheTool.h"

static NSString *avatar = @"avatar";
static NSString *nickName = @"nickName";
static NSString *token = @"token";
static NSString *userId = @"userId";
static NSString *sex = @"sex";
static NSString *userType = @"userType";
static NSString *phoneNumber = @"phoneNumber";
static NSString *openList = @"openList";
static NSString *isLogin = @"isLogin";
static NSString *userAvatar = @"userAvatar";
static NSString *avatarUrl = @"avatarUrl";
static NSString *baseInfo = @"baseInfo";
static NSString *orderInfo = @"orderInfo";
static NSString *pandaAccount = @"pandaAccount";
static NSString *birthday = @"birthday";
static NSString *balance = @"balance";
static NSString *activeTime = @"activeTime";
static NSString *authorizationCode = @"authorizationCode";
static NSString *duration = @"duration";
static NSString *orderId = @"orderId";
static NSString *orderName = @"orderName";
static NSString *orderNumber = @"orderNumber";
static NSString *payType = @"payType";
static NSString *price = @"price";
static NSString *expireTime = @"expireTime";


@implementation PVPandaAccountModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.balance = [aDecoder decodeIntegerForKey:balance];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.balance forKey:balance];
}
@end

@implementation PVOrderInfoModel
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.activeTime = [aDecoder decodeObjectForKey:activeTime];
        self.expireTime = [aDecoder decodeObjectForKey:expireTime];
        self.duration = [aDecoder decodeObjectForKey:duration];
        self.orderId = [aDecoder decodeObjectForKey:orderId];
        self.orderName = [aDecoder decodeObjectForKey:orderName];
        self.orderNumber = [aDecoder decodeObjectForKey:orderNumber];
        self.payType = [aDecoder decodeObjectForKey:payType];
        self.price = [aDecoder decodeObjectForKey:price];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.activeTime forKey:activeTime];
    [aCoder encodeObject:self.expireTime forKey:expireTime];
    [aCoder encodeObject:self.duration forKey:duration];
    [aCoder encodeObject:self.orderId forKey:orderId];
    [aCoder encodeObject:self.orderName forKey:orderName];
    [aCoder encodeObject:self.orderNumber forKey:orderNumber];
    [aCoder encodeObject:self.payType forKey:payType];
    [aCoder encodeObject:self.price forKey:price];
}
@end


@implementation PVUserbaseInfo

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.avatar = [aDecoder decodeObjectForKey:avatar];
        self.birthday = [aDecoder decodeObjectForKey:birthday];
        self.nickName = [aDecoder decodeObjectForKey:nickName];
        self.phoneNumber = [aDecoder decodeObjectForKey:phoneNumber];
        self.sex = [aDecoder decodeIntegerForKey:sex];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.avatar forKey:avatar];
    [aCoder encodeObject:self.birthday forKey:birthday];
    [aCoder encodeObject:self.nickName forKey:nickName];
    [aCoder encodeObject:self.phoneNumber forKey:phoneNumber];
    [aCoder encodeInteger:self.sex forKey:sex];
}

@end


@implementation PVUserModel



static PVUserModel *userModel = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[PVUserModel alloc] init];
    });
    return userModel;
}

- (BOOL)isLogin{
    if (self.userId.length > 0 && self.token.length > 0) {
        return YES;
    }
    return NO;
}
/**
 * 归档 将user对象保存到本地文件夹
 */
- (void)dump {
    NSString *userDataPath = [HKLocalCacheTool userDataDirectoryWithFileName:@"users"];
    [HKLocalCacheTool createUserLocalDirectory:userDataPath];
    NSString *userDataFile = [userDataPath stringByAppendingPathComponent:@"userInfo.dat"];
    
    BOOL b = [NSKeyedArchiver archiveRootObject:[PVUserModel shared] toFile:userDataFile];
    
    if (b) {
        SCLog(@"PVUserModel dump 成功");
    } else {
        SCLog(@"PVUserModel dump 失败");
    }
}

/**
 * 取档 从本地文件夹中获取user对象
 */
- (PVUserModel *)load {
    NSString *userDataPath = [HKLocalCacheTool userDataDirectoryWithFileName:@"users"];
    NSString *filePath = [userDataPath stringByAppendingPathComponent:@"userInfo.dat"];
    PVUserModel *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    if (user) {
        SCLog(@"HKSettingsModel load 成功");
        SCLog(@"userID:%@", [PVUserModel shared].userId);
    } else {
        SCLog(@"HKSettingsModel load 失败");
    }
    return user;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [PVUserModel shared].baseInfo = [aDecoder decodeObjectForKey:baseInfo];
        [PVUserModel shared].orderInfo = [aDecoder decodeObjectForKey:orderInfo];
        [PVUserModel shared].token = [aDecoder decodeObjectForKey:token];
        [PVUserModel shared].userId = [aDecoder decodeObjectForKey:userId];
        [PVUserModel shared].authorizationCode = [aDecoder decodeObjectForKey:authorizationCode];
        [PVUserModel shared].isLogin = [[aDecoder decodeObjectForKey:isLogin] boolValue];
        [PVUserModel shared].pandaAccount = [aDecoder decodeObjectForKey:pandaAccount];
        [PVUserModel shared].orderInfo = [aDecoder decodeObjectForKey:orderInfo];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[PVUserModel shared].authorizationCode forKey:authorizationCode];
    [aCoder encodeObject:[PVUserModel shared].baseInfo forKey:baseInfo];
    [aCoder encodeObject:[PVUserModel shared].orderInfo forKey:orderInfo];
//    [aCoder encodeObject:@"token" forKey:token];
//    [aCoder encodeObject:@"61" forKey:userId];
    [aCoder encodeObject:[PVUserModel shared].token forKey:token];
    [aCoder encodeObject:[PVUserModel shared].userId forKey:userId];
    [aCoder encodeObject:[PVUserModel shared].pandaAccount forKey:pandaAccount];
    [aCoder encodeObject:[NSNumber numberWithBool:[PVUserModel shared].isLogin] forKey:isLogin];
}

/**
 * 清空数据
 */
- (void)logout {
    [PVUserModel shared].userId = @"";
    [PVUserModel shared].token = @"";
    [PVUserModel shared].baseInfo = nil;
    [PVUserModel shared].pandaAccount = nil;
    [PVUserModel shared].orderInfo = nil;
    [PVUserModel shared].isLogin = NO;
}


- (NSString *)description {
    return [self yy_modelDescription];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderInfo" : [PVOrderInfoModel class]};
}
@end
