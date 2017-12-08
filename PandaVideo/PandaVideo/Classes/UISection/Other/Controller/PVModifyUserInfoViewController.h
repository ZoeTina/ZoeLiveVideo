//
//  PVModifyUserInfoViewController.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/30.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCBaseViewController.h"

//这里要定义一个block的别名(申明) 类型 ----> void (^) (NSString *text)
typedef void(^ChangeTextBlock) (NSString *text);

@interface PVModifyUserInfoViewController : SCBaseViewController

@property (nonatomic, copy) NSString *tabBarTitle;
@property (nonatomic, copy) NSString *nickname;
//定义一个block
@property (nonatomic, copy) ChangeTextBlock block;

@end
