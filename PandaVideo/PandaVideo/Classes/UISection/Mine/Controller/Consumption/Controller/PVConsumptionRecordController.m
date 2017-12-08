//
//  PVConsumptionRecordController.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVConsumptionRecordController.h"
#import "PVConsumptionRecordTableViewCell.h"
#import "PVConsumptionModel.h"

static NSString *CellIdentifier = @"PVConsumptionRecordTableViewCell";
@interface PVConsumptionRecordController ()<UITableViewDelegate,UITableViewDataSource>

/** 设置tableview */
@property (nonatomic, strong) UITableView *lzTableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *itemModelArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) PVConsumptionListModel *consumpListModel;
@property (nonatomic, strong) PVNoDataView *nodataView;
@end

@implementation PVConsumptionRecordController

- (NSMutableArray *) itemModelArray{
    if (_itemModelArray == nil) {
        _itemModelArray = [[NSMutableArray alloc] init];
    }
    return _itemModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSize = kPageSize;
    
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view insertSubview:self.lzTableView belowSubview:self.scNavigationBar];
    
    self.lzTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.lzTableView.mj_header beginRefreshing];
}

- (void)loadData {
    
    if (self.itemModelArray.count > 0) {
        [self.itemModelArray removeAllObjects];
    }
    
    self.index = 0;
    self.lzTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.lzTableView.mj_footer.hidden = YES;
    
    NSDictionary *dict = @{@"index":@(self.index),@"pageSize":@(self.pageSize),@"platform":@(iOSPlatform),@"token":[PVUserModel shared].token,@"userId":[PVUserModel shared].userId};
    [PVNetTool postDataHaveTokenWithParams:dict url:getConsumeList success:^(id responseObject) {
        [self.lzTableView.mj_header endRefreshing];
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                self.consumpListModel = [PVConsumptionListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [self analysisConsumptionDataWithisHeader:YES];
                
            }
        }
    } failure:^(NSError *error) {
        if (error) {
            [self.lzTableView.mj_header endRefreshing];
        }
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
    [self.lzTableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    self.index += kPageSize;
    NSDictionary *dict = @{@"index":@(self.index),@"pageSize":@(self.pageSize),@"platform":@(iOSPlatform),@"token":[PVUserModel shared].token,@"userId":[PVUserModel shared].userId};
    [PVNetTool postDataHaveTokenWithParams:dict url:getConsumeList success:^(id responseObject) {
        [self.lzTableView.mj_footer endRefreshing];
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                self.consumpListModel = [PVConsumptionListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [self analysisConsumptionDataWithisHeader:NO];
            }
        }
    } failure:^(NSError *error) {
        if (error) {
            self.index -= self.pageSize;
            [self.lzTableView.mj_footer endRefreshing];
        }
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        self.index -= self.pageSize;
        [self.lzTableView.mj_footer endRefreshing];
    }];
}

- (void)analysisConsumptionDataWithisHeader:(BOOL)isHeader {
    for (PVConsumptionModel *consumptionModel in self.consumpListModel.consumeList) {
        [self.itemModelArray addObject:consumptionModel];
    }
    if (self.itemModelArray.count == 0) {
        self.nodataView.hidden = NO;
        self.lzTableView.mj_footer.hidden = YES;
    }else {
        self.lzTableView.mj_footer.hidden = NO;
        self.nodataView.hidden = YES;
        [self.lzTableView reloadData];
    }
    if (self.consumpListModel.consumeList.count < kPageSize) {
        if (self.itemModelArray.count > 0) {
            self.lzTableView.mj_footer.hidden = NO;
            [self.lzTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVConsumptionRecordTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.consumpModel = [self.itemModelArray sc_safeObjectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _itemModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AUTOLAYOUTSIZE(50);
}

/// MARK:- ====================== 懒加载 ======================
-(UITableView *)lzTableView{
    if (!_lzTableView) {
        
        _lzTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
        _lzTableView.showsVerticalScrollIndicator = false;
        [_lzTableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil]
             forCellReuseIdentifier:CellIdentifier];
        [_lzTableView setSeparatorInset:UIEdgeInsetsMake(13,0,0,0)];
        _lzTableView.delegate = self;
        _lzTableView.dataSource = self;
        _lzTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _lzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _lzTableView;
}

- (PVNoDataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[PVNoDataView alloc] initWithFrame:CGRectMake(0, 198, kScreenWidth, 200) ImageName:@"mine_img_norecord1" tipsLabelText:@"暂无消费记录"];
        [self.view insertSubview:_nodataView aboveSubview:self.lzTableView];
    }
    return _nodataView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
