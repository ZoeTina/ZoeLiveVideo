//
//  PVDemandImagesCell.h
//  PandaVideo
//
//  Created by cara on 2017/10/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PVDemandImagesCellCallBlock)(NSInteger index);


@interface PVDemandImagesCell : UITableViewCell

@property(nonatomic, strong)NSArray* urlsArray;

-(void)setPVDemandImagesCellCallBlock:(PVDemandImagesCellCallBlock)block;

@end
