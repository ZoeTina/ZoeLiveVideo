//
//  PVFamilyInvoteModel.h
//  PandaVideo
//
//  Created by songxf on 2017/11/6.
//  Copyright © 2017年 cara. All rights reserved.
//  邀请列表

#import <Foundation/Foundation.h>

@class PVFamilyInvoteListModel;
@interface PVFamilyInvoteModel : NSObject

@property(nonatomic,copy)NSString *familyId;
@property(nonatomic,strong)NSArray<PVFamilyInvoteListModel *> *inviteList;
@property(nonatomic,assign)BOOL joinFamily;
@end


@interface PVFamilyInvoteListModel : NSObject
//家庭圈ID
@property(nonatomic,copy)NSString *familyId;
//家庭圈名称
@property(nonatomic,copy)NSString *familyName;
//邀请时间
@property(nonatomic,copy)NSString *inviteDate;
//邀请人用户名
@property(nonatomic,copy)NSString *inviteUserName;
//消息ID
@property(nonatomic,copy)NSString *msgId;
//邀请人手机号
@property(nonatomic,copy)NSString *phone;
//验证信息
@property(nonatomic,copy)NSString *verifyMsg;

@end


@interface PVFamilyBasicUIModel : NSObject

//背景色的色值
@property(nonatomic,copy)NSString *colorValue;
//家庭圈功能场景介绍图片 家庭圈底部的图
@property(nonatomic,copy)NSString *familyImage;
//主题URL 家庭圈顶部的图
@property(nonatomic,copy)NSString *theme;
@end
