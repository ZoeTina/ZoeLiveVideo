//
//  PVDemandAnthologyTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/8/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PVDemandAnthologyTableViewCellCallBlock)(NSInteger index);



@interface PVDemandAnthologyTableViewCell : UITableViewCell

@property(nonatomic, strong)UICollectionView* videoTempletCollectView;
@property(nonatomic, assign)NSInteger type;
@property(nonatomic, strong)NSArray* anthologyDataSource;
@property(nonatomic, assign)BOOL isScroll;

-(void)setPVDemandAnthologyTableViewCellCallBlock:(PVDemandAnthologyTableViewCellCallBlock)block;

@end
