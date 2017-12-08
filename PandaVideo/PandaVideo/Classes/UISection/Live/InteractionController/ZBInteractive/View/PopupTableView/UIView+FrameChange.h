//
//  UIView+FrameChange.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameChange)

@property (assign, nonatomic) CGFloat    top;
@property (assign, nonatomic) CGFloat    bottom;
@property (assign, nonatomic) CGFloat    left;
@property (assign, nonatomic) CGFloat    right;

@property (assign, nonatomic) CGPoint    offset;
@property (assign, nonatomic) CGPoint    position;

@property (assign, nonatomic) CGFloat    x;
@property (assign, nonatomic) CGFloat    y;
@property (assign, nonatomic) CGFloat    w;
@property (assign, nonatomic) CGFloat    h;

@property (assign, nonatomic) CGFloat    width;
@property (assign, nonatomic) CGFloat    height;
@property (assign, nonatomic) CGSize    size;

@property (assign, nonatomic) CGFloat    centerX;
@property (assign, nonatomic) CGFloat    centerY;
@property (assign, nonatomic) CGPoint    origin;
@property (readonly, nonatomic) CGPoint    boundsCenter;
@property (nonatomic, assign, readonly) CGFloat bottomFromSuperView;

@end
