//
//  PVProGramTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionProGramModel.h"

typedef void(^PVProGramTableViewCellCallBlock)(void);


@interface PVProGramTableViewCell : UITableViewCell

@property(nonatomic, assign)BOOL isLast;
@property(nonatomic, strong)PVLiveTelevisionDetailProGramModel* detailProGramModel;



-(void)setPVProGramTableViewCellCallBlock:(PVProGramTableViewCellCallBlock)block;

@end
