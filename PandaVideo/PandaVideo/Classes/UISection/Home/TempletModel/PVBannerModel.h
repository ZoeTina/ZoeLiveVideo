//
//  PVBannerModel.h
//  PandaVideo
//
//  Created by cara on 17/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

/*
 bannerTxt = “无人店”亮相杭州街头：进店需绑定顾客身份特征;
	bannerImage = http://172.16.17.188:80/Images/2017/09/02/20170902162653888eyociexabq.jpg;
	bannerUrl = http://172.16.17.188:80/Video/2017/08/10/20000002000000000000000000006904.json;
	bannerType = 单集;
	bannerId = 20000002000000040000000000148210;
 */


@interface PVBannerModel : PVBaseModel

@property(nonatomic, copy)NSString* bannerTxt;
@property(nonatomic, copy)NSString* bannerImage;
@property(nonatomic, copy)NSString* bannerUrl;
@property(nonatomic, copy)NSString* bannerType;
@property(nonatomic, copy)NSString* bannerId;

@end
