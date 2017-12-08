//
//  PVADsModel.h
//  PandaVideo
//
//  Created by songxf on 2017/10/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVADsModel : NSObject
//名字
@property(nonatomic,copy)NSString *imageName;
//图片地址
@property(nonatomic,copy)NSString *imageUrl;
//倒计时
@property(nonatomic,assign)NSInteger showTime;
//状态
@property(nonatomic,assign)NSInteger state;
//类型
@property(nonatomic,assign)NSInteger type;
//排序
@property(nonatomic,assign)NSInteger sort;
//跳转类型
@property(nonatomic,assign)NSInteger jumpType;
//跳转地址
@property(nonatomic,copy)NSString *jumpUrl;
@end
