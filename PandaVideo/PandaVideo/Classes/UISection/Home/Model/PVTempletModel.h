//
//  PVTempletModel.h
//  PandaVideo
//
//  Created by cara on 17/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"
#import "PVVideoTemletModel.h"

typedef void(^UpdateCollectionView)(void);

@interface PVTempletModel : PVBaseModel

///模板id
@property(nonatomic, copy)NSString* modelType;
@property(nonatomic, copy)NSString* type;
///模板链接
@property(nonatomic, copy)NSString* modelUrl;
///模板有些是数组
@property(nonatomic, strong)NSMutableArray* modelDataSource;
///视频的model
@property(nonatomic, strong)PVVideoTemletModel* videoTemletModel;
///用于控制当前显示的个数
@property(nonatomic, assign)NSInteger chargeIndex;

///更新频道
-(void)setUpdateCollectionView:(UpdateCollectionView)block;

@end
