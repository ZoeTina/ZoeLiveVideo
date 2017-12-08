//
//  PVThridLoginView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/19.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PVThridLoginViewButtonClickDelegate <NSObject>
- (void)weixinClick;
- (void)QQClick;
- (void)weiboClick;
@end

@interface PVThridLoginView : UIView

@property (nonatomic, weak) id<PVThridLoginViewButtonClickDelegate> thridLoginViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame;
@end
