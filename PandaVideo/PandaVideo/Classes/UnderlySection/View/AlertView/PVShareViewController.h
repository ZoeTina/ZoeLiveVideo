//
//  PVShareViewController.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"

@class PVShareModel;

@interface PVShareViewController : SCBaseViewController
//@property (nonatomic, strong) PVDemandVideoDetailModel *shareModel;
@property (nonatomic, strong) PVShareModel *shareModel;
@end

@interface PVShareModel : NSObject
@property (nonatomic, copy) NSString *h5Url;
@property (nonatomic, copy) NSString *sharetitle;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *descriptStr;
@property (nonatomic, copy) NSString *videoUrl;
@end
