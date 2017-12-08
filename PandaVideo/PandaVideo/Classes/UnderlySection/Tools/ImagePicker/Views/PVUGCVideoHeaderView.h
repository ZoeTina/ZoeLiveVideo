//
//  PVUGCVideoHeaderView.h
//  PandaVideo
//
//  Created by songxf on 2017/11/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAssetModel.h"
@interface PVUGCVideoHeaderView : UICollectionReusableView

@property(nonatomic,strong)UILabel * dateLabel;
@end


@interface PVUGCVideoSelectedCell : UICollectionViewCell

@property(nonatomic,copy)void(^playVideoBlock)(void);
@property(nonatomic,strong)SCAssetModel * model;
@end
