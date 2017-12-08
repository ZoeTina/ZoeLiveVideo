//
//  NSArray+SCExtension.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/28.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "NSArray+SCExtension.h"

@implementation NSArray (SCExtension)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

- (id)sc_safeObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}

- (void)sc_enumeratePairsUsingBlock:(void (^)(id obj1, NSUInteger idx1, id obj2, NSUInteger idx2, BOOL *stop))block {
    for (int i = 0; i < (int)self.count - 1; i++) {
        NSUInteger idx1 = i;
        NSUInteger idx2 = i + 1;
        id obj1 = self[idx1];
        id obj2 = self[idx2];
        BOOL stop = NO;
        
        block(obj1, idx1, obj2, idx2, &stop);
        
        if (stop) {
            break;
        }
    }
}


@end

@implementation NSDictionary (SCExtension)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}

@end
