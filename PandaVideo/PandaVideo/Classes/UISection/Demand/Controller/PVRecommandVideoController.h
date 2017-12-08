//
//  PVRecommandVideoController.h
//  PandaVideo
//
//  Created by cara on 17/8/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVVideoListModel.h"
#import "PVDemandSystemVideoModel.h"

typedef void(^PVRecommandVideoControllerCallBlock)(PVVideoListModel* videoListModel,PVDemandSystemVideoModel* systemVideoModel, NSInteger type);


@interface PVRecommandVideoController : UIViewController

//1:小便推荐, 2:系统推荐
@property(nonatomic, assign)NSInteger type;
@property (weak, nonatomic) IBOutlet UITableView *recommandTableView;
@property(nonatomic, strong)NSMutableArray* dataSource;

-(void)setPVRecommandVideoControllerCallBlock:(PVRecommandVideoControllerCallBlock)block;

@end
