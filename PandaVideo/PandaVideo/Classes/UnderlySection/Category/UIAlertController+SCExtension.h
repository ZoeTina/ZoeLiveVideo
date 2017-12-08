//
//  UIAlertController+SCExtension.h
//  SiChuanFocus
//
//  Created by cara on 17/7/5.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (SCExtension)


+(UIAlertController*)addAlertReminderText:(NSString*)reminderText message:(NSString*)message cancelTitle:(NSString*)cancelTitle  doTitle:(NSString*)doTitle  preferredStyle:(UIAlertControllerStyle)preferredStyle cancelBlock:(void (^)())cancelBlock doBlock:(void (^)())doBlock;

@end
