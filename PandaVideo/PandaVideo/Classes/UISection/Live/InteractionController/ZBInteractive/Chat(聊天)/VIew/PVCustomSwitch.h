//
//  PVCustomSwitch.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PVCustomSwitchDelegate <NSObject>

- (void)customSwitchOn;

- (void)customSwitchOff;

@end

@interface PVCustomSwitch : UIView

@property (nonatomic,weak)id<PVCustomSwitchDelegate>delegate;

@property(nonatomic,getter=isOn) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated; // does not send action

@end
