//
//  PVAnthologyCollectionViewCell.h
//  PandaVideo
//
//  Created by cara on 17/8/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVDemandVideoAnthologyModel.h"
#import "PVSearchResultModel.h"

@interface PVAnthologyCollectionViewCell : UICollectionViewCell

@property(nonatomic, assign)BOOL isCross;

@property(nonatomic, strong)UIButton* trailerBtn;

@property(nonatomic, strong)PVDemandVideoAnthologyModel*  anthologyModel;

@property(nonatomic, strong)PVSearchEpisodeListModel* episodeListModel;

@property (weak, nonatomic) IBOutlet UIButton *countAnthology;

@end
