//
//  PVDemandStarTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/8/2.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PVDemandStarTableViewCellBlock)(NSInteger);


@interface PVDemandStarTableViewCell : UITableViewCell

-(void)setPVDemandStarTableViewCellBlock:(PVDemandStarTableViewCellBlock)block;

@end
