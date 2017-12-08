//
//  PVSpecialDetailModel.h
//  PandaVideo
//
//  Created by cara on 2017/10/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVVideoListModel.h"

@interface PVSpecialDetailModel : PVBaseModel

@property(nonatomic, copy)NSString* htmlUrl;
@property(nonatomic, copy)NSString* modelType;
@property(nonatomic, copy)NSString* showType;
@property(nonatomic, copy)NSString* topicImage;
@property(nonatomic, copy)NSString* topicSubTitle;
@property(nonatomic, copy)NSString* topicTitle;
@property(nonatomic, strong)NSMutableArray<PVVideoListModel*>* topicList;
@property(nonatomic, assign)CGFloat topicSubTitleHeight;


@end
