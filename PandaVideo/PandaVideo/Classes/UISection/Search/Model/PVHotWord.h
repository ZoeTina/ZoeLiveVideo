//
//  PVHotWord.h
//  PandaVideo
//
//  Created by cara on 2017/11/10.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

/*
 hotword = 花千骨;
 tag = 热门古装;
 */

@interface PVHotWord : PVBaseModel

@property(nonatomic, copy)NSString* hotword;
@property(nonatomic, copy)NSString* tag;

@end
