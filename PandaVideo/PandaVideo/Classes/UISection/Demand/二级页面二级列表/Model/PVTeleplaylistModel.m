//
//  PVTeleplaylistModel.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTeleplaylistModel.h"

@implementation PVTeleplaylistModel

    
@end


@implementation PVSecondColumnVideoList

//-(void)setValue:(id)value forKey:(NSString *)key{
//    if ([key isEqualToString:@"info"]){
//        PVSecondColumnInfo *info = [[PVSecondColumnInfo alloc]  init];
//        [info setValuesForKeysWithDictionary:value];
//        self.info = info;
//    }
//}

@end

@implementation PVSecondColumnInfo

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.tid = value;
    }else{
        [super setValue:value forKey:key];
    }
}

@end

@implementation PVSecondColumnExpand

@end

@implementation PVChoiceSecondColumnModels

@end
