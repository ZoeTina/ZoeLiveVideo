//
//  PVDemandTableHeadView.h
//  PandaVideo
//
//  Created by cara on 17/8/2.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeadViewGestureBlock)();

@interface PVDemandTableHeadView : UITableViewHeaderFooterView


@property(nonatomic, assign)NSInteger type;
@property(nonatomic, assign)NSInteger count;

-(void)setHeadViewGestureBlock:(HeadViewGestureBlock)block;

@end
