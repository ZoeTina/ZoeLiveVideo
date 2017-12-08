//
//  UIAlertController+SCExtension.m
//  SiChuanFocus
//
//  Created by cara on 17/7/5.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "UIAlertController+SCExtension.h"

@implementation UIAlertController (SCExtension)

+(UIAlertController*)addAlertReminderText:(NSString*)reminderText message:(NSString*)message cancelTitle:(NSString*)cancelTitle  doTitle:(NSString*)doTitle  preferredStyle:(UIAlertControllerStyle)preferredStyle cancelBlock:(void (^)())cancelBlock doBlock:(void (^)())doBlock {
    
    UIAlertController *alerController = [UIAlertController  alertControllerWithTitle:reminderText message:message preferredStyle:preferredStyle];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelBlock];
    UIAlertAction *modifyAction = [UIAlertAction actionWithTitle:doTitle style:UIAlertActionStyleDestructive handler:doBlock];
    [alerController addAction:cancelAction];
    [alerController addAction:modifyAction];
    
    return alerController;
}



@end
