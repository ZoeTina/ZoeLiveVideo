//
//  PVPlayVideoModel.h
//  PandaVideo
//
//  Created by cara on 2017/11/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVVideoAuthentication.h"


///播放器model
@interface PVPlayVideoModel : NSObject

/** 单集1,多集 2,直播3, 短视频4,回看5*/
@property (nonatomic, assign)NSInteger  type;
/** 地方范围播放 */
@property(nonatomic, copy)NSString*  videoDistrict;
/** 视频播放链接 */
@property (nonatomic, strong) NSURL *url;
/** 直播版权 */
@property(nonatomic, copy)NSString* copyright;
///1:免费包;   2:基础包;    3:尊享包.
@property(nonatomic, copy)NSString* code;


@end
