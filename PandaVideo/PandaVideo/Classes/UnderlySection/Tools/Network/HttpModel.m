//
//  HttpModel.m
//  NetToolTest
//
//  Created by cara on 16/2/22.
//  Copyright © 2016年 cara. All rights reserved.
//

#import "HttpModel.h"
#import "UrlConfig.h"

@implementation HttpModel

-(void)setUrl:(NSString *)url{

    _url = [NSString stringWithFormat:@"%@%@",BaseUrl,url];
}

-(void)fillGetParameterWithUrl:(NSString *)url andParameter:(NSDictionary *)dic{

    NSString *param = [self parameters_Url:dic];
    _url = [NSString stringWithFormat:@"%@%@%@version=%@",BaseUrl,url,param,@"1"];
}

//参数转换
-(NSString*)parameters_Url:(NSDictionary*)data{
    NSArray* keys = [data allKeys];
    NSString* parameters_Url = @"";
    for (int i=0; i<data.count; i++) {
        NSString* data_key = keys[i];
        NSString* data_value = [data objectForKey:data_key];
        NSString* parameter = [NSString stringWithFormat:@"%@=%@&",data_key,data_value];
        parameters_Url = [parameters_Url stringByAppendingString:parameter];
    }
    parameters_Url = [NSString stringWithFormat:@"?%@",parameters_Url];
    return parameters_Url;
}

@end
