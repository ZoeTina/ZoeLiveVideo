//
//  PVVideoProgramViewController.h
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionProGramModel.h"

typedef void(^PVVideoProgramViewControllerCallBlock)(PVLiveTelevisionProGramModel*defaultProGramModel,PVLiveTelevisionDetailProGramModel* defaultDetailProGramModel);

typedef void(^PVVideoProgramViewControllerRealDataCallBlock)();


@interface PVVideoProgramViewController : UIViewController

///默认播放时间
@property(nonatomic, strong)PVLiveTelevisionProGramModel*defaultProGramModel;
///默认播放那一个节目单
@property(nonatomic, strong)PVLiveTelevisionDetailProGramModel* defaultDetailProGramModel;

@property(nonatomic, strong)UITableView* timeTableView;
///右边节目单
@property(nonatomic, strong)UITableView* proGramTableView;
///左边时间
@property(nonatomic, strong)NSMutableArray* timeDataSource;


-(void)setPVVideoProgramViewControllerCallBlock:(PVVideoProgramViewControllerCallBlock)block;
-(void)setPVVideoProgramViewControllerRealDataCallBlock:(PVVideoProgramViewControllerRealDataCallBlock)block;

@end
