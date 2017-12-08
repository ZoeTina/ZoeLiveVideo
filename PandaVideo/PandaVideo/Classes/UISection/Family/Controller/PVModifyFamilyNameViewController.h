//
//  PVModifyFamilyNameViewController.h
//  PandaVideo
//
//  Created by songxf on 2017/11/8.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"

typedef enum : NSUInteger {
    FamilyModifyTypeNickName,       // 我的昵称
    FamilyModifyTypeFamilyName      // 群名字
} FamilyModifyType;

//这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^ChangeTextBlock) (NSString *text);

@interface PVModifyFamilyNameViewController : SCBaseViewController

@property(nonatomic,assign)FamilyModifyType modifyType;
@property (nonatomic, copy) NSString *tabBarTitle;
@property (nonatomic, copy) NSString *nickname;

//定义一个block
@property (nonatomic, copy) ChangeTextBlock block;
@end
