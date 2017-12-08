//
//  PVProGramViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVProGramViewController.h"
#import "PVTimeTableViewCell.h"
#import "PVProGramTableViewCell.h"
#import "PVNoProGramView.h"


static NSString* resuPVTimeTableViewCell = @"resuPVTimeTableViewCell";
static NSString* resuPVProGramTableViewCell = @"resuPVProGramTableViewCell";

@interface PVProGramViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, copy)PVPlayProGramCallBlock callBlock;
@property(nonatomic, assign)NSInteger loadStatus;
@property (nonatomic, strong)PVNoProGramView* noProGramView;

@end

@implementation PVProGramViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.loadStatus = 0;
    [self setupUI];
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.timeTableView];
    [self.view addSubview:self.proGramTableView];
    
    PV(pv)
    self.proGramTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [pv loadloadDefaultProGram];
    }];
    
}
-(void)setPVPlayProGramCallBlock:(PVPlayProGramCallBlock)block{
    self.callBlock = block;
}

-(void)setUrl:(NSString *)url{
    _url = url;
    [self loadDefaultChannel];
}

-(void)loadDefaultChannel{
    [PVNetTool getDataWithUrl:self.url success:^(id result) {
        if (result && [result isKindOfClass:[NSArray class]]) {
            [self.timeDataSource removeAllObjects];
            for (NSDictionary* dict in result) {
                PVLiveTelevisionProGramModel* proGramModel = [[PVLiveTelevisionProGramModel alloc]  init];
                [proGramModel setValuesForKeysWithDictionary:dict];
                [self.timeDataSource addObject:proGramModel];
            }
            
            for (PVLiveTelevisionProGramModel* proGramModel in self.timeDataSource) {
                NSString* yearStr = [proGramModel.date stringByReplacingOccurrencesOfString:@"-" withString:@""];

                if (self.defaultProGramModel && [[self.defaultProGramModel.date stringByReplacingOccurrencesOfString:@"-" withString:@""] isEqual:yearStr]){
                    self.defaultProGramModel = proGramModel;
                    self.defaultProGramModel.isSelected = true;
                    self.defaultProGramModel.isRefresh = true;
                    break;
                }
            }
            if (!self.defaultProGramModel) {
                for (PVLiveTelevisionProGramModel* proGramModel in self.timeDataSource) {
                    if (proGramModel.type == 1){
                        self.defaultProGramModel = proGramModel;
                        self.defaultProGramModel.isSelected = true;
                        self.defaultProGramModel.isRefresh = true;
                        break;
                    }
                }
            }
        }
        //对数组进行排序
        NSArray* tempResult = [self.timeDataSource sortedArrayUsingComparator:^NSComparisonResult(PVLiveTelevisionProGramModel *obj1, PVLiveTelevisionProGramModel *obj2) {
            return [obj2.date compare:obj1.date];
        }];
        
        [self.timeDataSource removeAllObjects];
        [self.timeDataSource addObjectsFromArray:tempResult];
        [self setDisplayTime];
        [self.timeTableView reloadData];
        if (self.defaultProGramModel) {
            NSInteger index = [self.disPlayDataSource indexOfObject:self.defaultProGramModel];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.timeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
        }
        ///发送请求播放默认当天的节目单
        [self loadloadDefaultProGram];
    } failure:^(NSError *error) {
        NSLog(@"---error----=%@-",error);
    }];
}

///处理8天只显示7天的节目单
-(void)setDisplayTime{
    [self.disPlayDataSource removeAllObjects];
    for (PVLiveTelevisionProGramModel* proGramModel  in self.timeDataSource) {
        if (proGramModel.type != 3) {
            [self.disPlayDataSource addObject:proGramModel];
        }
    }
}
-(void)loadloadDefaultProGram{
    [PVNetTool getDataWithUrl:self.defaultProGramModel.programUrl success:^(id result) {
        [self.proGramTableView.mj_header endRefreshing];
        if (result && [result isKindOfClass:[NSArray class]]) {
            [self.defaultProGramModel.programs removeAllObjects];
            for (NSDictionary* jsonDict in result) {
                PVLiveTelevisionDetailProGramModel* detailProGramModel = [[PVLiveTelevisionDetailProGramModel alloc]  init];
                [detailProGramModel setValuesForKeysWithDictionary:jsonDict];
                [self.defaultProGramModel.programs addObject:detailProGramModel];

                if (self.defaultProGramModel.type == 1) {
                    [detailProGramModel calculationProgramTime:self.defaultProGramModel.date];
                }else{//那么就全是回看
                    detailProGramModel.type = 1;
                }
                
                if(self.defaultProGramModel.type == 1){
                    [self.defaultProGramModel selectTodayProgramAppointMentStatus];
                }
                
                if (!self.defaultDetailProGramModel && detailProGramModel.isPlaying) {
                    detailProGramModel.type = 2;
                    self.defaultDetailProGramModel = detailProGramModel;
                }else{
                    if ([self.defaultDetailProGramModel.programId isEqualToString:detailProGramModel.programId]) {
                        detailProGramModel.type = 2;
                        self.defaultDetailProGramModel = detailProGramModel;
                    }
                }
               
            }
            [self.proGramTableView reloadData];
            if (self.defaultDetailProGramModel) {
                NSInteger index = [self.defaultProGramModel.programs indexOfObject:self.defaultDetailProGramModel];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.proGramTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
            }
        }
    } failure:^(NSError *error) {
        [self.proGramTableView.mj_header endRefreshing];
        NSLog(@"---error----=%@-",error);
    }];
}



-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.timeTableView.frame = CGRectMake(0, 0, 70, self.view.sc_height);
    self.proGramTableView.frame = CGRectMake(CGRectGetMaxX(self.timeTableView.frame), 0, ScreenWidth-CGRectGetMaxX(self.timeTableView.frame), self.view.sc_height);
    self.noProGramView.frame = CGRectMake(-5, -15, ScreenWidth-CGRectGetMaxX(self.timeTableView.frame), self.view.sc_height-kTabBarHeight);
}

/// MARK:- ====================== UITableViewDataSource,UITableViewDelegate ======================

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.timeTableView) {
        return self.disPlayDataSource.count;
    }else{
        self.noProGramView.hidden = self.defaultProGramModel.programs.count;
        return self.defaultProGramModel.programs.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.timeTableView) {
        PVTimeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVTimeTableViewCell];
        PVLiveTelevisionProGramModel* proGramModel = self.disPlayDataSource[indexPath.row];
        cell.proGramModel = proGramModel;
        return cell;
    }else{
        PVProGramTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVProGramTableViewCell];
        if (indexPath.row == (self.defaultProGramModel.programs.count - 1)) {
            cell.isLast = true;
        }else{
            cell.isLast = false;
        }
        
        if (self.defaultProGramModel.programs.count) {
           __block PVLiveTelevisionDetailProGramModel* detailProGramModel = self.defaultProGramModel.programs[indexPath.row];;
            cell.detailProGramModel = detailProGramModel;
            [cell setPVProGramTableViewCellCallBlock:^{
                if (detailProGramModel.appointMentStatus.integerValue == 1) {//取消预约
                    detailProGramModel.appointMentStatus = @"2";
                    [detailProGramModel cancelLocalNotificationWithKey:detailProGramModel.programId];
                }else{//预约
                    detailProGramModel.appointMentStatus = @"1";
                    [detailProGramModel sureLocalNotification];
                }
                [[PVDBManager sharedInstance] updateLiveChannelProgramModel:detailProGramModel];
                [tableView reloadData];
            }];
        }
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.timeTableView) return 60;    
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.timeTableView) {
        PVLiveTelevisionProGramModel* proGramModel = self.disPlayDataSource[indexPath.row];
        if ([proGramModel.date isEqualToString:self.defaultProGramModel.date]) return;
//        if (proGramModel == self.defaultProGramModel) return;
        for (PVLiveTelevisionProGramModel*  model in self.disPlayDataSource) {
            model.isSelected = false;
        }
        self.defaultProGramModel.isSelected = false;
        self.defaultProGramModel = proGramModel;
        self.defaultProGramModel.isSelected = true;
        
        [self.timeTableView reloadData];
        [self.timeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
        [self.proGramTableView reloadData];
        if (proGramModel.programs.count) {
            [self loadloadDefaultProGram];
        }else{
            if (!proGramModel.isRefresh) {
                proGramModel.isRefresh = true;
                [self.proGramTableView.mj_header beginRefreshing];
            }

        }
    }else{
        ///点击了节目单信息
        PVLiveTelevisionDetailProGramModel* detailProGramModel = self.defaultProGramModel.programs[indexPath.row];
        if (self.defaultDetailProGramModel == detailProGramModel || detailProGramModel.type == 4) {
            return;
        }
        if (self.defaultDetailProGramModel.isPlaying ) {
            self.defaultDetailProGramModel.type = 3;
        }else{
            self.defaultDetailProGramModel.type = 1;
        }
        self.defaultDetailProGramModel = detailProGramModel;
        [self.defaultDetailProGramModel calculationProgramTime:self.defaultProGramModel.date];
        [self.proGramTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
        if (self.callBlock) {
            self.callBlock(self.defaultDetailProGramModel);
        }
    }
    
}
-(UITableView *)timeTableView{
    if (!_timeTableView) {
        _timeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        CGFloat bottomHeight = kiPhoneX ? 82 : 49 ;
        _timeTableView.contentInset = UIEdgeInsetsMake(0, 0, bottomHeight, 0);
        _timeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_timeTableView registerNib:[UINib nibWithNibName:@"PVTimeTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVTimeTableViewCell];
        _timeTableView.backgroundColor = [UIColor whiteColor];
        _timeTableView.dataSource = self;
        _timeTableView.delegate = self;
        _timeTableView.showsVerticalScrollIndicator = false;
        _timeTableView.showsVerticalScrollIndicator = false;
    }
    return _timeTableView;
}
-(NSMutableArray *)timeDataSource{
    if (!_timeDataSource) {
        _timeDataSource = [NSMutableArray array];
    }
    return _timeDataSource;
}
-(NSMutableArray *)disPlayDataSource{
    if (!_disPlayDataSource) {
        _disPlayDataSource = [NSMutableArray array];
    }
    return _disPlayDataSource;
}
-(UITableView *)proGramTableView{
    if (!_proGramTableView) {
        _proGramTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        CGFloat bottomHeight = kiPhoneX ? 64 : 30 ;
        _proGramTableView.contentInset = UIEdgeInsetsMake(10, 0, bottomHeight, 0);
        _proGramTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_proGramTableView registerNib:[UINib nibWithNibName:@"PVProGramTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVProGramTableViewCell];
        _proGramTableView.dataSource = self;
        _proGramTableView.delegate = self;
        _proGramTableView.backgroundColor = [UIColor whiteColor];
        _proGramTableView.showsVerticalScrollIndicator = false;
        _proGramTableView.showsVerticalScrollIndicator = false;
    }
    return _proGramTableView;
}

-(PVNoProGramView *)noProGramView{
    if (!_noProGramView) {
        _noProGramView = [[NSBundle mainBundle] loadNibNamed:@"PVNoProGramView" owner:nil options:0].lastObject;
        _noProGramView.noDataLabel.text = @"暂无节目单";
        [self.proGramTableView addSubview:_noProGramView];
    }
    return _noProGramView;
}


@end
