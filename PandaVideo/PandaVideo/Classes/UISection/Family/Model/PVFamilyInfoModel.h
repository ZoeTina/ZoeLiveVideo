//
//  PVFamilyInfoModel.h
//  PandaVideo
//
//  Created by songxf on 2017/11/7.
//  Copyright © 2017年 cara. All rights reserved.
//  家庭圈详情列表

#import <Foundation/Foundation.h>

@class PVFamilyInfoListModel;
@interface PVFamilyInfoModel : NSObject

//家庭圈成员列表
@property(nonatomic,strong)NSArray<PVFamilyInfoListModel *> *familyMemberList;
//家庭圈名称
@property(nonatomic,copy)NSString *familyName;
//我的家庭昵称
@property(nonatomic,copy)NSString *myNickName;
@end

@interface PVFamilyInfoListModel : NSObject

//个人头像
@property(nonatomic,strong)NSString *avatar;
//是否在TV端注册
@property(nonatomic,assign)BOOL isBindTV;
//昵称
@property(nonatomic,strong)NSString *nickName;
//手机号
@property(nonatomic,strong)NSString *phone;
//
@property(nonatomic,assign)NSInteger sort;

@end
