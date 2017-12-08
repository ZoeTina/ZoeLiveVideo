//
//  PVRecommandCollectionViewCell.h
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVideoListModel.h"
#import "PVSpecialTopicModel.h"

@interface PVRecommandCollectionViewCell : UICollectionViewCell

///控制照片的显示模式和比例
@property(nonatomic, assign)NSInteger type;
///数据源
@property(nonatomic, strong)PVVideoListModel* videoListModel;

@property(nonatomic, assign)BOOL isSpecial;

///那个模板
@property(nonatomic, assign)NSInteger modelType;

///专题
@property(nonatomic, strong)PVSpecialTopicModel* specialTopicModel;

@end
