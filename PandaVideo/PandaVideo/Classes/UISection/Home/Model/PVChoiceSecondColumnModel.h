//
//  PVChoiceSecondColumnModel.h
//  PandaVideo
//
//  Created by cara on 2017/10/19.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

@class BaseInfo,Filter,ListModel,KeyModel;

@interface PVChoiceSecondColumnModel : PVBaseModel

@property(nonatomic, strong)BaseInfo* baseInfo;
@property(nonatomic, strong)NSMutableArray <Filter*> *filterList;
@property(nonatomic, strong)NSMutableArray<ListModel*>* listModel;

@end


@interface BaseInfo : PVBaseModel

@property(nonatomic, copy)NSString* isLock;
@property(nonatomic, copy)NSString* code;
@property(nonatomic, copy)NSString* name;
@property(nonatomic, copy)NSString* sort;
// 新加一级栏目ID
@property(nonatomic, copy)NSString* parentId;

@end


@interface Filter : PVBaseModel

@property(nonatomic, copy)      NSString    *filterKey;
@property(nonatomic, copy)      NSString    *videoType;
@property(nonatomic, copy)      NSString    *sort;
@property(nonatomic, strong)    NSMutableArray<KeyModel*>     *keys;
@property(nonatomic, strong)    KeyModel    *selectKeyMode;


@end

@interface KeyModel : PVBaseModel

@property(nonatomic, copy)      NSString    *name;
@property(nonatomic, copy)      NSString    *kId;

@property(nonatomic,assign)     BOOL        isSelect;
@end


@interface ListModel : PVBaseModel

@property(nonatomic, copy)NSString* code;
@property(nonatomic, copy)NSString* name;
@property(nonatomic, copy)NSString* url;

@end

