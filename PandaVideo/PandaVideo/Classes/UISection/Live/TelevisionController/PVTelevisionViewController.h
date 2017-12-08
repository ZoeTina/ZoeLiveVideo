//
//  PVTelevisionViewController.h
//  PandaVideo
//
//  Created by cara on 17/7/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseVideoPlayToolController.h"
#import "PVBroadCastView.h"

@interface PVTelevisionViewController : SCBaseVideoPlayToolController

@property(nonatomic, copy)NSString* url;
@property(nonatomic, assign) NSInteger typePage;
@property(nonatomic, copy)NSString* jumpUrl;
@property(nonatomic, copy)NSString* jumpType;
@property(nonatomic, strong)PVBroadCastView* broadCastContainerView;


///如果停止广播，就隐藏广播页面
-(void)hidebroaCast:(BOOL)isHidden;

@end
