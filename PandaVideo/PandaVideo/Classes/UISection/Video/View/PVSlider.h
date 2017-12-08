//
//  PVSlider.h
//  VideoDemo
//
//  Created by cara on 17/8/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVSlider : UIControl

@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) CGFloat middleValue;
@property (nonatomic, strong) UIColor* thumbTintColor;
@property (nonatomic, strong) UIColor* minimumTrackTintColor;
@property (nonatomic, strong) UIColor* middleTrackTintColor;
@property (nonatomic, strong) UIColor* maximumTrackTintColor;
@property (nonatomic, readonly)UIImage* thumbImage;
@property (nonatomic, strong) UIImage* minimumTrackImage;
@property (nonatomic, strong) UIImage* middleTrackImage;
@property (nonatomic, strong) UIImage* maximumTrackImage;

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;

@end
