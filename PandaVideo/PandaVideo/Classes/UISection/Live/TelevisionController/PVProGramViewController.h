//
//  PVProGramViewController.h
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionProGramModel.h"
#import "PVLiveTelevisionChanelListModel.h"

typedef void(^PVPlayProGramCallBlock)(PVLiveTelevisionDetailProGramModel* defaultDetailProGramModel);

@interface PVProGramViewController : UIViewController

@property(nonatomic, copy)NSString* url;

@property(nonatomic, strong)NSMutableArray* timeDataSource;
///需要显示的时间表
@property(nonatomic, strong)NSMutableArray* disPlayDataSource;
@property(nonatomic, strong)PVLiveTelevisionProGramModel*defaultProGramModel;
///默认播放那一个节目单
@property(nonatomic, strong)PVLiveTelevisionDetailProGramModel* defaultDetailProGramModel;
///左边时间
@property(nonatomic, strong)UITableView* timeTableView;
///右边节目单
@property(nonatomic, strong)UITableView* proGramTableView;
///清晰度开始时间
@property(nonatomic, assign)NSTimeInterval difinationStartTime;
///默认选择节目单id
@property(nonatomic, strong)PVLiveTelevisionBackProgramInfoModel*  backProgramInfoModel;
@property(nonatomic, copy)NSString* backProgramUrl;

///处理8天只显示7天的节目单
-(void)setDisplayTime;

///处理视频播放
-(void)setPVPlayProGramCallBlock:(PVPlayProGramCallBlock)block;

@end
