//
//  PVVideoAuthentication.h
//  PandaVideo
//
//  Created by cara on 17/9/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PVVideoAuthenticationCallBlock)(NSInteger type, BOOL isStop);
typedef void(^PVVideoIsCrossCallBlock)(void);

@class PVProductModel,PVProductTypeModel;

@interface PVVideoAuthentication : NSObject

//0.是否已经打开定位, 1.是否在四川省内, 2.是否为数据流量， 3:鉴权通过,4:是数据流量,弹对话框, 5:没网, 6:没有产品资格,7关闭网络提醒
@property(nonatomic, assign)NSInteger authenticationType;
//1=省内；2=全国；
@property(nonatomic, copy)NSString* videoDistrict;
///鉴权产品模型
@property(nonatomic, strong)PVProductModel* productModel;

-(instancetype)initVideoPVProductModel:(PVProductModel*)productModel;

-(void)playVideoAuthentication;

-(void)setPVVideoAuthenticationCallBlock:(PVVideoAuthenticationCallBlock)callBlock;
-(void)setPVVideoIsCrossCallBlock:(PVVideoIsCrossCallBlock)callBlock;

///判断定位功能是否可用
-(BOOL)judgeLoactionJurisdiction;

@end

//产品包
@interface PVProductModel : NSObject

///付费类型
@property(nonatomic, assign)NSInteger payType;
///是否位省内播放还是省外可以播
@property(nonatomic, assign)NSInteger provincePlayType;
///1:免费包;   2:基础包;    3:尊享包.
@property(nonatomic, copy)NSString* code;

@end


