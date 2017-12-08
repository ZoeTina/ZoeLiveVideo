//
//  PVMenuModel.m
//  PandaVideo
//
//  Created by cara on 17/9/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMenuModel.h"

@implementation PVMenuModel


-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"menuUrl"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            [self.menuUrls removeAllObjects];
            [self.menuUrls addObjectsFromArray:value];
        }else{
            [super setValue:value forKey:key];
        }
    }else{
        [super setValue:value forKey:key];
    }
}

-(NSMutableArray<NSString *> *)menuUrls{
    if (!_menuUrls) {
        _menuUrls = [NSMutableArray array];
    }
    return _menuUrls;
}

@end
