//
//  NSArray+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/28.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SCExtension)

- (id)sc_safeObjectAtIndex:(NSUInteger)index;
- (void)sc_enumeratePairsUsingBlock:(void (^)(id obj1, NSUInteger idx1, id obj2, NSUInteger idx2, BOOL * stop))block;
@end

@interface NSDictionary (SCExtension)

@end
