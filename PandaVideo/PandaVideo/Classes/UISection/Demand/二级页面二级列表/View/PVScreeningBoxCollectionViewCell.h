//
//  PVScreeningBoxCollectionViewCell.h
//  PandaVideo
//
//  Created by Ensem on 2017/10/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVChoiceSecondColumnModel.h"


@interface PVScreeningBoxCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIButton *textBtn;
@property (nonatomic, strong) NSDictionary *resultData; // 数据数组
@property (nonatomic, strong) KeyModel *keyModel; // 数据数组

@end
