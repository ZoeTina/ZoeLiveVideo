//
//  PVUniversalJump.h
//  PandaVideo
//
//  Created by cara on 17/9/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVChoiceSecondColumnModel.h"

@class PVJumpModel;

@interface PVUniversalJump : NSObject

-(instancetype)initPVUniversalJumpWithPVJumpModel:(PVJumpModel*)jumpModel;

///给外界调用进行跳转
-(void)jumpVniversalJumpVC;

@end

///跳转需要的参数
@interface PVJumpModel : NSObject

///跳转类型
@property(nonatomic, copy)NSString* jumpID;
///跳转页面需要的id
@property(nonatomic, copy)NSString* jumpVCID;
///跳转标题
@property(nonatomic, copy)NSString* jumpTitle;
///跳转链接
@property(nonatomic, copy)NSString* jumpUrl;
///跳转是单集还是多集
@property(nonatomic, copy)NSString* jumpNumberType;
///控制器
@property(nonatomic, strong)UIViewController* jumpVC;
///二级栏目默认数据
@property(nonatomic, strong)PVChoiceSecondColumnModel* secondColumnModel;

@end
