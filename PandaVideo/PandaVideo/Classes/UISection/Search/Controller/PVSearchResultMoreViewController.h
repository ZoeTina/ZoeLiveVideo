//
//  PVSearchResultMoreViewController.h
//  PandaVideo
//
//  Created by songxf on 2017/11/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "SCBaseViewController.h"

@interface PVSearchResultMoreViewController : SCBaseViewController

 ///是否文字显示
@property(nonatomic,assign)NSInteger showType;
///视频标题
@property(nonatomic, copy)NSString* videoTitle;
///网络链接
@property(nonatomic, copy)NSString* url;

@end
