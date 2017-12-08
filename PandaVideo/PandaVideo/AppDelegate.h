//
//  AppDelegate.h
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "PVTongxunluModel.h"
#import "PVPlayVideoModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

///是否执行了推送
@property(nonatomic, assign)BOOL isImplementPush;
@property(nonatomic, strong)NSDictionary* userInfo;
@property (nonatomic, weak) UIView *shadowView;

///广播播放器
@property(nonatomic, strong)IJKFFMoviePlayerController* broadCastPlayer;
///广播播放地址
@property(nonatomic, strong)PVPlayVideoModel* playVideoModel;
@property(nonatomic,copy)void(^userGuideBlock)(NSInteger index);

///开始播放广播
-(void)playBroadCast:(PVPlayVideoModel*)playVideoModel;
///切换广播
-(void)changeBroadCast:(PVPlayVideoModel*)playVideoModel;
///停止播放广播
-(void)stopBroadCastPlay:(BOOL)isSelf;

/** 通讯录Models数据 */
@property (strong, nonatomic) NSMutableArray<PVTongxunluModel *> *dataArray;


//@property (assign, nonatomic) BOOL shouldChangeOrientation;
-(void)handleRemoteNotificationWhenAppInBackground:(UIApplication*)application   userInfo:(NSDictionary*)userInfo;

@end
/*
 {
 "clsName" : "PVThreeTabItemViewController",
 "title" : "家庭圈",
 "imageName" : "family"
 },
 */
