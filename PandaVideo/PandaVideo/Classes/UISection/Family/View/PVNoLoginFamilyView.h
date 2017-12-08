//
//  PVNoLoginFamilyView.h
//  PandaVideo
//
//  Created by cara on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVNoLoginFamilyView : UIView

@property(nonatomic,assign)BOOL isLogin;
@property(nonatomic,copy)void(^comeOnLoginBlock)(void);
@end
