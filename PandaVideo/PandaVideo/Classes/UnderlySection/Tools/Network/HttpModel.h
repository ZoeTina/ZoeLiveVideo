//
//  HttpModel.h
//  NetToolTest
//
//  Created by cara on 16/2/22.
//  Copyright © 2016年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpModel : NSObject

///请求中的参数设置
@property(nonatomic, strong) NSDictionary * getParams;

///发送请求的url
@property(nonatomic,copy) NSString * url;

///请求中的参数设置
@property(nonatomic, strong) NSDictionary * postParams;

@property(nonatomic, assign)BOOL isGet;

-(void)fillGetParameterWithUrl:(NSString *)url andParameter:(NSDictionary *)dic;

-(void)fillPostParameterWithUrl:(NSString *)url andParameter:(NSDictionary *)dic;
//
-(void)fillGetParameterWithNewUrl:(NSString *)url andParameter:(NSDictionary *)dic;
-(void)fillPostParameterWithNewUrl:(NSString *)url andParameter:(NSDictionary *)dic;
@end
