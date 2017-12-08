//
//  PVFamilyInviteModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/12.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVFamilyInviteModel : NSObject

@property (nonatomic, copy) NSString *familyId;
@property (nonatomic, copy) NSString *familyName;
@property (nonatomic, copy) NSString *inviteDate;
@property (nonatomic, copy) NSString *inviteUserName;
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *verifyMsg;

@end

@interface PVFamilyInviteListModel : NSObject
@property (nonatomic, copy) NSString *familyId;
@property (nonatomic, assign) BOOL joinFamily;
@property (nonatomic, strong) NSArray <PVFamilyInviteModel *> *inviteList;
@end
