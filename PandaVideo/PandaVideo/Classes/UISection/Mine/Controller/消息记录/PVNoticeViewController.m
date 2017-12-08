//
//  PVNoticeViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVNoticeViewController.h"
#import "PVNoticeInfoModel.h"
#import "PVNoticeInfoTableViewCell.h"
#import "PVNoticeInfoDetailViewController.h"
#import "PVBaseWebViewController.h"
#import "PVDBManager.h"

static NSString * resuPVNoticeInfoTableViewCell = @"PVNoticeInfoTableViewCell";

@interface PVNoticeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *noticeTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *isReadDataSource;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (nonatomic, strong) PVNoticeInfoListModel *noticeListModel;
@property (nonatomic, assign) NSInteger pageAll;
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation PVNoticeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scNavigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.scNavigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTopView.hidden = true;
    [self setupUI];
}

- (void)setupUI {
    
    self.noticeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.noticeTableView registerNib:[UINib nibWithNibName:@"PVNoticeInfoTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVNoticeInfoTableViewCell];
//    [self.noticeTableView registerClass:[PVNoticeInfoTableViewCell class] forCellReuseIdentifier:resuPVNoticeInfoTableViewCell];
    self.noticeTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.noticeTableView.mj_header beginRefreshing];
}

- (void)loadData {
   
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    self.currentPage = 0;
    
    self.noticeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.noticeTableView.mj_footer.hidden = YES;
    
    [PVNetTool getDataWithUrl:infomationPush success:^(id result) {
        if (result) {
            
            [self.noticeTableView.mj_header endRefreshing];
            
            self.noticeListModel = [PVNoticeInfoListModel yy_modelWithDictionary:result];
            [self analysisInfoData];
        }
    } failure:^(NSError *error) {
        if (error) {
            [self.noticeTableView.mj_header endRefreshing];
        }
    }];
    
}

- (void)loadMoreData {
    
    self.currentPage ++;
    if (self.currentPage >= self.noticeListModel.pageAllIndex) {
        [self.noticeTableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    
    NSString *requestUrl = [infomationPush sc_urlStringWithIndex:self.currentPage];
    
    [PVNetTool getDataWithUrl:requestUrl success:^(id result) {
        if (result) {
            [self.noticeTableView.mj_footer endRefreshing];
            self.noticeListModel = [PVNoticeInfoListModel yy_modelWithDictionary:result];
            [self analysisInfoData];
        }
    } failure:^(NSError *error) {
        if (error) {
            [self.noticeTableView.mj_footer endRefreshing];
        }
    }];
}
- (void)analysisInfoData {
    NSArray *dabaIsReadData = [[PVDBManager sharedInstance] selectPVSystemNotificationAllData];
    [self.isReadDataSource removeAllObjects];
    
    for (PVNoticeInfoModel *infoModel in self.noticeListModel.list) {
        for (PVNoticeInfoModel *model in dabaIsReadData) {
            if ([model.msgId isEqualToString:infoModel.msgId]) {
                infoModel.isRead = YES;
                [self.isReadDataSource addObject:infoModel];
            }
        }
        [self.dataSource addObject:infoModel];
    }
    
    if (self.dataSource.count == 0) {
        self.noDataView.hidden = NO;
    }else {
        
        self.noticeTableView.mj_footer.hidden = NO;
        self.noDataView.hidden = YES;
        [self.noticeTableView reloadData];
        
        NSInteger num = self.dataSource.count - self.isReadDataSource.count;
        NSDictionary *dict = @{@"noticeNum":@(num)};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNoticeNum" object:nil userInfo:dict];
//        if (self.noticeListModel.list.count < kPageSize && self.dataSource.count > 0) {
//            self.noticeTableView.mj_footer.hidden = NO;
//            [self.noticeTableView.mj_footer endRefreshingWithNoMoreData];
//        }
    }
}

#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVNoticeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuPVNoticeInfoTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.infoModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PVNoticeInfoModel *infoModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    if (infoModel) {
        PV(pv);
        PVBaseWebViewController *con = [[PVBaseWebViewController alloc] initWebViewWithUrl:infoModel.jsonUrl title:@""];
        if (infoModel.isRead) {
            [self.navigationController pushViewController:con animated:YES];
        }else {
            if ([[PVDBManager sharedInstance] insertSystemNotificationWithModel:infoModel]) {
                
                [self.isReadDataSource addObject:infoModel];
                infoModel.isRead = YES;
                
                NSInteger num = self.dataSource.count - self.isReadDataSource.count;
                NSDictionary *dict = @{@"noticeNum":@(num)};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeNoticeNum" object:nil userInfo:dict];
                [pv.noticeTableView reloadData];
            }
            [self.navigationController pushViewController:con animated:YES];
        }
        
    }
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)isReadDataSource {
    if (!_isReadDataSource) {
        _isReadDataSource = [[NSMutableArray alloc] init];
    }
    return _isReadDataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
