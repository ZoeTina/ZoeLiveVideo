//
//  PVVideoLiveTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionProGramModel.h"
typedef void(^PVProGramTableViewCellCallBlock)(void);



@interface PVVideoLiveTableViewCell : UITableViewCell

@property(nonatomic, strong)PVLiveTelevisionDetailProGramModel* detailProGramModel;

-(void)setPVProGramTableViewCellCallBlock:(PVProGramTableViewCellCallBlock)block;

@end
