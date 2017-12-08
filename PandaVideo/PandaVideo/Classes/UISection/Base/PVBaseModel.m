//
//  PVBaseModel.m
//  SiChuanFocus
//
//  Created by cara on 17/6/29.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "PVBaseModel.h"

@implementation PVBaseModel


-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([value isKindOfClass:[NSNumber class]]) {
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    }else if ([value isKindOfClass:[NSNull class]]){
        [self setValue:[NSString stringWithFormat:@"%@",@""] forKey:key];
    }else if ([value isKindOfClass:[NSString class]] && !value){
        [self setValue:[NSString stringWithFormat:@"%@",@""] forKey:key];
    }else{
        [super setValue:value forKey:key];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //NSLog(@"还没有定义%@",key);
}



@end
