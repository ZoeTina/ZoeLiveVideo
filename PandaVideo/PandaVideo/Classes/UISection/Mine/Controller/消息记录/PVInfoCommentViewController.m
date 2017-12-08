//
//  PVInfoCommentViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInfoCommentViewController.h"
#import "PVInfoCommentTableViewCell.h"
#import "PVInfoCommentModel.h"

static NSString * reusPVInfoCommentTableViewCell = @"PVInfoCommentTableViewCell";

@interface PVInfoCommentViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) PVInfoListCommentModel *commentListModel;

@end

@implementation PVInfoCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTopView.hidden = true;
    self.index = 1;
    self.pageSize = kPageSize;
    
    [self initUI];
    [self loadData];
}

- (void)initUI {
    self.scNavigationBar.hidden = YES;
    self.commentTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.commentTableView.estimatedRowHeight = 197;
    [self.commentTableView registerNib:[UINib nibWithNibName:@"PVInfoCommentTableViewCell" bundle:nil] forCellReuseIdentifier:reusPVInfoCommentTableViewCell];
    
    self.commentTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.commentTableView.mj_header beginRefreshing];
    
}

- (void)loadData {
    
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    self.noDataView.hidden = YES;
    
    self.commentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.commentTableView.mj_footer.hidden = YES;
    
    NSDictionary *dict = @{@"index":@(self.index), @"pageSize":@(self.pageSize), @"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId};

    [PVNetTool postDataHaveTokenWithParams:dict url:getCommentByReplyList success:^(id responseObject) {
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                self.commentListModel = [PVInfoListCommentModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [self analysisCommentDataWithIsFirst:YES];
                [self.commentTableView.mj_header endRefreshing];
            }else {
                Toast([responseObject pv_objectForKey:@"errorMsg"]);
            }
        }
    } failure:^(NSError *error) {
        Toast(@"获取消息评论记录失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {

    }];

   
}

- (void)loadMoreData {
    self.index += self.pageSize;
    NSDictionary *dict = @{@"index":@(self.index), @"pageSize":@(self.pageSize), @"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId};
    
    [PVNetTool postDataHaveTokenWithParams:dict url:getCommentByReplyList success:^(id responseObject) {
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                self.commentListModel = [PVInfoListCommentModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                
                if (self.commentListModel.replyList.count == 0) {
                    [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [self.commentTableView.mj_footer endRefreshing];
                    [self analysisCommentDataWithIsFirst:NO];
                }
            }else {
                Toast([responseObject pv_objectForKey:@"errorMsg"]);
            }
            
            
        }
    } failure:^(NSError *error) {
        Toast(@"获取消息评论记录失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        
    }];
}

- (void)analysisCommentDataWithIsFirst:(BOOL)isFirst {
    for (PVInfoCommentModel *commentModel in self.commentListModel.replyList) {
        [self.dataSource addObject:commentModel];
    }
    
    if (self.dataSource.count == 0 && isFirst) {
        self.noDataView.hidden = NO;
//        self.commentTableView.hidden = YES;
    }else {
        self.noDataView.hidden = YES;
        self.commentTableView.mj_footer.hidden = NO;
        [self.commentTableView reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVInfoCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusPVInfoCommentTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PVInfoCommentModel *commentModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    cell.isOpen = commentModel.isFullText;
    cell.commentModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    
    __weak PVInfoCommentTableViewCell *weakCell = cell;
    [cell setPVInfoCommentTableViewCellBlock:^(id sender) {
        weakCell.isOpen = true;
        commentModel.isFullText = true;
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [tableView reloadData];
    }];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 194;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
