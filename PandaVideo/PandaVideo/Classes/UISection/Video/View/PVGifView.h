//
//  PVGifView.h
//  PandaVideo
//
//  Created by cara on 17/9/19.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVGifView.h"


typedef void(^PVGifViewCallBlock)(void);


@interface PVGifView : UIView


-(instancetype)initType:(NSInteger)type;

///大背景图
@property (nonatomic, strong) UIImageView*  videoBgImageView;
///返回按钮
@property (nonatomic, strong) UIButton* backBtn;

///开始第一次加载动画
-(void)startFirstGif;
///停止第一次加载动画
-(void)stopFirstGif;

///返回按钮回调
-(void)setPVGifViewCallBlock:(PVGifViewCallBlock)block;


@end
