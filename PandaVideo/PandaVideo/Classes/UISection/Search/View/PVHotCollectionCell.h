//
//  PVHotCollectionCell.h
//  PandaVideo
//
//  Created by cara on 17/7/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVHotWord.h"

@interface PVHotCollectionCell : UICollectionViewCell

@property(nonatomic, assign)NSInteger section;
@property(nonatomic, strong)PVHotWord* hotWordModel;


@end
