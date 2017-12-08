//
//  AppDelegate.m
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "AppDelegate.h"
#import "SCMainViewController.h"
#import "IQKeyboardManager.h"
#import "PVTelevisionViewController.h"
#import "PVLocation.h"
#import "AppDelegate+PVShare.h"
#import "AppDelegate+AddressBook.h"
#import "AppDelegate+UserGuide.h"
#import <Bugly/Bugly.h>
#import <AVFoundation/AVFoundation.h>
#import "PVDBManager.h"
#import "PVUploadVideoTool.h"
#import "PVAppStorePurchaseModel.h"

#import "PVHomeViewController.h"
#import "PVDemandViewController.h"
#import "PVSpecialSecondDetailController.h"
#import "PVWebViewController.h"
#import "PVInteractiveZBViewController.h"
#import "PVLIveViewController.h"


//版本号
#import "PVVersionViewController.h"
//广告页
#import "PVAdsViewController.h"
#import "PVVersionModel.h"
#import "PVADsModel.h"
#import "PVUploadVideoTool.h"

//推送
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "PVCodeListModel.h"
///音频鉴权
#import "PVVideoAuthentication.h"


@interface AppDelegate () <JPUSHRegisterDelegate>

@property(nonatomic, strong)PVLocation* location;
@property(nonatomic,strong)PVVersionModel * versionModel;
@property(nonatomic,strong)NSArray *adsArray;
@property(nonatomic,assign)UIBackgroundTaskIdentifier bgTaskId;
/** 授权工具类 */
@property(nonatomic, strong)PVVideoAuthentication* videoAuthentication;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    [self registLocalNotificationWithOptions:launchOptions];
    
    ///初始化登陆信息
    [[PVUserModel shared] load];
    
    [self initConfigSettingData];
    [[PVMineConfigModel shared] load];
    
    ///开启监听网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkReachabilityStatus object:nil userInfo:@{@"status":@(status)}];
    }];
    
    [self registerMobLoginAndShare];
    
    //开启定位
    [self.location startLocation];
    
    //监听广播打电话中断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //配置键盘
    [IQKeyboardManager sharedManager];
    
    //配置bugly
    [Bugly startWithAppId:kPanda_BuglyAppId];

//    [NSThread sleepForTimeInterval:1.0];
//    [self setMainVC];
    // 通讯录授权操作
 //   [self requestAuthorization];
    
    //获取联想关键词
    [self loadAssociationKeyWords];
    
    //启动时检测是否有正在上传的ugc视频
    [self changeUGCModelState];
    //检测订单
    [self checkUnSuccessOrder];
    
    ///极光推送
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {}
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:kJGtAppKey
                          channel:@"App Store"
                 apsForProduction:true];
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //产品包
    [[PVCodeListModel sharedInstance] getVideoProduct];

    [self setVersionVC];
    return YES;
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    //101d855909798459206
    NSLog(@"--------%@--------",userInfo);
    
}

//处理中断事件
-(void)handleInterreption:(NSNotification *)sender
{
    if([self.broadCastPlayer isPlaying])
    {
        [self.broadCastPlayer pause];
    }
    else
    {
        if (self.broadCastPlayer) {
            [self.broadCastPlayer play];
        }
        
    }
}


-(void)changeBroadCast:(PVPlayVideoModel*)playVideoModel{
    if (!playVideoModel.url.absoluteString.length)return;
    self.playVideoModel = playVideoModel;
    //关闭播放器缓冲
    if (self.broadCastPlayer != nil) {
        [self.broadCastPlayer shutdown];
        [self.broadCastPlayer stop];
        self.broadCastPlayer = nil;
    }
    //开启鉴权
    self.videoAuthentication.productModel.code = playVideoModel.code;
    self.videoAuthentication.videoDistrict = playVideoModel.videoDistrict;
    [self.videoAuthentication playVideoAuthentication];
    NSLog(@"-----鉴权结果----%ld",self.videoAuthentication.authenticationType);
    PVTelevisionViewController* vc = self.window.rootViewController.childViewControllers[1].childViewControllers.firstObject.childViewControllers.firstObject;
    vc.broadCastContainerView.authenticationType  = self.videoAuthentication.authenticationType;
    if (self.videoAuthentication.authenticationType == 3) {
        vc.broadCastContainerView.orderView.hidden = true;
        vc.broadCastContainerView.flowPlayCenterBtn.hidden = true;
        NSURL* playUrl = playVideoModel.url;
        IJKFFOptions* options = [[IJKFFOptions alloc]  init];
        IJKFFMoviePlayerController* player = [[IJKFFMoviePlayerController alloc] initWithContentURL:playUrl withOptions:options];
        self.broadCastPlayer = player;
        if (![player isPlaying]) {
            [player prepareToPlay];
            [vc hidebroaCast:false];
        }
    }else if (self.videoAuthentication.authenticationType == 2){///此内容只能在四川省内播放
        vc.broadCastContainerView.FMPlayOrStopBtn.selected = false;
        vc.broadCastContainerView.orderView.hidden = false;
        vc.broadCastContainerView.isDispLayAnimate = false;
    }else if (self.videoAuthentication.authenticationType == 6){///走订购产品流程
        vc.broadCastContainerView.FMPlayOrStopBtn.selected = false;
        vc.broadCastContainerView.orderView.hidden = false;
        vc.broadCastContainerView.isDispLayAnimate = false;
    }
}
///开始播放广播
-(void)playBroadCast:(PVPlayVideoModel*)playVideoModel{
    if (!playVideoModel.url.absoluteString.length)return;
    self.playVideoModel = playVideoModel;
    //关闭播放器缓冲
    if (self.broadCastPlayer != nil) {
        [self.broadCastPlayer shutdown];
        [self.broadCastPlayer stop];
        self.broadCastPlayer = nil;
    }
    //开启鉴权
    self.videoAuthentication.productModel.code = playVideoModel.code;
    self.videoAuthentication.videoDistrict = playVideoModel.videoDistrict;
    [self.videoAuthentication playVideoAuthentication];
    NSLog(@"-----鉴权结果----%ld",self.videoAuthentication.authenticationType);
    PVTelevisionViewController* vc = self.window.rootViewController.childViewControllers[1].childViewControllers.firstObject.childViewControllers.firstObject;
    vc.broadCastContainerView.authenticationType  = self.videoAuthentication.authenticationType;
    if (self.videoAuthentication.authenticationType == 3) {
        vc.broadCastContainerView.orderView.hidden = true;
        vc.broadCastContainerView.flowPlayCenterBtn.hidden = true;
        NSURL* playUrl = playVideoModel.url;
        IJKFFOptions* options = [[IJKFFOptions alloc]  init];
        IJKFFMoviePlayerController* player = [[IJKFFMoviePlayerController alloc] initWithContentURL:playUrl withOptions:options];
        self.broadCastPlayer = player;
        if (![player isPlaying]) {
            [player prepareToPlay];
            [vc hidebroaCast:false];
        }
        vc.broadCastContainerView.isDispLayAnimate = true;
    }else if (self.videoAuthentication.authenticationType == 2){///此内容只能在四川省内播放
        vc.broadCastContainerView.FMPlayOrStopBtn.selected = false;
        vc.broadCastContainerView.orderView.hidden = false;
    }else if (self.videoAuthentication.authenticationType == 6){///走订购产品流程
        vc.broadCastContainerView.FMPlayOrStopBtn.selected = false;
        vc.broadCastContainerView.orderView.hidden = false;
    }
}
///停止播放广播
-(void)stopBroadCastPlay:(BOOL)isSelf{
    if (self.broadCastPlayer != nil) {
        [self.broadCastPlayer shutdown];
        [self.broadCastPlayer stop];
        self.broadCastPlayer = nil;
        PVTelevisionViewController* vc = self.window.rootViewController.childViewControllers[1].childViewControllers.firstObject.childViewControllers.firstObject;
        vc.broadCastContainerView.isDispLayAnimate = false;
        if (!isSelf) {
            [vc hidebroaCast:true];
        }
    }
}
-(PVVideoAuthentication *)videoAuthentication{
    if (!_videoAuthentication) {
        PVProductModel*  productModel = [[PVProductModel alloc]  init];
        productModel.code = self.playVideoModel.code;
        _videoAuthentication = [[PVVideoAuthentication alloc]  initVideoPVProductModel:productModel];
        _videoAuthentication.videoDistrict = self.playVideoModel.videoDistrict;
        PV(pv)
        [_videoAuthentication setPVVideoAuthenticationCallBlock:^(NSInteger type, BOOL isStop) {
            PVTelevisionViewController* vc = pv.window.rootViewController.childViewControllers[1].childViewControllers.firstObject.childViewControllers.firstObject;
            if (type == 2 && !isStop) {//继续播放
                vc.broadCastContainerView.orderView.hidden = true;
                vc.broadCastContainerView.flowPlayCenterBtn.hidden = true;
                IJKFFOptions* options = [[IJKFFOptions alloc]  init];
                IJKFFMoviePlayerController* player = [[IJKFFMoviePlayerController alloc] initWithContentURL:pv.playVideoModel.url withOptions:options];
                pv.broadCastPlayer = player;
                if (![player isPlaying]) {
                    [player prepareToPlay];
                    [vc hidebroaCast:false];
                }
                vc.broadCastContainerView.isDispLayAnimate = true;
            }else if (type == 2 && isStop){
                vc.broadCastContainerView.isDispLayAnimate = false;
                vc.broadCastContainerView.flowPlayCenterBtn.hidden = false;
                [pv stopBroadCastPlay:false];
                [vc hidebroaCast:true];
            }
        }];
    }
    return _videoAuthentication;
}

//初始化设置界面的配置
- (void)initConfigSettingData {
    
//
    [[PVMineConfigModel shared] load];
    PVMineConfigModel *configModel = [PVMineConfigModel shared];
    if (configModel.isFirstLogin == NO) {
        configModel.netCacheTips = YES;
        configModel.netPlayTips = YES;
        configModel.netUploadingTips = YES;
        configModel.postTips = YES;
        configModel.isFirstLogin = YES;
        [configModel dump];
    }
    
}

///**
// 直接设置根视图
// */
//- (void)setMainVC {
//    self.window.rootViewController = [[SCMainViewController alloc] init];
//    [self.window makeKeyAndVisible];
//}

//设置版本页面为主视图
- (void)setVersionVC{
    PVVersionViewController * vc = [[PVVersionViewController alloc] init];
    self.window.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}


-(void)loadAssociationKeyWords{
    NSDictionary* params = @{@"key":@" "};
    [PVNetTool postDataWithParams:params url:@"getKeys" success:^(id result) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (result[@"data"] && [result[@"data"] isKindOfClass:[NSArray class]]) {
                NSMutableArray* dataSource = [NSMutableArray array];
                NSArray* jsonArr = result[@"data"];
                for (NSDictionary* jsonDict in jsonArr) {
                    PVAssociationKeyWordModel* keyWordModel = [[PVAssociationKeyWordModel alloc]  init];
                    [keyWordModel setValuesForKeysWithDictionary:jsonDict];
                    [dataSource addObject:keyWordModel];
                }
                [[PVDBManager sharedInstance].associationKeyWordDataSource removeAllObjects];
                [[PVDBManager sharedInstance].associationKeyWordDataSource addObjectsFromArray:dataSource];;
            }
        });
    } failure:nil];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession* session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
}

/** 通讯录授权及其获取联系人数据*/
- (void) requestAuthorization{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        // 获取通讯录数据
        [self requestAuthorizationForAddressBook];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
        });
        
    });
}


/**
 应用启动时token登录
 */
- (void)tokenLogin {
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        return;
    }
    
    NSDictionary *dict = @{@"device":@(iOSPlatform),@"token":[PVUserModel shared].token, @"uid":[PVUserModel shared].userId};;
    [PVNetTool postDataWithParams:dict url:@"/tokenLogin" success:^(id result) {
        if (result) {
            if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                
                PVUserModel *userModel = [PVUserModel shared];
                [userModel yy_modelSetWithDictionary:[result pv_objectForKey:@"data"]];;
                [userModel dump];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)changeUGCModelState {
    //有视频正在上传，不允许
    NSArray *assetArray = [[PVDBManager sharedInstance] selectShortVideoModelAllData];
    for (SCAssetModel *assetModel in assetArray) {
        if ([assetModel.videoPublishState isEqualToString:@"2"] || [assetModel.videoPublishState isEqualToString:@"0"]) {
            assetModel.videoPublishState = @"3";
            [[PVDBManager sharedInstance] insertShortVideoModelWithModel:assetModel];
//            [[[PVUploadVideoTool alloc] init] postNoticicationWithState:@"3" assetModel:assetModel];
        }
    }
}

- (void)checkUnSuccessOrder {
    NSMutableArray *netArray = [[NSMutableArray alloc] init];
    NSMutableArray *productIdArray = [[NSMutableArray alloc] init];
    NSArray *orderInfoModelArray = [[PVDBManager sharedInstance] selectPurchaseOrderModelAllData];
    for (PVAppStorePurchaseModel *purchaseModel in orderInfoModelArray) {
        PVNetModel *netModel = [[PVNetModel alloc] init];
        netModel.url = applePay;
        netModel.postData = purchaseModel.orderTestStr;
        [netArray addObject:netModel];
        [productIdArray addObject:purchaseModel.purchaseOrderId];
    }
    if (netArray.count > 0) {
        [PVNetTool checkMoreOrderDataWithParams:netArray productIdArray:productIdArray success:^(NSArray *result) {
            if (result) {
                for (NSDictionary *resultDict in result) {
                    if ([[resultDict pv_objectForKey:@"rs"] integerValue] == 200) {
                        NSString *productId = [resultDict pv_objectForKey:@"productId"];
                        [[PVDBManager sharedInstance] deletePurchaseOrderModelWithpurchaseOrderId:productId];
                        //token登录
                        [self tokenLogin];
                    }
                }
            }
        } failure:^(NSArray *errors) {
            if (errors) {
                
            }
        }];
    }else {
        //token登录
        [self tokenLogin];
    }
    
}

-(PVLocation *)location{
    if (!_location) {
        _location = [[PVLocation alloc]  init];
    }
    return _location;
}
+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

#pragma mark  本地通知（预约）
- (void)registLocalNotificationWithOptions:(NSDictionary *)launchOptions {
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    if (notification) {
//        NSString* kid = notification.userInfo[@"id"];
    }
}

//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    if (self.shouldChangeOrientation == YES) {
//        return UIInterfaceOrientationMaskLandscape;
//    } else {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//    //    return UIInterfaceOrientationMaskAll;
//}
#pragma mark  极光推送
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        [self handleRemoteNotificationWhenAppInBackground:[UIApplication sharedApplication] userInfo:userInfo];
    }
    self.userInfo = userInfo;
    self.isImplementPush = true;
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        [self handleRemoteNotificationWhenAppInBackground:[UIApplication sharedApplication] userInfo:userInfo];
    }
    self.userInfo = userInfo;
    self.isImplementPush = true;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    ///处理推送结果

        self.isImplementPush = true;
        self.userInfo = userInfo;
     if (application.applicationState == UIApplicationStateInactive){
         [self handleRemoteNotificationWhenAppInBackground:application userInfo:userInfo];
     }else{
         
     }
//     else if (application.applicationState == UIApplicationStateBackground) {
//         [self handleRemoteNotificationWhenAppInBackground:application userInfo:userInfo];
//     }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
   

    //处理推送结果
    if (application.applicationState == UIApplicationStateInactive){
        [self handleRemoteNotificationWhenAppInBackground:application userInfo:userInfo];
    }else{
       
    }
    self.isImplementPush = true;
    self.userInfo = userInfo;
        //else if (application.applicationState == UIApplicationStateBackground) {
//        [self handleRemoteNotificationWhenAppInBackground:application userInfo:userInfo];
//    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

-(void)handleRemoteNotificationWhenAppInBackground:(UIApplication*)application   userInfo:(NSDictionary*)userInfo{
        [JPUSHService setBadge:0];
        [JPUSHService resetBadge];
        application.applicationIconBadgeNumber = 0;
        //对接送进行解析
        if (userInfo[@"iosNotification extras key"] && [userInfo[@"iosNotification extras key"] isKindOfClass:[NSString class]]) {
            NSDictionary* jsonDict  = [self dictionaryWithJsonString:userInfo[@"iosNotification extras key"]];
            NSString* type = [NSString stringWithFormat:@"%@",jsonDict[@"type"]];
            NSString* url = jsonDict[@"url"];
            UITabBarController* tabVC = (UITabBarController*)application.keyWindow.rootViewController;
            UINavigationController* navVC = tabVC.selectedViewController;
            if (type.integerValue == 0) {//跳点播页面
                PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
                vc.url = url;
                [navVC pushViewController:vc animated:true];
            }else if (type.integerValue == 1){//直播频道
                    PVLIveViewController* liveVC = tabVC.childViewControllers[1].childViewControllers.firstObject;
                    if (liveVC.childViewControllers.count > 0) {
                        PVTelevisionViewController* vc = liveVC.childViewControllers.firstObject;
                        vc.jumpType = @"2";
                        vc.jumpUrl = url;
                        [liveVC scrollTelevision];
                    }else{
                        liveVC.menuModel.jumpType = @"1";
                        liveVC.menuModel.jumpUrl = url;
                    }
                    tabVC.selectedIndex = 1;
            }else if (type.integerValue == 2){//互动直播详情页
                PVInteractiveZBViewController* vc = [[PVInteractiveZBViewController alloc]  init];
                vc.menuUrl = url;
                [navVC pushViewController:vc animated:true];
            }else if (type.integerValue == 3 || type.integerValue == 4){//活动
                PVWebViewController* vc = [[PVWebViewController alloc]  initWebViewControllerWithWebUrl:url webTitle:@""];
                if (url.length < 10) {
                    return;
                }
                [navVC pushViewController:vc animated:true];
            }else if (type.integerValue == 5){//专题详情页
                PVSpecialSecondDetailController* vc = [[PVSpecialSecondDetailController alloc]  init];
                vc.menuUrl = url;
                [navVC pushViewController:vc animated:true];
            }
            NSLog(@"jsonDict = %@",jsonDict);
        }
}



- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
