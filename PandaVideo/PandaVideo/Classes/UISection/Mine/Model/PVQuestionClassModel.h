//
//  PVQuestionClassModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVQuestionListModel;
@class PVQuestionModel;

@interface PVQuestionClassModel : NSObject
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray <PVQuestionListModel *> *classList;
@end

@interface PVQuestionListModel : NSObject
@property (nonatomic, copy) NSString *questionJsonUrl;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, strong) NSArray <PVQuestionModel *>*questionList;
@end

@interface PVQuestionModel : NSObject
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *question;
@property (nonatomic, assign) BOOL isOpen;
@end
