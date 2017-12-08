//
//  PVVideoDetailTempletCell.h
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVideoListModel.h"

@interface PVVideoDetailTempletCell : UICollectionViewCell


@property(nonatomic, strong)PVVideoListModel* videoListModel;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoSubTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftTopImageView;
@property (weak, nonatomic) IBOutlet UIView *rightBottomView;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTopLabelTopConstaint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBottomLabelBottomConstaint;


@end
