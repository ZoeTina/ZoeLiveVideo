//
//  PVVideoChannelViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoChannelViewController.h"
#import "PVVideoLiveTimeTableViewCell.h"
#import "PVVideoLiveChaanelCell.h"
#import "PVDBManager.h"

static NSString* timeFomatter = @"YYYY-MM-dd";
static NSString* resuPVVideoLiveTimeTableViewCell = @"resuPVVideoLiveTimeTableViewCell";
static NSString* resuPVVideoLiveChaanelCell = @"resuPVVideoLiveChaanelCell";

@interface PVVideoChannelViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, copy)PVVideoChannelViewControllerCallBlock callBlock;

@end

@implementation PVVideoChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.timeTableView];
    [self.timeTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.view);
        make.width.equalTo(@(60));
    }];
    
    UIView* bottomView = [[UIView alloc]  init];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.9f;
    [self.view addSubview:bottomView];
    
    [bottomView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.bottom.right.equalTo(self.view);
        make.left.equalTo(self.timeTableView.mas_right);
    }];
    
    [self.view addSubview:self.proGramTableView];
    [self.proGramTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.view);
        make.left.equalTo(self.timeTableView.mas_right);
    }];
}


-(void)setPVVideoChannelViewControllerCallBlock:(PVVideoChannelViewControllerCallBlock)block{
    self.callBlock = block;
}

/// MARK:- ===== UITableViewDataSource,UITableViewDelegate ======
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.timeTableView) {
        return self.timeDataSource.count;
    }else{
        return self.selectedAreaModel.chanelList.count;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.timeTableView) {
        PVVideoLiveTimeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVVideoLiveTimeTableViewCell];
        cell.areaModel = self.timeDataSource[indexPath.row];
        return cell;
    }else{
        PVVideoLiveChaanelCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVVideoLiveChaanelCell];
        cell.chanelListModel = self.selectedAreaModel.chanelList[indexPath.row];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.timeTableView) {
        return 60;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.timeTableView) {
        PVLiveTelevisionAreaModel* areaModel = self.timeDataSource[indexPath.row];
        if (areaModel == self.selectedAreaModel) return;
        for (PVLiveTelevisionAreaModel* tempAreaModel in self.timeDataSource) {
            tempAreaModel.isSelected = false;
        }
        self.selectedAreaModel = areaModel;
        self.selectedAreaModel.isSelected = true;
        [self.timeTableView reloadData];
        [self.timeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
        PVLiveTelevisionChanelListModel* chanelListModel = self.selectedAreaModel.chanelList.firstObject;
        if (chanelListModel.programs.count) {
            [self.proGramTableView reloadData];
        }else{
            if ([self.selectedAreaModel.stationId isEqualToString:@"-11"]) {
                NSArray* array = [[PVDBManager sharedInstance]  selectLiveChannelAllData];
                if (array.count) {
                    [self loadChannelProGram];
                }
                [self.proGramTableView reloadData];
            }else{
                [self loadChannelProGram];
            }
        }
    }else{
        PVLiveTelevisionChanelListModel* chanelListModel = self.selectedAreaModel.chanelList[indexPath.row];
        if ([self.selectedChanelListModel.channelId isEqualToString:chanelListModel.channelId]) return;
        self.selectedChanelListModel.isSelected = false;
        for (PVLiveTelevisionChanelListModel* tempChanelListModel in self.selectedAreaModel.chanelList) {
            tempChanelListModel.isSelected = false;
        }
        self.selectedChanelListModel = chanelListModel;
        self.selectedChanelListModel.isSelected = true;
        [self.proGramTableView reloadData];
        [self.proGramTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
        ///回调给控制器
        if (self.callBlock) {
            self.callBlock(self.defaultChannelModel,self.selectedAreaModel,self.selectedChanelListModel);
        }
    }
}

-(void)loadChannelProGram{
    if (self.selectedAreaModel.chanelList.count == 0)return;
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
                if ([chanelListModel.channelId isEqualToString:self.defaultChannelModel.channelId]) {//现在切换电视台有默认选中,是因为各电视台有id相同
                    self.selectedChanelListModel = chanelListModel;
                    self.selectedChanelListModel.isSelected = true;
                    break;
                }
            }
            [self loadPlayingProGram];
        }
       // PVLog(@"---result --= %@",result);
    } failure:^(NSArray *errors) {
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
                    }
                }
            }
            [self.proGramTableView reloadData];
            if (self.selectedChanelListModel) {
                NSInteger index = [self.selectedAreaModel.chanelList indexOfObject:self.selectedChanelListModel];
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                [self.proGramTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:false];
            }
        }
       // PVLog(@"---result --= %@",result);
    } failure:^(NSArray *errors) {
        PVLog(@"---errors--- = %@",errors);
    }];
}
-(UITableView *)timeTableView{
    if (!_timeTableView) {
        _timeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _timeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_timeTableView registerClass:[PVVideoLiveTimeTableViewCell class] forCellReuseIdentifier:resuPVVideoLiveTimeTableViewCell];
        _timeTableView.backgroundColor = [UIColor blackColor];
        _timeTableView.dataSource = self;
        _timeTableView.delegate = self;
        _timeTableView.showsVerticalScrollIndicator = false;
        _timeTableView.showsVerticalScrollIndicator = false;
        _timeTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    }
    return _timeTableView;
}
-(NSMutableArray *)timeDataSource{
    if (!_timeDataSource) {
        _timeDataSource = [NSMutableArray array];
    }
    return _timeDataSource;
}
-(UITableView *)proGramTableView{
    if (!_proGramTableView) {
        _proGramTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _proGramTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _proGramTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_proGramTableView registerNib:[UINib nibWithNibName:@"PVVideoLiveChaanelCell" bundle:nil] forCellReuseIdentifier:resuPVVideoLiveChaanelCell];
        _proGramTableView.dataSource = self;
        _proGramTableView.delegate = self;
        _proGramTableView.backgroundColor = [UIColor clearColor];
        _proGramTableView.showsVerticalScrollIndicator = false;
        _proGramTableView.showsVerticalScrollIndicator = false;
    }
    return _proGramTableView;
}
@end
