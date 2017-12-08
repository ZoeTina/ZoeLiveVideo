//
//  PVOrderDetailViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVOrderDetailViewController.h"
#import "PVOrderDetailTableViewCell.h"
#import "PVOrderDetailModel.h"
#import "PVNoDataView.h"

static NSString* resuPVOrderDetailTableViewCell = @"resuPVOrderDetailTableViewCell";

@interface PVOrderDetailViewController () <UITableViewDataSource,UITableViewDelegate>

///设置tableview
@property(nonatomic, strong)UITableView* orderTableView;
@property (nonatomic, strong) PVNoDataView *noDataView;
///数据源
@property(nonatomic, strong)NSMutableArray* dataSource;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) PVOrderDetailListModel *orderListModel;
@end

@implementation PVOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageSize = kPageSize;
    [self setupUI];
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"我的订购";
    self.automaticallyAdjustsScrollViewInsets = false;
}
-(void)setupUI{
    self.view.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self.view insertSubview:self.orderTableView belowSubview:self.scNavigationBar];
    self.orderTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.orderTableView.mj_header beginRefreshing];
}

- (void)loadData {
    self.index = 1;
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    self.orderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.orderTableView.mj_footer.hidden = YES;
    
    NSDictionary *dict = @{@"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId,@"index":@(self.index),@"pageSize":@(self.pageSize)};
    [PVNetTool postDataHaveTokenWithParams:dict url:getOrderList success:^(id responseObject) {
        [self.orderTableView.mj_header endRefreshing];
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                self.orderListModel = [PVOrderDetailListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [self analysisData];
                
            }else {
                Toast([responseObject pv_objectForKey:@"errormsg"]);
    
            }
            
        }
    } failure:^(NSError *error) {
        Toast(@"获取数据失败");
        [self.orderTableView.mj_header endRefreshing];
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        [self.orderTableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData {
    PV(pv)
    self.index ++;
    
    NSDictionary *dict = @{@"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId,@"index":@(self.index),@"pageSize":@(self.pageSize)};
    [PVNetTool postDataHaveTokenWithParams:dict url:getOrderList success:^(id responseObject) {
        [self.orderTableView.mj_footer endRefreshing];
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                self.orderListModel = [PVOrderDetailListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [self analysisData];
                
            }else {
                Toast([responseObject pv_objectForKey:@"errormsg"]);
                
            }
            
        }
    } failure:^(NSError *error) {
        Toast(@"获取数据失败");
        [pv.orderTableView.mj_footer endRefreshing];
        self.index --;
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        Toast(@"获取数据失败");
        [pv.orderTableView.mj_footer endRefreshing];
        self.index --;
    }];

}

- (void)analysisData {
    for (PVOrderDetailModel *model in self.orderListModel.orderList) {
        [self.dataSource addObject:model];
    }
    if (self.orderListModel.orderList == 0) {
        self.noDataView.hidden = NO;
    }else {
        self.noDataView.hidden = YES;
        self.orderTableView.mj_footer.hidden = NO;
//        self.totalPage = ceilf(self.historyListModel.total / self.pageSize);
        [self.orderTableView reloadData];
    }
    if (self.orderListModel.orderList.count < kPageSize && self.dataSource.count > 0) {
        self.orderTableView.mj_footer.hidden = NO;
        [self.orderTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

/// MARK:- ========== UITableViewDelegate,UITableViewDataSource ========
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVOrderDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVOrderDetailTableViewCell forIndexPath:indexPath];
    cell.orderDetailModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}
///各种点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
// MARK:- ====================== 懒加载 ======================
-(UITableView *)orderTableView{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _orderTableView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0);
        _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderTableView.showsVerticalScrollIndicator = false;
        [_orderTableView registerNib:[UINib nibWithNibName:@"PVOrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVOrderDetailTableViewCell];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _orderTableView.sectionFooterHeight = 1.0;
        _orderTableView.sectionHeaderHeight = 1.0;
    }
    return _orderTableView;
}

- (PVNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[PVNoDataView alloc] initWithFrame:CGRectMake(0, 198, kScreenWidth, 200) ImageName:@"mine_img_norecord2" tipsLabelText:@"暂无电视观看历史"];
        [self.view insertSubview:_noDataView aboveSubview:self.orderTableView];
        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.height.mas_equalTo(200);
        }];
    }
    return _noDataView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
@end
