//
//  PVPresentModel.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPresentModel.h"

/** 显示送礼物的动画  Model */

@implementation PVPresentModel

+ (instancetype)modelWithSender:(NSString *)sender
                         giftId:(NSInteger )giftId
                       giftName:(NSString *)giftName
                           icon:(NSString *)icon
                  giftImageName:(NSString *)giftImageName
{
    PVPresentModel *model   = [[PVPresentModel alloc] init];
    model.sender            = sender;
    model.giftId            = giftId;
    model.giftName          = giftName;
    model.icon              = icon;
    model.giftImageName     = giftImageName;
    return model;
}

@end
