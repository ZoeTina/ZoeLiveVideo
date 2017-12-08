//
//  LZVideoPlayBackModel.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZVideoPlayBackModel : NSObject

/** 视频标题 */
@property (nonatomic, copy  ) NSString          *title;
/** 视频URL */
@property (nonatomic, strong) NSURL             *videoURL;
/** 视频清晰度 */
@property (nonatomic, strong) NSString          *urlName;
/** 视频封面本地图片 */
@property (nonatomic, strong) UIImage           *placeholderImage;
/**
 * 视频封面网络图片url
 * 如果和本地图片同时设置，则忽略本地图片，显示网络图片
 */
@property (nonatomic, copy  ) NSString          *placeholderImageURLString;
/** 视频分辨率 */
@property (nonatomic, strong) NSDictionary      *resolutionDic;
/** 从xx秒开始播放视频(默认0) */
@property (nonatomic, assign) NSInteger         seekTime;
// cell播放视频，以下属性必须设置值
@property (nonatomic, strong) UITableView       *tableView;
/** cell所在的indexPath */
@property (nonatomic, strong) NSIndexPath       *indexPath;
/** 播放器View的父视图（必须指定父视图）*/

@property (nonatomic, weak) UIView            *fatherView;

//@property (nonatomic, assign)BOOL               isProvince;

///** 是否为多集 */
//@property (nonatomic, assign) BOOL              isVideos;
///** 多集列表信息 */
//@property (nonatomic, strong) NSArray<VideosListModel *>  *videos;

@end
