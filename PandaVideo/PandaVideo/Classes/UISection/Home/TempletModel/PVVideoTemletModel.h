//
//  PVVideoTemletModel.h
//  PandaVideo
//
//  Created by cara on 17/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVVideoListModel.h"
#import "PVModelTitleDataModel.h"


@class HasChangeData,ModelMoreData;
@class PVVideoSiftingListModel;
@class PVVideoSiftingListTagDataModel;
@interface PVVideoTemletModel : PVBaseModel

@property(nonatomic, strong)PVModelTitleDataModel*  modelTitleDataModel;
@property(nonatomic, strong)ModelMoreData*  modelMoreData;
@property(nonatomic, strong)HasChangeData*  hasChangeData;
@property(nonatomic, strong)NSMutableArray<PVVideoListModel*>*  videoListModel;
@property(nonatomic, assign)NSInteger count;
@property(nonatomic, assign)BOOL  isMore;


@end



///是否可以进行换一换操作
@interface HasChangeData : PVBaseModel

@property(nonatomic, strong)NSString*  hasChangeWord;
@property(nonatomic, copy)NSString*  hasChange;

@end


///模板更多按钮对象
@interface ModelMoreData : PVBaseModel

///更多按钮文本
@property(nonatomic, copy)NSString*  modelMore;
///更多按钮文本
@property(nonatomic, copy)NSString*  modelMoreTxt;
///更多按钮跳转类型
@property(nonatomic, copy)NSString*  modelMoreType;
///更多按钮跳转目标URL
@property(nonatomic, copy)NSString*  modelMoreUrl;
@property(nonatomic, copy)NSString*  modelMoreId;

@end


#pragma mark -- 二级栏目筛选
@interface PVVideoSiftingModel : NSObject

@property(nonatomic, assign)NSInteger  currentIndex;
@property(nonatomic, assign)NSInteger  pageAllIndex;
@property(nonatomic, assign)NSInteger  showType;
@property(nonatomic, strong)NSArray <PVVideoSiftingListModel *> *videoList;

@end

@interface PVVideoSiftingListModel : NSObject

@property(nonatomic, copy)NSString *code;
@property(nonatomic, copy)NSString *videoSubTitle;
@property(nonatomic, copy)NSString *videoTitle;
@property(nonatomic, assign)NSInteger  videoType;
@property(nonatomic, copy)NSString *videoUrl;
@property(nonatomic, copy)NSString *videoVImage;
@property(nonatomic, strong)PVVideoSiftingListTagDataModel *tagData;

@end


@interface PVVideoSiftingListTagDataModel : NSObject


@end
