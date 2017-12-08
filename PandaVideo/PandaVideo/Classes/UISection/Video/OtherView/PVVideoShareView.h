//
//  PVVideoShareView.h
//  VideoDemo
//
//  Created by cara on 17/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PVVideoShareViewCallBlock)(NSString* title);


@interface PVVideoShareView : UIView

-(void)setPVVideoShareViewCallBlock:(PVVideoShareViewCallBlock)block;


@end
