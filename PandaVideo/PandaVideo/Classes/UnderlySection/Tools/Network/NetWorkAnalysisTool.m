//
//  NetWorkAnalysisTool.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/9.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "NetWorkAnalysisTool.h"


@implementation NetWorkAnalysisTool

+ (NSString *)analysisNetworkDataWithDict:(NSDictionary *)dict url:(NSString *)url{
    
    
    
    if ([[dict pv_objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data = [dict pv_objectForKey:@"data"];
        if ([[data pv_objectForKey:@"code"] integerValue] == 703) {
            return [data pv_objectForKey:@"comment"];
        }
    }else {
        NSString *data = [dict pv_objectForKey:@"data"];
        if (data.length > 0) {
            return data;
        }
    }
    
    
    NSString *errorMsg = [dict pv_objectForKey:@"errorMsg"];
    if (errorMsg.length > 0) {
        return errorMsg;
    }
    return @"";
}

@end
