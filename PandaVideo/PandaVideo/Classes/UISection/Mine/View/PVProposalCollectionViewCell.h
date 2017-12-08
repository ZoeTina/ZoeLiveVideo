//
//  PVProposalCollectionViewCell.h
//  PandaVideo
//
//  Created by cara on 17/8/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVPhotoModel.h"

typedef void(^PVProposalCollectionViewCellBlock)();

@interface PVProposalCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)PVPhotoModel* photoModel;

-(void)setPVProposalCollectionViewCellBlock:(PVProposalCollectionViewCellBlock)block;


@end