//
//  PVSwitch.h
//  PandaVideo
//
//  Created by Ensem on 2017/11/9.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVSwitch : UIView

@property (nonatomic, strong) void (^changeStateBlock)(BOOL isOn);


@end
