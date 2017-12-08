//
//  PVSearchResultNumber.h
//  PandaVideo
//
//  Created by cara on 17/8/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVSearchResultModel.h"


typedef void(^PVSearchResultNumberBlock)(NSInteger index);


@interface PVSearchResultNumber : UITableViewCell


@property(nonatomic, strong)NSArray* dataSource;

-(void)setPVSearchResultNumberBlock:(PVSearchResultNumberBlock)block;

@end
