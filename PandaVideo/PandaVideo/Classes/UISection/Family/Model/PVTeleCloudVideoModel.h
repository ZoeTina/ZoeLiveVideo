//
//  PVTeleCloudVideoModel.h
//  PandaVideo
//
//  Created by songxf on 2017/11/9.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVTeleCloudVideoListModel;
@interface PVTeleCloudVideoModel : NSObject

@property(nonatomic,strong)NSArray <PVTeleCloudVideoListModel *> *cloudVideoList;
@property(nonatomic,assign)NSInteger total;
@end

@interface PVTeleCloudVideoListModel : NSObject
///是否要删除
@property(nonatomic, assign)BOOL isDelete;
//封面图
@property(nonatomic,copy)NSString *image;
//排序
@property(nonatomic,assign)NSInteger sort;
//标题
@property(nonatomic,copy)NSString *title;
//更新信息
@property(nonatomic,copy)NSString *update;
//视频ID
@property(nonatomic,copy)NSString *videoId;
@end

@interface PVTeleCloudAuthorizeModel : NSObject

@property(nonatomic,assign)BOOL isAuthorize;
@end
