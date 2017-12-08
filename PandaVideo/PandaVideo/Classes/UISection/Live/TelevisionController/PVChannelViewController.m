//
//  PVChannelViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVChannelViewController.h"
#import "PVTimeTableViewCell.h"
#import "PVChannelTableViewCell.h"
#import "PVDBManager.h"
#import "PVNoProGramView.h"


static NSString* timeFomatter = @"YYYY-MM-dd";
static NSString* resuPVTimeTableViewCell = @"resuPVTimeTableViewCell";
static NSString* resuPVChannelTableViewCell = @"resuPVChannelTableViewCell";

@interface PVChannelViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, copy)PVChannelViewControllerCallBlock vcCallBlock;
@property(nonatomic, strong)PVLiveTelevisionAreaModel* recordAreaModel;
@property (nonatomic, strong)PVNoProGramView* noProGramView;


@end

@implementation PVChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.channelTableView];
    [self.view addSubview:self.channelDetailTableView];
    
    PV(pv)
    self.channelDetailTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [pv loadChannelProGram];
    }];
    
}

-(void)loadLocalCollectionData{
    NSArray* array = [[PVDBManager sharedInstance] selectLiveChannelAllData];
    //生成自己的model
    PVLiveTelevisionAreaModel* areaModel = [[PVLiveTelevisionAreaModel alloc]  init];
    areaModel.stationId = @"-11";
    areaModel.isSelected = false;
    areaModel.stationName = @"我的";
    [areaModel.chanelList addObjectsFromArray:array];
    
    [self.channelDataSource insertObject:areaModel atIndex:0];
}
-(void)setPVChannelViewControllerCallBlock:(PVChannelViewControllerCallBlock)block{
    self.vcCallBlock = block;
}


-(void)setUrl:(NSString *)url{
    _url = url;
    [PVNetTool getDataWithUrl:url success:^(id result) {
        if (result && [result isKindOfClass:[NSArray class]]) {
            NSArray* jsonArr = result;
            [self.channelDataSource removeAllObjects];
            [self loadLocalCollectionData];
            for (NSDictionary* jsonDict in jsonArr) {
                PVLiveTelevisionAreaModel* areaModel = [[PVLiveTelevisionAreaModel alloc]  init];
                [areaModel setValuesForKeysWithDictionary:jsonDict];
                [self.channelDataSource addObject:areaModel];
            }
            for (PVLiveTelevisionAreaModel* areaModel in self.channelDataSource) {
                if ([self.defaultChannelModel.stationId isEqualToString:areaModel.stationId]) {
                    self.selectedAreaModel = areaModel;
                    self.selectedAreaModel.isSelected = true;
                    self.selectedAreaModel.isRefresh = true;
                    break;
                }
            }
            [self.channelTableView reloadData];
            if (self.selectedAreaModel) {
                NSInteger index = [self.channelDataSource indexOfObject:self.selectedAreaModel];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.channelTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
            }
            [self loadChannelProGram];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"---error--- = %@",error);
    }];
}

-(void)loadChannelProGram{
    if (self.selectedAreaModel.chanelList.count == 0){
        [self.channelDetailTableView.mj_header endRefreshing];
        [self.channelDetailTableView reloadData];
        return;
    }
    NSMutableArray* pramas = [NSMutableArray arrayWithCapacity:self.selectedAreaModel.chanelList.count];
    for (PVLiveTelevisionChanelListModel* chanelListModel in self.selectedAreaModel.chanelList) {
        PVNetModel* netModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:chanelListModel.programDateUrl param:nil];
        [pramas addObject:netModel];
    }
    
    [PVNetTool getMoreDataWithParams:pramas success:^(id result) {
        if (result != nil) {
            for (int idx=0; idx<self.selectedAreaModel.chanelList.count; idx++) {
                NSString* resultKey = [NSString stringWithFormat:@"%d",idx];
                PVLiveTelevisionChanelListModel* chanelListModel = self.selectedAreaModel.chanelList[idx];
                if (result[resultKey] && [result[resultKey]  isKindOfClass:[NSArray class]]) {
                    NSMutableArray* tempResultArr = [NSMutableArray array];
                    for (NSDictionary* jsonDict in result[resultKey]) {
                        PVLiveTelevisionProGramModel* detailProGramModel = [[PVLiveTelevisionProGramModel alloc] init];
                        [detailProGramModel setValuesForKeysWithDictionary:jsonDict];
                        [tempResultArr addObject:detailProGramModel];
                        ///找出今天频道要请求的节目单
                        NSDate* todayDate = [NSDate PVDateStringToDate:detailProGramModel.date formatter:timeFomatter];
                        if ([todayDate isThisDay]) {
                            chanelListModel.nowProGramModel = detailProGramModel;
                        }
                    }
                    //对数组进行排序
                    NSArray* tempResult = [tempResultArr sortedArrayUsingComparator:^NSComparisonResult(PVLiveTelevisionProGramModel *obj1, PVLiveTelevisionProGramModel *obj2) {
                        return [obj2.date compare:obj1.date];
                    }];
                    [chanelListModel.programs addObjectsFromArray:tempResult];
                }
            }
            for (PVLiveTelevisionChanelListModel* chanelListModel  in self.selectedAreaModel.chanelList) {
                if (!self.selectedChanelListModel && [chanelListModel.channelId isEqualToString:self.defaultChannelModel.channelId]) {//现在切换电视台有默认选中,是因为各电视台有id相同
                    self.selectedChanelListModel = chanelListModel;
                    self.selectedChanelListModel.isSelected = true;
                    break;
                }else{
                    if ([self.selectedChanelListModel.channelName isEqualToString:chanelListModel.channelName]) {
                        self.selectedChanelListModel = chanelListModel;
                        self.selectedChanelListModel.isSelected = true;
                        break;
                    }
                }
            }
            [self loadPlayingProGram];
        }
        PVLog(@"---result --= %@",result);
    } failure:^(NSArray *errors) {
        [self.channelDetailTableView reloadData];
        [self.channelDetailTableView.mj_header endRefreshing];
        PVLog(@"---errors--- = %@",errors);
    }];
}

-(void)loadPlayingProGram{
    ///请求频道今天对应的节目单
    NSMutableArray* pramas = [NSMutableArray arrayWithCapacity:self.selectedAreaModel.chanelList.count];
    for (PVLiveTelevisionChanelListModel* chanelListModel in self.selectedAreaModel.chanelList) {
        PVNetModel* netModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:chanelListModel.nowProGramModel.programUrl param:nil];
        [pramas addObject:netModel];
    }
    [PVNetTool getMoreDataWithParams:pramas success:^(id result) {
        if (result != nil) {
            for (int idx=0; idx<self.selectedAreaModel.chanelList.count; idx++) {
                NSString* resultKey = [NSString stringWithFormat:@"%d",idx];
                PVLiveTelevisionChanelListModel* chanelListModel = self.selectedAreaModel.chanelList[idx];
                if (result[resultKey] && [result[resultKey]  isKindOfClass:[NSArray class]]) {
                    for (NSDictionary* jsonDict in result[resultKey]) {
                        PVLiveTelevisionDetailProGramModel*  detailProGramModel = [[PVLiveTelevisionDetailProGramModel alloc]  init];
                        [detailProGramModel setValuesForKeysWithDictionary:jsonDict];
                        [detailProGramModel calculationProgramTime:chanelListModel.nowProGramModel.date];
                        if (detailProGramModel.type == 3) {
                            chanelListModel.nowDetailProGramModel = detailProGramModel;
                        }
                        [chanelListModel.nowProGramModel.programs addObject:detailProGramModel];
                        if (chanelListModel.nowProGramModel.type == 1) {
                            [chanelListModel.nowProGramModel selectTodayProgramAppointMentStatus];
                        }
                    }
                }
            }
        }
        [self.channelDetailTableView reloadData];
        if (self.selectedChanelListModel) {
            NSInteger index = [self.selectedAreaModel.chanelList indexOfObject:self.selectedChanelListModel];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.channelDetailTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
        }
        [self.channelDetailTableView.mj_header endRefreshing];
//        PVLog(@"---result--= %@",result);
        
    } failure:^(NSArray *errors) {
        PVLog(@"---errors--- = %@",errors);
        [self.channelDetailTableView reloadData];
        [self.channelDetailTableView.mj_header endRefreshing];
    }];

}

-(void)setSelectedAreaModel:(PVLiveTelevisionAreaModel *)selectedAreaModel{
    _selectedAreaModel = selectedAreaModel;
    for (PVLiveTelevisionChanelListModel* chanelListModel in selectedAreaModel.chanelList) {
         BOOL flag =  [[PVDBManager sharedInstance]  selectChanelListModelIsCollect:chanelListModel];
        if (flag) {//收藏了
            chanelListModel.isCollect = true;
        }
    }
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.channelTableView.frame = CGRectMake(0, 0, 70, self.view.sc_height);
    self.channelDetailTableView.frame = CGRectMake(CGRectGetMaxX(self.channelTableView.frame), 0, ScreenWidth-CGRectGetMaxX(self.channelTableView.frame), self.view.sc_height);
    self.noProGramView.frame = CGRectMake(-5, -15, ScreenWidth-CGRectGetMaxX(self.channelTableView.frame), self.view.sc_height-kTabBarHeight);
}


/// MARK:- ======== UITableViewDataSource,UITableViewDelegate ==========

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.channelTableView) {
        return self.channelDataSource.count;
    }
    if ([self.selectedAreaModel.stationId isEqualToString:@"-11"]) {
        self.noProGramView.noDataLabel.text = @"暂无收藏频道";
    }else{
        self.noProGramView.noDataLabel.text = @"暂无频道";
    }
    self.noProGramView.hidden = self.selectedAreaModel.chanelList.count;
    return self.selectedAreaModel.chanelList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.channelTableView) {
        PVTimeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVTimeTableViewCell];
        
        cell.areaModel = self.channelDataSource[indexPath.row];
        
        return cell;
    }else{
        PVChannelTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVChannelTableViewCell];
        cell.isFisrt = indexPath.row;
        cell.chanelListModel = self.selectedAreaModel.chanelList[indexPath.row];
        PV(pv)
        [cell setPVChannelTableViewCellCallBlock:^(PVLiveTelevisionChanelListModel *chanelListModel) {
            chanelListModel.isCollect = !chanelListModel.isCollect;

            if (chanelListModel.isCollect) {
                [[PVDBManager sharedInstance]  insertLiveChannelModel:chanelListModel];
                chanelListModel.isCollect = true;
                WindowToast(@"收藏成功");
            }else{
                chanelListModel.isCollect = false;
                [[PVDBManager sharedInstance] deleteLiveChannelModel:chanelListModel];
                WindowToast(@"取消成功");
                if ([pv.selectedAreaModel.stationId isEqualToString:@"-11"]) {
                    [pv.selectedAreaModel.chanelList removeObject:chanelListModel];
                    for (PVLiveTelevisionAreaModel* areaModel in pv.channelDataSource) {
                        for (PVLiveTelevisionChanelListModel* tempChanelListModel in areaModel.chanelList) {
                            if ([tempChanelListModel.channelId isEqualToString:chanelListModel.channelId]) {
                                tempChanelListModel.isCollect = false;
                                break;
                            }
                        }
                    }
                }
            }
            [pv.channelDataSource removeObjectAtIndex:0];
            [pv loadLocalCollectionData];
            [pv.channelDetailTableView reloadData];
        }];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.channelTableView)return 60;
    return 71;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.channelTableView) {
        PVLiveTelevisionAreaModel* areaModel = self.channelDataSource[indexPath.row];
        if (areaModel.stationId == self.selectedAreaModel.stationId) return;
        self.selectedAreaModel.isSelected = false;
        self.selectedAreaModel = areaModel;
        self.selectedAreaModel.isSelected = true;
        [self.channelTableView reloadData];
        [self.channelTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
        PVLiveTelevisionChanelListModel* chanelListModel = self.selectedAreaModel.chanelList.firstObject;
        [self.channelDetailTableView reloadData];
        if (!chanelListModel.programs.count) {
            if ([self.selectedAreaModel.stationId isEqualToString:@"-11"]) {
                NSArray* array = [[PVDBManager sharedInstance]  selectLiveChannelAllData];
                if (array.count) {
                    [self loadChannelProGram];
                }
                [self.channelDetailTableView reloadData];
            }else{
                if (!self.selectedAreaModel.isRefresh) {
                    [self.channelDetailTableView.mj_header beginRefreshing];
                    self.selectedAreaModel.isRefresh = true;
                }
            }
        }
    }else{
        PVLiveTelevisionChanelListModel* chanelListModel = self.selectedAreaModel.chanelList[indexPath.row];
        if ([self.selectedChanelListModel.channelId isEqualToString:chanelListModel.channelId]) return;
        for (PVLiveTelevisionChanelListModel* tempChanelListModel in self.selectedAreaModel.chanelList) {
            tempChanelListModel.isSelected = false;
        }
        self.selectedChanelListModel.isSelected = false;
        self.selectedChanelListModel = chanelListModel;
        self.selectedChanelListModel.isSelected = true;
        [self.channelDetailTableView reloadData];
        [self.channelDetailTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
        ///回调给控制器
        if (self.vcCallBlock) {
            self.vcCallBlock(self.selectedChanelListModel);
        }        
    }
}
-(UITableView *)channelTableView{
    if (!_channelTableView) {
        _channelTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        CGFloat bottomHeight = kiPhoneX ? 82 : 49 ;
        _channelTableView.contentInset = UIEdgeInsetsMake(0, 0, bottomHeight, 0);
        _channelTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_channelTableView registerNib:[UINib nibWithNibName:@"PVTimeTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVTimeTableViewCell];
        _channelTableView.backgroundColor = [UIColor whiteColor];
        _channelTableView.dataSource = self;
        _channelTableView.delegate = self;
        _channelTableView.showsVerticalScrollIndicator = false;
        _channelTableView.showsVerticalScrollIndicator = false;
    }
    return _channelTableView;
}
-(NSMutableArray *)channelDataSource{
    if (!_channelDataSource) {
        _channelDataSource = [NSMutableArray array];
    }
    return _channelDataSource;
}
-(UITableView *)channelDetailTableView{
    if (!_channelDetailTableView) {
        _channelDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        CGFloat bottomHeight = kiPhoneX ? 89 : 55 ;
        _channelDetailTableView.contentInset = UIEdgeInsetsMake(-11, 0, bottomHeight, 0);
        _channelDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_channelDetailTableView registerNib:[UINib nibWithNibName:@"PVChannelTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVChannelTableViewCell];
        _channelDetailTableView.backgroundColor = [UIColor whiteColor];
        _channelDetailTableView.dataSource = self;
        _channelDetailTableView.delegate = self;
        _channelDetailTableView.showsVerticalScrollIndicator = false;
        _channelDetailTableView.showsVerticalScrollIndicator = false;
    }
    return _channelDetailTableView;
}
-(PVNoProGramView *)noProGramView{
    if (!_noProGramView) {
        _noProGramView = [[NSBundle mainBundle] loadNibNamed:@"PVNoProGramView" owner:nil options:0].lastObject;
        _noProGramView.noDataLabel.text = @"暂无频道";
        _noProGramView.noDataImageView.image = [UIImage imageNamed:@"mine_img_nolike"];
        [self.channelDetailTableView addSubview:_noProGramView];
    }
    return _noProGramView;
}

@end
