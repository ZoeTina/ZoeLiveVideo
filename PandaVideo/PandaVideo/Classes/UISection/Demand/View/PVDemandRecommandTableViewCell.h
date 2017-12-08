//
//  PVDemandRecommandTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/8/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVideoListModel.h"
#import "PVSearchResultModel.h"
#import "PVDemandSystemVideoModel.h"

@interface PVDemandRecommandTableViewCell : UITableViewCell


@property(nonatomic, assign)BOOL isSearch;

@property(nonatomic, strong)PVSearchVideoListModel*  searchVideoListModel;
@property(nonatomic, strong)PVVideoListModel* videoListModel;
@property(nonatomic, strong)PVDemandSystemVideoModel* systemVideoModel;
@property(nonatomic, assign)BOOL isHiddenView;


@end
