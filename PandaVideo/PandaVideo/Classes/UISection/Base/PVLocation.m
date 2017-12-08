//
//  PVLocation.m
//  PandaVideo
//
//  Created by cara on 17/9/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLocation.h"
#import <CoreLocation/CoreLocation.h>


@interface PVLocation()  <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLGeocoder* geocoder;

@end

@implementation PVLocation


-(instancetype)init{
    
    self = [super init];
    if (self) {
        [self initLocation];
    }
    return self;
}

-(void)initLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self requestAuthorization];
    self.geocoder = [[CLGeocoder alloc]  init];
    
    //添加定时器
    NSTimer*  locationTimer = [NSTimer timerWithTimeInterval:300 target:self selector:@selector(startLocation) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:locationTimer forMode:NSRunLoopCommonModes];
}

- (void)requestAuthorization{
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

-(void)startLocation{
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    // 2.停止定位
    [manager stopUpdatingLocation];
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark* placemark = placemarks.firstObject;
        NSString*  province = placemark.administrativeArea;
        if (province.length) {
            [[NSUserDefaults standardUserDefaults]  setObject:province forKey:@"province"];
            [[NSUserDefaults standardUserDefaults]  synchronize];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        PVLog(@"-定位失败error--%@---",error);
    }
}
@end
