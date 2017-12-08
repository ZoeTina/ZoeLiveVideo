//
//  AppDelegate+AddressBook.h
//  PandaVideo
//
//  Created by Ensem on 2017/10/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "AppDelegate.h"
#import "PVTongxunluModel.h"

@interface AppDelegate (AddressBook)

/** 获取手机通讯录 */
- (void)requestAuthorizationForAddressBook;

@end
