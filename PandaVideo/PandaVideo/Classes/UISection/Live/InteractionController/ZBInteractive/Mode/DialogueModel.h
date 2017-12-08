//
//  Dialogue.h
//  SEZB
//
//  Created by 寕小陌 on 2017/1/20.
//  Copyright © 2017年 寜小陌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DialogueModel : NSObject

@property (copy, nonatomic) NSString                        *userid;
@property (copy, nonatomic) NSString                        *username;
@property (copy, nonatomic) NSString                        *userrole;

@property (copy, nonatomic) NSString                        *fromuserid;
@property (copy, nonatomic) NSString                        *fromusername;
@property (copy, nonatomic) NSString                        *fromuserrole;

@property (copy, nonatomic) NSString                        *touserid;
@property (copy, nonatomic) NSString                        *tousername;

@property (copy, nonatomic) NSString                        *msg;
@property (copy, nonatomic) NSString                        *time;

@property (assign, nonatomic) CGSize                        msgSize;
@property (assign, nonatomic) CGSize                        userNameSize;

@end
