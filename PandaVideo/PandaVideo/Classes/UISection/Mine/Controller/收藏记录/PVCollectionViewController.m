//
//  PVCollectionViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/30.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVCollectionViewController.h"
#import "PVCollectionModel.h"
#import "PVRecordTableViewCell.h"
#import "PVDemandVideoAnthologyModel.h"
#import "PVHistoryModel.h"
#import "PVDBManager.h"
#import "PVDemandViewController.h"

static NSString* resuPVRecordTableViewCell = @"resuPVRecordTableViewCell";
@interface PVCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *collectionTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomDeleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *safeViewHeightLyaout;
@property (nonatomic, strong)UIButton* tabBarDeleteBtn;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) NSMutableArray *temporaryDeleteDataArray;
@property (nonatomic, assign) BOOL haveNoMoreData;
@property (nonatomic, assign) BOOL allDeleted;
@property (nonatomic, strong) PVCollectionListModel *collectionListModel;
@property (nonatomic, assign) NSInteger currentpage; //当前页数
@property (nonatomic, assign) NSInteger totalPage;   //总页数
@property (nonatomic, assign) CGFloat pageSize;    //每页数量
@property (nonatomic, assign) BOOL isDeleting;
@end

@implementation PVCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    适配iPhone X
    self.topLayout.constant = kNavBarHeight;
    self.safeViewHeightLyaout.constant = SafeAreaBottomHeight;
    
    self.pageSize = kPageSize;
    [self setupUI];
}

-(void)setupNavigationBar{
    
    self.scNavigationItem.title = @"收藏";
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"mine_btn_delete"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"取消" forState:UIControlStateSelected];
    [rightBtn setTitleColor: [UIColor sc_colorWithHex:0x000000] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]  initWithCustomView:rightBtn];
    self.scNavigationItem.rightBarButtonItem = rightItem;
    self.tabBarDeleteBtn = rightBtn;
    
  
}

- (void)showDeleteAllDataView {
    if ([self.bottomDeleteBtn.titleLabel.text isEqualToString:@"全部删除"] && self.dataSource.count == 0) {
        self.allDeleted = YES;
        self.collectionListModel = nil;
        [self rightBtnClicked:self.tabBarDeleteBtn];
        self.noDataView.hidden = NO;
        return;
    }
    if (self.dataSource.count == 0) {
        self.allDeleted = YES;
        [self rightBtnClicked:self.tabBarDeleteBtn];
        [self loadData];
    }
}

/** 右侧删除按钮，没有选择数据，底部删除按钮没有点击事件 */
-(void)rightBtnClicked:(UIButton*)btn{
    
    if (!self.allDeleted) {
        if (self.dataSource.count == 0) {
            Toast(@"没有收藏记录可以删除");
            return;
        }else {
            self.allDeleted = NO;
        }
    }
    
    btn.selected = !btn.selected;
    if (!btn.selected) {
        for (PVCollectionModel* model in self.dataSource) {
            model.isDelete = false;
        }
        self.collectionTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.bottomContainerView.hidden = true;
        [btn setImage:[UIImage imageNamed:@"mine_btn_delete"] forState:UIControlStateNormal];
        self.collectionTableView.mj_header.hidden = NO;
        if (self.dataSource.count > 0) {
            self.collectionTableView.mj_footer.hidden = NO;
        }

        if (self.haveNoMoreData) {
            
            [self.collectionTableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.isDeleting = NO;
    }else{
        [btn setImage:nil forState:UIControlStateNormal];
        self.collectionTableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        self.bottomContainerView.hidden = false;
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
        if (self.selectAllBtn.selected) {
            self.selectAllBtn.selected = !self.selectAllBtn.selected;
            [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        self.collectionTableView.mj_footer.hidden = YES;
        self.collectionTableView.mj_header.hidden = YES;
        self.isDeleting = YES;
    }
    [self.collectionTableView reloadData];
    SCLog(@"删除");
    if (self.dataSource.count == 0) {
        self.allDeleted = NO;
    }
}

-(void)setupUI{
    
    self.collectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.collectionTableView registerNib:[UINib nibWithNibName:@"PVRecordTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVRecordTableViewCell];
    if ([PVUserModel shared].userId == 0 || [PVUserModel shared].token.length == 0) {
        [self loadLocalCollectionData];
    }else {
        self.collectionTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
            [self loadData];
        }];
        [self.collectionTableView.mj_header beginRefreshing];
    }
    
}

/**加载本地收藏记录*/
- (void)loadLocalCollectionData {
    
    NSArray *collectionArr = [[PVDBManager sharedInstance] selectCollectVideoAllData];
    for (PVCollectionModel *collectionModel in collectionArr) {
        [self.dataSource addObject:collectionModel];
    }
    if (self.dataSource.count == 0) {
        self.noDataView.hidden = NO;
        return;
    }
    [self.collectionTableView reloadData];
}

- (void)loadData {
    PV(PV);
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    self.haveNoMoreData = NO;
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        [PV.collectionTableView.mj_header endRefreshing];
        return;
    }
    self.currentpage = 1;
    self.collectionTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.collectionTableView.mj_footer.hidden = YES;
    
    NSDictionary *dict = @{@"index":@(self.currentpage),@"pageSize":@(self.pageSize),@"token":[PVUserModel shared].token,@"userId":[PVUserModel shared].userId};
    
    [PVNetTool postDataHaveTokenWithParams:dict url:getFavList success:^(id responseObject) {
        
        [PV.collectionTableView.mj_header endRefreshing];
        
        if (responseObject) {
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:getMobileHistory];
            if (errorMsg.length > 0) {
                Toast(errorMsg);
            }else {
                PV.collectionListModel = [PVCollectionListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [PV analysisHistoryListModelWithHeader:YES];
                
            }
        }
    } failure:^(NSError *error) {
        [PV.collectionTableView.mj_header endRefreshing];
        
        Toast(@"获取收藏记录失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        [PV.collectionTableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData {
    PV(PV);
    self.currentpage ++;
    if (self.currentpage > self.totalPage) {
        self.haveNoMoreData = YES;
        [self.collectionTableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
            [PV.collectionTableView.mj_footer endRefreshing];
            return;
        }
        NSDictionary *dict = @{@"index":@(self.currentpage),@"pageSize":@(self.pageSize),@"token":[PVUserModel shared].token,@"userId":[PVUserModel shared].userId};
        [PVNetTool postDataHaveTokenWithParams:dict url:getFavList success:^(id responseObject) {
            [PV.collectionTableView.mj_footer endRefreshing];
            if (responseObject) {
                NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:getMobileHistory];
                if (errorMsg.length > 0) {
                    Toast(errorMsg);
                }else {
                    PV.collectionListModel = [PVCollectionListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                    [PV analysisHistoryListModelWithHeader:NO];
                }
            }
        } failure:^(NSError *error) {
            [PV.collectionTableView.mj_footer endRefreshing];
            self.currentpage --;
            self.haveNoMoreData = NO;
            Toast(@"获取收藏观看记录失败");
        } tokenErrorInfo:^(NSString *tokenErrorInfo) {
            self.currentpage --;
            self.haveNoMoreData = NO;
            [PV.collectionTableView.mj_footer endRefreshing];
        }];
    }
}

- (void)analysisHistoryListModelWithHeader:(BOOL)isHeader {
    for (PVCollectionModel *collectionModel in self.collectionListModel.favList) {
        [self.dataSource addObject:collectionModel];
    }
    if (self.collectionListModel.total == 0) {
        self.noDataView.hidden = NO;
        self.collectionTableView.mj_footer.hidden = YES;
        self.tabBarDeleteBtn.hidden = YES;
    }else {
        self.noDataView.hidden = YES;
        self.collectionTableView.mj_footer.hidden = NO;
        self.totalPage = ceilf(self.collectionListModel.total / self.pageSize);
        [self.collectionTableView reloadData];
        self.tabBarDeleteBtn.hidden = NO;
    }
    if (self.currentpage == self.totalPage && self.dataSource.count > 0) {
        self.collectionTableView.mj_footer.hidden = NO;
        [self.collectionTableView.mj_footer endRefreshingWithNoMoreData];
        self.haveNoMoreData = YES;
    }
}


/// MARK:- ====== UITableViewDelegate,UITableViewDataSource ==========

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVRecordTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVRecordTableViewCell forIndexPath:indexPath];
    
    cell.isShow = self.tabBarDeleteBtn.selected;
    cell.collectionModel = self.dataSource[indexPath.row];
    
    self.temporaryDeleteDataArray = [[NSMutableArray alloc] init];
    for (PVCollectionModel* model in self.dataSource) {
        if (model.isDelete) {
            [self.temporaryDeleteDataArray addObject:model];
        }
    }
    
    PV(pv)
    [cell setPVRecordTableViewCellBlockBlock:^(UIButton * btn) {
        PVCollectionModel* model = pv.dataSource[indexPath.row];
        model.isDelete = btn.selected;
        NSInteger count = 0;
        
        for (PVCollectionModel* model in pv.dataSource) {
            if (model.isDelete) {
                count++;
                [self.temporaryDeleteDataArray addObject:model];
            }
        }
        NSString* title = @"删除";
        if (count) {
            title = [NSString stringWithFormat:@"删除 (%lu)",(unsigned long)count];
        }
        //        [self.bottomDeleteBtn setTitle:title forState:UIControlStateNormal];
        [self setBottomDeleteButtonTitleWithTitle:title];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return IPHONE6WH(73);
    return 73;
}
///各种点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PVCollectionModel *collectionModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    if (self.isDeleting) {
        PVRecordTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self seleteCellIsDeleteWithIndex:indexPath cell:cell];
    }else {
        PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
        vc.url = collectionModel.videoUrl;
        vc.code = collectionModel.code;
        if (collectionModel.videoUrl.length > 0) {
            [self.navigationController pushViewController:vc animated:true];
        }else {
            Toast(@"视频链接为空");
        }
    }
}

- (void)seleteCellIsDeleteWithIndex:(NSIndexPath *)index cell:(PVRecordTableViewCell *)cell{
    PV(pv);
    PVCollectionModel* model = [pv.dataSource sc_safeObjectAtIndex:index.row];
    model.isDelete = !model.isDelete;
    NSInteger count = 0;
    
    for (PVCollectionModel* model in pv.dataSource) {
        if (model.isDelete) {
            count++;
            [self.temporaryDeleteDataArray addObject:model];
        }
    }
    NSString* title = @"删除";
    if (count) {
        title = [NSString stringWithFormat:@"删除 (%lu)",(unsigned long)count];
    }
    [self setBottomDeleteButtonTitleWithTitle:title];
    [pv.collectionTableView reloadData];
}

//全选
- (IBAction)selectBtnClicked:(UIButton*)sender {
    for (PVCollectionModel* model in self.dataSource) {
        if (!sender.selected) {
            model.isDelete = true;
        }else{
            model.isDelete = false;
        }
    }
    
    if ([PVUserModel shared].token.length == 0 || [PVUserModel shared].userId.length == 0) {
        [self unloginSelectAll];
        return;
    }
    
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    if (self.selectAllBtn.selected) {
        SCLog(@"-------全选---------");
        [self.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        for (PVCollectionModel *model in self.dataSource) {
            model.isDelete = YES;
            [self.temporaryDeleteDataArray addObject:model];
        }
        if (self.haveNoMoreData){
            [self setBottomDeleteButtonTitleWithTitle:@"全部删除"];
            
        }else {
            [self setBottomDeleteButtonTitleWithTitle:[NSString stringWithFormat:@"删除 (%lu)",(unsigned long)self.dataSource.count]];
        }
    }else {
        SCLog(@"--------取消全选---------");
        for (PVCollectionModel *model in self.dataSource) {
            model.isDelete = NO;
            if ([self.temporaryDeleteDataArray containsObject:model]) {
                [self.temporaryDeleteDataArray removeObject:model];
            }
        }
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
    }
    
    [self.collectionTableView reloadData];
}

/**没有登录时的全选*/
- (void)unloginSelectAll {
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    if (self.selectAllBtn.selected) {
        SCLog(@"-------全选---------");
        [self.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        for (PVHistoryModel *model in self.dataSource) {
            model.isDelete = YES;
            [self.temporaryDeleteDataArray addObject:model];
        }
        
        [self setBottomDeleteButtonTitleWithTitle:@"全部删除"];
        
    }else {
        SCLog(@"--------取消全选---------");
        for (PVHistoryModel *model in self.dataSource) {
            model.isDelete = NO;
            if ([self.temporaryDeleteDataArray containsObject:model]) {
                [self.temporaryDeleteDataArray removeObject:model];
            }
        }
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
    }
    
    [self.collectionTableView reloadData];
}

///删除
- (IBAction)bottomDeleteBtnClicked:(id)sender {
    
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        [self unloginDelete];
        return;
    }
    
        NSMutableArray* deleteArrs = [NSMutableArray array];
        NSString *idStr = [NSString new];
        for (PVCollectionModel* model in self.temporaryDeleteDataArray) {
            idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%@,",model.code]];
            [deleteArrs addObject:model];
        }
        
        NSDictionary *dict = @{@"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId, @"codes":idStr};
        
        [PVNetTool postDataHaveTokenWithParams:dict url:deleteFavorite success:^(id responseObject) {
            if (responseObject) {
                if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                    [self.dataSource removeObjectsInArray:deleteArrs];
                    if (self.haveNoMoreData){
                        [self setBottomDeleteButtonTitleWithTitle:@"全部删除"];
                    }else {
                        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
                    }
                    
                    [self.collectionTableView reloadData];
                    [self showDeleteAllDataView];
                }else {
                    Toast([responseObject pv_objectForKey:@"errorMsg"]);
                }
            }
        } failure:^(NSError *error) {
            Toast(@"删除失败");
        } tokenErrorInfo:^(NSString *tokenErrorInfo) {
            
        }];
    
}

- (void)unloginDelete {
    for (PVCollectionModel *collectionModel in self.temporaryDeleteDataArray) {
        PVDemandVideoAnthologyModel *anthologyModel = [[PVDemandVideoAnthologyModel alloc] init];
        anthologyModel.code = collectionModel.code;
        if ([[PVDBManager sharedInstance] deleteCollectVideoModel:anthologyModel]) {
            [self.dataSource removeObject:collectionModel];
        }
    }
    [self.collectionTableView reloadData];
    [self showDeleteAllDataView];
}

- (void)setBottomDeleteButtonTitleWithTitle:(NSString *)title {
    if ([title isEqualToString:@"删除"]) {
        [self.bottomDeleteBtn setTitleColor:[UIColor sc_colorWithHex:0x808080] forState:UIControlStateNormal];
        self.bottomDeleteBtn.userInteractionEnabled = NO;
    }else {
        
        [self.bottomDeleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.bottomDeleteBtn.userInteractionEnabled = YES;
    }
    
    [self.bottomDeleteBtn setTitle:title forState:UIControlStateNormal];
    [self.collectionTableView reloadData];
    if (self.dataSource.count == 0) {
        self.collectionTableView.mj_footer.hidden = YES;
    }
}



-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
