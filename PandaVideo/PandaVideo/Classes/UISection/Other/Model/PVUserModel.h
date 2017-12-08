//
//  PVUserModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/9/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVPandaAccountModel : NSObject
@property (nonatomic, assign) NSInteger balance;//余额
@end

@interface PVOrderInfoModel : NSObject
@property (nonatomic, copy) NSString *orderId; //    产品包ID
@property (nonatomic, copy) NSString *orderName; //产品包名
@property (nonatomic, copy) NSString *orderNumber; //订单号
@property (nonatomic, copy) NSString *payType; // 支付方式
@property (nonatomic, copy) NSString *practicePrice; //购买价格
@property (nonatomic, copy) NSString *price; //价格
@property (nonatomic, copy) NSString *duration; //购买时长
@property (nonatomic, copy) NSString *activeTime; //开始时间
@property (nonatomic, copy) NSString *expireTime; //到期时间

@end


@interface PVUserbaseInfo : NSObject
@property (nonatomic, copy) NSString *avatar;  // 会员头像
@property (nonatomic, copy) NSString *birthday; //生日
@property (nonatomic, copy) NSString *nickName; //昵称
@property (nonatomic, copy) NSString *phoneNumber; //已绑定手机号
@property (nonatomic, assign) NSInteger sex; //性别
@end

@interface PVUserModel : NSObject


@property (nonatomic, strong) PVUserbaseInfo *baseInfo;
@property (nonatomic, strong) NSArray <PVOrderInfoModel *> *orderInfo; //订购信息
@property (nonatomic, strong) PVPandaAccountModel *pandaAccount; //熊猫钱包
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *authorizationCode;//视频鉴权code
@property (nonatomic, copy) NSString *familyId;//家庭圈Id
//是否已绑定手机号（先判断是否绑定，如果已绑定 返回登录信息，未绑定 返回false，并跳转至绑定页）
@property (nonatomic, copy) NSString *isBindAccount;
//新加的参数
@property (nonatomic, assign) BOOL isLogin; //是否登录

+ (instancetype)shared;

/**
 * 归档 将user对象保存到本地文件夹
 */
- (void)dump;

/**
 * 取档 从本地文件夹中获取user对象
 */
- (PVUserModel *)load;

/**
 * 清空数据
 */
- (void)logout;
@end
