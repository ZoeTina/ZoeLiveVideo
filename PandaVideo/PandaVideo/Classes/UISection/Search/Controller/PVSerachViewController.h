//
//  PVSerachViewController.h
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVSerachViewController : UIViewController

@property(nonatomic, strong)UINavigationController* nav;
@property(nonatomic, copy)NSString* placeName;
@property(nonatomic, assign)BOOL isFamily;
@property(nonatomic,copy)NSString * nikename;//昵称
@property(nonatomic,copy)NSString *targetPhone;

@end
