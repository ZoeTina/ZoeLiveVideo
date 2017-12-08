//
//  PVVideoAuthentication.m
//  PandaVideo
//
//  Created by cara on 17/9/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoAuthentication.h"
#import <CoreLocation/CLLocationManager.h>
#import "PVRegionFlowController.h"
#import "PVCodeListModel.h"

@interface PVVideoAuthentication()

///记录上次网络的状况
@property(nonatomic, assign)AFNetworkReachabilityStatus recordStatus;
///付费类型
@property(nonatomic, assign)NSInteger payType;
///是否位省内播放还是省外可以播
@property(nonatomic, assign)NSInteger provincePlayType;
///提示UI
@property(nonatomic, strong)PVRegionFlowController* regionFlowController;
///回调事件
@property(nonatomic, copy)PVVideoAuthenticationCallBlock callBlock;
///判断是否全屏
@property(nonatomic, copy)PVVideoIsCrossCallBlock isCrossCallBlock;


@end


@implementation PVVideoAuthentication


-(instancetype)initVideoPVProductModel:(PVProductModel *)productModel{
    self = [super init];
    if (self) {//监测网络情况
        self.productModel = productModel;
        self.payType = productModel.payType;
        self.provincePlayType = productModel.provincePlayType;
    }
    return self;
}
-(void)playVideoAuthentication{
//    self.authenticationType = 3;
//    return;
    if (![self judgeLoactionJurisdiction]) {//定位不可用,弹对话框
        self.authenticationType = 1;
        self.regionFlowController = [PVRegionFlowController presentPVRegionFlowController:@"请先打开定位功能，才能继续播放" type:0];
        [self regionFlowCallBlock];
        return;
    }
    if (![self judgeLoactionProvinceJurisdiction]) {//该视频不支持四川省播放
         self.regionFlowController = [PVRegionFlowController presentPVRegionFlowController:@"此内容仅限四川省内播放" type:1];
        self.authenticationType = 2;
        [self regionFlowCallBlock];
        
        return;
    }
    if ([self judgeNetIsWifi] == 1) {//是wifi，走免费还是试播流程
        [self.regionFlowController dismissViewControllerAnimated:true completion:nil];
        //走产品鉴权
        if ([self judgeVideoProduct]) {
            self.authenticationType = 3;
        }else{///没有产品资格
            self.authenticationType = 6;
        }
    }else if ([self judgeNetIsWifi] == 2){//是数据流量,弹对话框
         self.authenticationType = 4;
        if ([PVMineConfigModel shared].netPlayTips) {
            self.regionFlowController = [PVRegionFlowController presentPVRegionFlowController:@"非WiFi环境，继续播放将消耗您的数据流量,是否继续播放?" type:2];
            [self regionFlowCallBlock];
        }else{
            self.authenticationType = 7;
            self.callBlock(2,true);
        }
      
    }else{//没网
        self.authenticationType = 5;
    }
}

-(void)regionFlowCallBlock{
    PV(pv)
    if (self.isCrossCallBlock) {
        self.isCrossCallBlock();
    }
    [self.regionFlowController setPVRegionFlowControllerCallBlock:^(NSInteger type, BOOL isStop) {
        if (type == 0) {//去设置打开定位
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }else if (type == 1){//是否在四川省内
            pv.authenticationType = 2;
        }else if (type == 2 && !isStop){//2.为数据流量并且继续
            //走产品鉴权
            if ([pv judgeVideoProduct]) {
                pv.authenticationType = 3;
            }else{///没有产品资格
                pv.authenticationType = 6;
            }
            pv.callBlock(type,false);
        }else if (type == 2 && isStop){//2.为数据流量暂停(为流量播放按钮显示)
            pv.authenticationType = 3;
            pv.callBlock(type,true);
        }
        NSLog(@"type = %ld",type);
    }];
}

-(void)setPVVideoAuthenticationCallBlock:(PVVideoAuthenticationCallBlock)callBlock{
    self.callBlock = callBlock;
}
-(void)setPVVideoIsCrossCallBlock:(PVVideoIsCrossCallBlock)callBlock{
    self.isCrossCallBlock = callBlock;
}


-(void)setRecordStatus:(AFNetworkReachabilityStatus)recordStatus{
    ///时刻监听到的网络情况
    _recordStatus = recordStatus;
}

///判断定位功能是否可用
-(BOOL)judgeLoactionJurisdiction{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        //定位功能可用
        return true;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        //定位不能用
        return false;
    }
    return false;
}
///判断定位地点是否在四川省内
-(BOOL)judgeLoactionProvinceJurisdiction{
    if(self.videoDistrict.integerValue == 2)return true;
    NSString* province = [[NSUserDefaults standardUserDefaults] objectForKey:@"province"];
    if ([province isEqualToString:@"四川省"]) {
        if(self.videoDistrict.integerValue == 1){
            return true;
        }else{
            return false;
        }
    }else{
        return false;
    }
}
///判断网络情况
-(NSInteger)judgeNetIsWifi{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        return 1;
    }else if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
        return 2;
    }else{
        return 3;
    }
}

//判断视频产品包类型
-(BOOL)judgeVideoProduct{
    NSString* pinv = [[PVUserModel shared] authorizationCode];
//    pinv = @"000000000000000";
    NSString* productResult = [PVVideoAuthentication pinxCreator:[[PVCodeListModel sharedInstance] getCorrespondingVideoProduct:self.productModel.code] withPinv:pinv];
    if (self.productModel.code.integerValue == 1) {//免费包
        return true;
    }else if (self.productModel.code.integerValue == 2 || self.productModel.code.integerValue == 3){//基础包
        if (productResult.length && [productResult rangeOfString:@"1"].location != NSNotFound) {
            return true;
        }else{
            return false;
        }
    }
    return false;
}


+ (NSString *)pinxCreator:(NSString *)pan withPinv:(NSString *)pinv
{
    if (pan.length != pinv.length)
    {
        return nil;
    }
    
    const char *panchar = [pan UTF8String];
    const char *pinvchar = [pinv UTF8String];
    
    NSString *temp = [[NSString alloc] init];
    for (int i = 0; i < pan.length; i++){
        int panValue = [self charToint:panchar[i]];
        int pinvValue = [self charToint:pinvchar[i]];
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"%X",panValue&pinvValue]];
    }
    return temp;
    
}

+ (int)charToint:(char)tempChar{
    if (tempChar >= '0' && tempChar <='9'){
        return tempChar - '0';
    }else if (tempChar >= 'A' && tempChar <= 'F'){
        return tempChar - 'A' + 10;
    }
    return 0;
}


@end

@implementation PVProductModel

@end
