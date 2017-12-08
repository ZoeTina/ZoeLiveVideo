//
//  PVMyVideoModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVMyVideoModel : NSObject

///是否要删除
@property(nonatomic, assign)BOOL isDelete;

///视频code
@property (nonatomic, copy) NSString *videoCode;
///视频时长
@property (nonatomic, assign) NSInteger videoDuration;
///视频封面图地址
@property (nonatomic, copy) NSString *videoImg;
///视频状态,0：审核中；1：审核通过；2：审核不通过
@property (nonatomic, assign) NSInteger videoStatus;
///视频提交时间
@property (nonatomic, copy) NSString *videoSubTime;
///视频标题
@property (nonatomic, copy) NSString *videoTitle;
//视频ID
@property (nonatomic, copy) NSString *videoId;

@end

@interface PVMyVideoListModel : NSObject
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger pageAllIndex;
@property (nonatomic, strong) NSArray <PVMyVideoModel *> * videoList;
@end
