//
//  PVDemandTableFootView.h
//  PandaVideo
//
//  Created by cara on 17/8/2.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PVDemandTableFootViewBlock)();


@interface PVDemandTableFootView : UITableViewHeaderFooterView


@property(nonatomic, assign)NSInteger type;

-(void)setPVDemandTableFootViewBlock:(PVDemandTableFootViewBlock)block;


@end
