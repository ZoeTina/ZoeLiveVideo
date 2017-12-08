//
//  PVCollectionModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVCollectionModel : NSObject

///是否要删除
@property(nonatomic, assign)BOOL isDelete;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
//收藏时间
@property (nonatomic, copy) NSString* cololectTime;
@property (nonatomic, copy) NSString* videoType;
@property (nonatomic, copy) NSString* jsonUrl;

@end

@interface PVCollectionListModel : NSObject
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSArray <PVCollectionModel *> *favList;
@end
