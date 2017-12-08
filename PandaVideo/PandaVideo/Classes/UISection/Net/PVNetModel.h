//
//  PVNetModel.h
//  PandaVideo
//
//  Created by cara on 17/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVNetModel : NSObject

///是get还是post
@property(nonatomic, assign)BOOL isGetOrPost;
///请求链接
@property(nonatomic, copy)NSString* url;
///post请求参数
@property(nonatomic, strong)NSMutableDictionary* param;
//post请求body体
@property (nonatomic, copy) NSString *postData;
///请求结果参数
@property(nonatomic, assign)NSInteger requestType;

-(instancetype)initIsGetOrPost:(BOOL)isGet  Url:(NSString*)url  param:(NSDictionary*)param;

@end
