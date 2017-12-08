//
//  PVRechargeRecordController.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRechargeRecordController.h"
#import "PVRechargeRecordTableViewCell.h"
#import "PVRechargeDetailModel.h"

static NSString *CellIdentifier = @"PVRechargeRecordTableViewCell";
@interface PVRechargeRecordController ()<UITableViewDelegate,UITableViewDataSource>

/** 设置tableview */
@property (nonatomic, strong) UITableView *lzTableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *itemModelArray;
@property (nonatomic, strong) PVRechargeDetailListModel *rechargeListModel;
@property (nonatomic, assign) NSInteger index; //当前条数
@property (nonatomic, assign) NSInteger totalPage;   //总页数
@property (nonatomic, assign) NSInteger pageSize;    //每页数量
@property (nonatomic, strong) PVNoDataView *nodataView;
@end

@implementation PVRechargeRecordController


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
    PV(PV);
    self.index = 1;
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        [PV.lzTableView.mj_header endRefreshing];
        return;
    }
    
    if (self.itemModelArray.count > 0) {
        [self.itemModelArray removeAllObjects];
    }
    self.lzTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.lzTableView.mj_footer.hidden = YES;
    
    NSDictionary *dict = @{@"index":@(self.index),@"pageSize":@(self.pageSize),@"token":huangToken,@"userId":huangUserId, @"platform":@(iOSPlatform)};
    
    [PVNetTool postDataHaveTokenWithParams:dict url:getRechargeList success:^(id responseObject) {
        
        [PV.lzTableView.mj_header endRefreshing];
        
        if (responseObject) {
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:getMobileHistory];
            if (errorMsg.length > 0) {
                Toast(errorMsg);
            }else {
                PV.rechargeListModel = [PVRechargeDetailListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [PV analysisRechargeListModelWithHeader:YES];
            
            }
        }
    } failure:^(NSError *error) {
        [PV.lzTableView.mj_header endRefreshing];
        Toast(@"获取充值记录失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        [PV.lzTableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData {
    PV(PV);
    self.index += self.pageSize;

        NSDictionary *dict = @{@"index":@(self.index),@"pageSize":@(self.pageSize),@"token":huangToken,@"userId":huangUserId,@"platform":@(iOSPlatform)};
        [PVNetTool postDataHaveTokenWithParams:dict url:getFavList success:^(id responseObject) {
            [PV.lzTableView.mj_footer endRefreshing];
            if (responseObject) {
                NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:getMobileHistory];
                if (errorMsg.length > 0) {
                    Toast(errorMsg);
                }else {
                    PV.rechargeListModel = [PVRechargeDetailListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                    if (PV.rechargeListModel.rechargeList.count > 0) {
                        PV.lzTableView.mj_footer.hidden = NO;
                    }
                    [PV analysisRechargeListModelWithHeader:NO];
                }
            }
        } failure:^(NSError *error) {
            [PV.lzTableView.mj_footer endRefreshing];
            self.index -= self.pageSize;
        } tokenErrorInfo:^(NSString *tokenErrorInfo) {
            self.index -= self.pageSize;
        }];
    
}

- (void)analysisRechargeListModelWithHeader:(BOOL)isHeader {
    
    for (PVRechargeDetailModel *chargeModel in self.rechargeListModel.rechargeList) {
        [self.itemModelArray addObject:chargeModel];
    }
    
    if (self.itemModelArray.count == 0) {
        self.nodataView.hidden = NO;
        self.lzTableView.mj_footer.hidden = YES;
    }else {
        self.nodataView.hidden = YES;
        [self.lzTableView reloadData];
    }
    if (self.rechargeListModel.rechargeList.count < kPageSize && self.itemModelArray.count > 0) {
        self.lzTableView.mj_footer.hidden = NO;
        [self.lzTableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVRechargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.chargeDetailModel = self.itemModelArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.itemModelArray.count;
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

// 懒加载
- (NSMutableArray *)itemModelArray{
    if (_itemModelArray == nil) {
        _itemModelArray = [[NSMutableArray alloc] init];
    }
    return _itemModelArray;
}

- (PVNoDataView *)nodataView {
    if (!_nodataView) {
        _nodataView = [[PVNoDataView alloc] initWithFrame:CGRectMake(0, 198, kScreenWidth, 200) ImageName:@"mine_img_norecord1" tipsLabelText:@"暂无充值记录"];
        [self.view insertSubview:_nodataView aboveSubview:self.lzTableView];
    }
    return _nodataView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
