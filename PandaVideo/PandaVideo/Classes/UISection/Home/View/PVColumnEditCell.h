//
//  PVColumnEditCell.h
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVHomModel.h"

@class PVColumnEditCell;

@protocol PVColumnEditCellDelegate <NSObject>

///点击手势
-(void)pressCellWithRecognizer:(PVColumnEditCell*)editCell;

///长按手势
-(void)moveCellWithRecognizer:(PVColumnEditCell*)editCell  sender:(UILongPressGestureRecognizer*)sender;

@end


@interface PVColumnEditCell : UICollectionViewCell

@property(nonatomic,strong)UIView *backView;
@property (nonatomic,strong) UIImageView *cellImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)PVHomModel *model;
@property(nonatomic, weak)id<PVColumnEditCellDelegate>delegate;

@end
