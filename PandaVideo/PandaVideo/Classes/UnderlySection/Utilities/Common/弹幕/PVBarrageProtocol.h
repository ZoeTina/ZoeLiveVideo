//
//  PVBarrageProtocol.h
//  PandaVideo
//
//  Created by Ensem on 2017/11/9.
//  Copyright © 2017年 cara. All rights reserved.
//

#ifndef PVBarrageProtocol_h
#define PVBarrageProtocol_h

#import <CoreGraphics/CoreGraphics.h>

@protocol PVBarrageItemProtocol <NSObject>

/** 速度 point per second */
@property (nonatomic, readwrite) CGFloat speed;

/** 当前路程，即弹幕跑了多长 */ 
@property (nonatomic, assign) CGFloat curDistance;

@end

#endif /* PVBarrageProtocol_h */
