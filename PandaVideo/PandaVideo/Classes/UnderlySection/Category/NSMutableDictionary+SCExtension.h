//
//  NSMutableDictionary+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/9/8.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SCExtension)

/**
 * 加密Token拼接参数
 */
- (NSMutableDictionary *)sc_requestParamsAddTokenWithImageArray:(NSArray *)imageArray;

@end
