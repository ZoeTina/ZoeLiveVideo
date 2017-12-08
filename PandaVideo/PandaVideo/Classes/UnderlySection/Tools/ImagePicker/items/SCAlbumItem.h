//
//  SCAlbumItem.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/7/30.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCAssetModel.h"

@interface SCAlbumItem : UITableViewCell

@property (nonatomic, strong) SCAlbumModel *model;
@property (nonatomic, weak) UIButton *selectedCountButton;

@end
