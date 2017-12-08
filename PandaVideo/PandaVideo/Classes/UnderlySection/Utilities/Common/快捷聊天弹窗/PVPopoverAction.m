//
//  PVPopoverAction.m
//  PandaVideo
//
//  Created by Ensem on 2017/11/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPopoverAction.h"

@interface PVPopoverAction ()

@property (nonatomic, strong, readwrite) UIImage *image; ///< 图标
@property (nonatomic, copy, readwrite) NSString *title; ///< 标题
@property (nonatomic, copy, readwrite) void(^handler)(PVPopoverAction *action); ///< 选择回调

@end

@implementation PVPopoverAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(PVPopoverAction *action))handler {
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(PVPopoverAction *action))handler {
    PVPopoverAction *popoverAction = [[self alloc] init];
    popoverAction.image = image;
    popoverAction.title = title ? : @"";
    popoverAction.handler = handler ? : NULL;
    return popoverAction;
}

@end
