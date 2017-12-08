//
//  PVLeftEqualFlowLayout.h
//  PandaVideo
//
//  Created by cara on 2017/10/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVTempletModel.h"

@interface PVLeftEqualFlowLayout : UICollectionViewFlowLayout

///数据源
@property(nonatomic, strong)NSMutableArray<PVTempletModel*>*   templetDataSource;

@end
