//
//  PVTeleversionDetailController.m
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTeleversionDetailController.h"
#import "PVRecordTableViewCell.h"
#import "PVTelevisionHistoryModel.h"

static NSString* resuPVRecordTableViewCell = @"resuPVRecordTableViewCell";

@interface PVTeleversionDetailController ()  <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UITableView* recordTableView;
@property(nonatomic, strong)NSMutableArray* dataSource;

@property (nonatomic, strong) PVNoDataView *noDataView;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) PVTelevisionListHistoryModel *historyListModel;
@end

@implementation PVTeleversionDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scNavigationItem.title = @"电视观看记录";
    [self setupUI];

}

-(void)setupUI{
    [self.view addSubview:self.recordTableView];
    self.recordTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.recordTableView.mj_header beginRefreshing];
    
}

- (void)loadData {
    
    self.pageSize = kPageSize;
    self.index = 1;
    
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    self.recordTableView.mj_footer = self.recordTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.recordTableView.mj_footer.hidden = YES;
    
    NSDictionary *dict = @{@"token":[PVUserModel shared].token,@"userId":[PVUserModel shared].userId,@"channelId":huangChannelId,@"pageSize":@(self.pageSize),@"index":@(self.index)};
    [PVNetTool postDataHaveTokenWithParams:dict url:getTVHistoryList success:^(id responseObject) {
        [self.recordTableView.mj_header endRefreshing];
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                self.historyListModel = [PVTelevisionListHistoryModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [self analysisHistoryData];
            }else {
                Toast(@"电视观看历史记录获取失败");
            }
            
        }
    } failure:^(NSError *error) {
        if (error) {
            [self.recordTableView.mj_header endRefreshing];
            Toast(@"获取电视端观看历史记录失败");
        }
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        
    }];
    [self.recordTableView.mj_header endRefreshing];
}

- (void)loadMoreData {
    self.index ++;
    if (self.index > self.totalPage) {
        [self.recordTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSDictionary *dict = @{@"token":[PVUserModel shared].token,@"userId":[PVUserModel shared].userId,@"channelId":huangChannelId,@"pageSize":@(self.pageSize),@"index":@(self.index)};
    [PVNetTool postDataHaveTokenWithParams:dict url:getTVHistoryList success:^(id responseObject) {
        [self.recordTableView.mj_footer endRefreshing];
        
        if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
            self.historyListModel = [PVTelevisionListHistoryModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
            [self analysisHistoryData];
        }
    } failure:^(NSError *error) {
        [self.recordTableView.mj_footer endRefreshing];
        Toast(@"电视观看历史记录数据获取失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        
    }];
}

- (void)analysisHistoryData {
    
    for (PVTelevisionHistoryModel *historyModel in self.historyListModel.historyList) {
        [self.dataSource addObject:historyModel];
    }
    
    if (self.historyListModel.total == 0) {
        self.noDataView.hidden = NO;
    }else {
        if (self.historyListModel.historyList.count < kPageSize) {
            [self.recordTableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.noDataView.hidden = YES;
        self.recordTableView.mj_footer.hidden = NO;
        self.totalPage = ceilf(self.historyListModel.total / self.pageSize);
        [self.recordTableView reloadData];
    }
}


/// MARK:- ====== UITableViewDelegate,UITableViewDataSource ==========

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVRecordTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVRecordTableViewCell forIndexPath:indexPath];
    cell.isShow = false;
    cell.isTeleversionHistory = true;
    cell.teleHistoryModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return IPHONE6WH(73);
    return 73;
}
///各种点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


-(UITableView *)recordTableView{
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
        _recordTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_recordTableView registerNib:[UINib nibWithNibName:@"PVRecordTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVRecordTableViewCell];
        _recordTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _recordTableView.dataSource = self;
        _recordTableView.delegate = self;
        _recordTableView.showsVerticalScrollIndicator = false;
        _recordTableView.showsVerticalScrollIndicator = false;
        
    }
    return _recordTableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (PVNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[PVNoDataView alloc] initWithFrame:CGRectMake(0, 198, kScreenWidth, 200) ImageName:@"mine_img_norecord2" tipsLabelText:@"暂无电视观看历史"];
        [self.view insertSubview:_noDataView aboveSubview:self.recordTableView];
        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.height.mas_equalTo(200);
        }];
    }
    return _noDataView;
}
@end
