//
//  PVNetModel.m
//  PandaVideo
//
//  Created by cara on 17/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVNetModel.h"

@implementation PVNetModel


-(instancetype)initIsGetOrPost:(BOOL)isGet  Url:(NSString*)url  param:(NSDictionary*)param{
    
    self = [super init];
    
    if (self) {
        self.isGetOrPost = isGet;
        self.url = url;
        self.param = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    return self;
}
-(NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
    }
    return _param;
}
/*
 NSURL * URL = [NSURL URLWithString:url];
 NSURLRequest * request = [NSURLRequest requestWithURL:URL];
 NSURLSession * session = [NSURLSession sharedSession];
 NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
 NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
 NSString * str2 = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
 str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
 str2 = [str2 stringByReplacingOccurrencesOfString:@"\r" withString:@""];
 
 NSLog(@"str2 = %@",str2);
 
 
 }];
 [dataTask resume];
 */
@end
