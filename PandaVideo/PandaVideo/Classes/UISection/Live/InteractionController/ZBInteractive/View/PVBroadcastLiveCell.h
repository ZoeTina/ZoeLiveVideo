//
//  PVBroadcastLiveCell.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/16.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVCurrentListModel.h"

@interface PVBroadcastLiveCell : UITableViewCell

@property (nonatomic, strong) PVRankingList *listDataModel;


- (void) setTagGradation:(NSInteger) idx;
@end
