   //
//  PVHistoryViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHistoryViewController.h"
#import "PVRecordTableViewCell.h"
#import "PVHistoryModel.h"
//#import "PVTeleversionHistoryController.h"
#import "PVTeleversionDetailController.h"
#import "PVNoDataView.h"
#import "PVDBManager.h"
#import "PVDemandViewController.h"

static NSString* resuPVRecordTableViewCell = @"resuPVRecordTableViewCell";


@interface PVHistoryViewController ()  <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopLayout;

//自定义底部safeView
@property (weak, nonatomic) IBOutlet UIView *safeAreaView;

//底部safeView高度约束，适配iphoneX
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *safeAreaHeightLayout;

@property (weak, nonatomic) IBOutlet UIView *televersionView;
@property (weak, nonatomic) IBOutlet UITableView *recordTableView;
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong)UIButton* deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *deleteContanierView;
@property (weak, nonatomic) IBOutlet UIButton *bottomDeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordTableViewTopConstraint;

@property (nonatomic, assign) NSInteger currentpage; //当前页数
@property (nonatomic, assign) NSInteger totalPage;   //总页数
@property (nonatomic, assign) CGFloat pageSize;    //每页数量
@property (nonatomic, strong) PVHistoryListModel *historyListModel;
@property (nonatomic, assign) BOOL haveNoMoreData;
@property (nonatomic, assign) BOOL allDeleted;
@property (nonatomic, strong) NSMutableArray *temporaryDeleteDataArray;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) CGFloat televisionTopHeight;
@property (nonatomic, assign) BOOL isDeleting;
@end

@implementation PVHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.televisionTopHeight = 50;
//    适配iPhone X
    self.headerTopLayout.constant = kNavBarHeight;
    self.safeAreaHeightLayout.constant = SafeAreaBottomHeight;
    
    self.pageSize = kPageSize;
    [self setupUI];
    
}



-(void)setupNavigationBar{
    
    self.scNavigationItem.title = (self.type == 0) ? @"观看记录" : @"收藏";
    
    if (self.type == 1) {
        self.televersionView.hidden = true;
      self.recordTableViewTopConstraint.constant = -self.televisionTopHeight;
    }
    
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"mine_btn_delete"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"取消" forState:UIControlStateSelected];
    [rightBtn setTitleColor: [UIColor sc_colorWithHex:0x000000] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]  initWithCustomView:rightBtn];
    self.scNavigationItem.rightBarButtonItem = rightItem;
    self.deleteBtn = rightBtn;
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapGestureClicked)];
    [self.televersionView addGestureRecognizer:tapGesture];
    
     UISwipeGestureRecognizer *panGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClicked)];
    panGes.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.televersionView addGestureRecognizer:panGes];
}

/** 右侧删除按钮，没有选择数据，底部删除按钮没有点击事件 */
-(void)rightBtnClicked:(UIButton*)btn{
    
    if (!self.allDeleted) {
        if (self.dataSource.count == 0) {
            Toast(@"没有历史记录可以删除");
            return;
        }else {
            self.allDeleted = NO;
        }
    }
    
    btn.selected = !btn.selected;
    if (!btn.selected) {
        for (PVHistoryModel* model in self.dataSource) {
            model.isDelete = false;
        }
        self.recordTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.deleteContanierView.hidden = true;
        [btn setImage:[UIImage imageNamed:@"mine_btn_delete"] forState:UIControlStateNormal];
        self.recordTableView.mj_header.hidden = NO;
        if (self.dataSource.count > 0) {
            self.recordTableView.mj_footer.hidden = NO;
        }
        
        if (self.haveNoMoreData) {
            [self.recordTableView.mj_footer endRefreshingWithNoMoreData];
        }
        self.isDeleting = NO;
    }else{
//        self.allowDelete = YES;
        [btn setImage:nil forState:UIControlStateNormal];
        self.recordTableView.contentInset = UIEdgeInsetsMake(0, 0, self.televisionTopHeight, 0);
        self.deleteContanierView.hidden = false;
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
        if (self.allSelectButton.selected) {
            self.allSelectButton.selected = !self.allSelectButton.selected;
            [self.allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
        }
        self.recordTableView.mj_footer.hidden = YES;
        self.recordTableView.mj_header.hidden = YES;
        self.isDeleting = YES;
    }
    [self.recordTableView reloadData];
    SCLog(@"删除");
    if (self.dataSource.count == 0) {
        self.allDeleted = NO;
    }
}

-(void)tapGestureClicked{
    if([PVUserModel shared].userId == 0 || [PVUserModel shared].token.length == 0) {
        Toast(@"请先进行登录");
        return;
    }
    
    PVTeleversionDetailController* vc = [[PVTeleversionDetailController alloc]  init];
    [self.navigationController pushViewController:vc animated:true];
}


-(void)setupUI{
    
    self.recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.recordTableView registerNib:[UINib nibWithNibName:@"PVRecordTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVRecordTableViewCell];
    
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        [self loadLocalHistoryData];
    }else {
        self.recordTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
            [self loadData];
        }];
        [self.recordTableView.mj_header beginRefreshing];
    }
   
}

/**未登陆时加载本地数据*/
- (void)loadLocalHistoryData {
 
    NSArray *array = [[PVDBManager sharedInstance] selectVisitVideoAllData];
    for (PVHistoryModel *historyModel in array) {
        [self.dataSource addObject:historyModel];
    }
    if (self.dataSource.count == 0) {
        self.noDataView.hidden = NO;
        return;
    }
    [self.recordTableView reloadData];
}

/**头视图加载数据*/
- (void)loadData {
    PV(PV);
    
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    self.haveNoMoreData = NO;
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        [PV.recordTableView.mj_header endRefreshing];
        return;
    }
    self.currentpage = 1;
    self.recordTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.recordTableView.mj_footer.hidden = YES;
    
    NSDictionary *dict = @{@"index":@(self.currentpage), @"pageSize":@(self.pageSize), @"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId};

    [PVNetTool postDataHaveTokenWithParams:dict url:getMobileHistory success:^(id responseObject) {
        
        [PV.recordTableView.mj_header endRefreshing];
        
        if (responseObject) {
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:getMobileHistory];
            if (errorMsg.length > 0) {
                Toast(errorMsg);
            }else {
                PV.historyListModel = [PVHistoryListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [PV analysisHistoryListModel];
                
            }
        }
    } failure:^(NSError *error) {
        [PV.recordTableView.mj_header endRefreshing];
        
        Toast(@"获取历史观看记录失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        [PV.recordTableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData {
    PV(PV);
    self.currentpage ++;
    if (self.currentpage > self.totalPage) {
        self.haveNoMoreData = YES;
        [self.recordTableView.mj_footer endRefreshingWithNoMoreData];
    }else {
        if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
            [PV.recordTableView.mj_footer endRefreshing];
            return;
        }
        NSDictionary *dict = @{@"index":@(self.currentpage),@"pageSize":@(self.pageSize),@"token":[PVUserModel shared].token,@"userId":[PVUserModel shared].userId};
        [PVNetTool postDataHaveTokenWithParams:dict url:getMobileHistory success:^(id responseObject) {
            [PV.recordTableView.mj_footer endRefreshing];
            if (responseObject) {
                NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:getMobileHistory];
                if (errorMsg.length > 0) {
                    Toast(errorMsg);
                }else {
                    PV.historyListModel = [PVHistoryListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                    [PV analysisHistoryListModel];
                }
            }
        } failure:^(NSError *error) {
            [PV.recordTableView.mj_footer endRefreshing];
            self.currentpage --;
            self.haveNoMoreData = NO;
            Toast(@"获取历史观看记录失败");
        } tokenErrorInfo:^(NSString *tokenErrorInfo) {
            self.currentpage --;
            self.haveNoMoreData = NO;
            [PV.recordTableView.mj_footer endRefreshing];
        }];
    }
}

- (void)analysisHistoryListModel {
    for (PVHistoryModel *historyModel in self.historyListModel.historyList) {
        [self.dataSource addObject:historyModel];
    }
    if (self.historyListModel.total == 0) {
        self.noDataView.hidden = NO;
        self.deleteBtn.hidden = YES;
    }else {
        self.deleteBtn.hidden = NO;
        self.noDataView.hidden = YES;
        self.recordTableView.mj_footer.hidden = NO;
        self.totalPage = ceilf(self.historyListModel.total / self.pageSize);
        [self.recordTableView reloadData];
    }
    if (self.currentpage == self.totalPage && self.dataSource.count > 0) {
        self.recordTableView.mj_footer.hidden = NO;
        [self.recordTableView.mj_footer endRefreshingWithNoMoreData];
        self.haveNoMoreData = YES;
    }
}



/// MARK:- ====== UITableViewDelegate,UITableViewDataSource ==========

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVRecordTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVRecordTableViewCell forIndexPath:indexPath];
    
    cell.isShow = self.deleteBtn.selected;
    cell.historyModel = self.dataSource[indexPath.row];
    
    self.temporaryDeleteDataArray = [[NSMutableArray alloc] init];
    for (PVHistoryModel* model in self.dataSource) {
        if (model.isDelete) {
            [self.temporaryDeleteDataArray addObject:model];
        }
    }
    
    PV(pv)
    [cell setPVRecordTableViewCellBlockBlock:^(UIButton * btn) {
        PVHistoryModel* model = pv.dataSource[indexPath.row];
        model.isDelete = btn.selected;
        NSInteger count = 0;
        
        for (PVHistoryModel* model in pv.dataSource) {
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
    PVHistoryModel *historyModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    if (self.isDeleting) {
        PVRecordTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self seleteCellIsDeleteWithIndex:indexPath cell:cell];
    }else {
        PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
        vc.url = historyModel.videoUrl;
        vc.code = historyModel.code;
        if (historyModel.videoUrl.length > 0) {
            [self.navigationController pushViewController:vc animated:true];
        }else {
            Toast(@"视频链接为空");
        }
    }
}

- (void)seleteCellIsDeleteWithIndex:(NSIndexPath *)index cell:(PVRecordTableViewCell *)cell{
    PV(pv);
    PVHistoryModel* model = [pv.dataSource sc_safeObjectAtIndex:index.row];
    model.isDelete = !model.isDelete;
    NSInteger count = 0;
    
    for (PVHistoryModel* model in pv.dataSource) {
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
    [pv.tableView reloadData];
}

//全选
- (IBAction)selectBtnClicked:(UIButton*)sender {
    
    for (PVHistoryModel* model in self.dataSource) {
        if (!sender.selected) {
            model.isDelete = true;
        }else{
            model.isDelete = false;
        }
    }
    
    //没有登录的时候全选单独处理
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        [self unloginSelectAll];
        return;
    }
    
    self.allSelectButton.selected = !self.allSelectButton.selected;
    if (self.allSelectButton.selected) {
        SCLog(@"-------全选---------");
        [self.allSelectButton setTitle:@"取消全选" forState:UIControlStateNormal];
        for (PVHistoryModel *model in self.dataSource) {
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
        for (PVHistoryModel *model in self.dataSource) {
            model.isDelete = NO;
            if ([self.temporaryDeleteDataArray containsObject:model]) {
                [self.temporaryDeleteDataArray removeObject:model];
            }
        }
        [self.allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
    }

    [self.recordTableView reloadData];
}

/**没有登录时的全选*/
- (void)unloginSelectAll {
    
    self.allSelectButton.selected = !self.allSelectButton.selected;
    if (self.allSelectButton.selected) {
        SCLog(@"-------全选---------");
        [self.allSelectButton setTitle:@"取消全选" forState:UIControlStateNormal];
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
        [self.allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
    }
    
    [self.recordTableView reloadData];
}

///删除
- (IBAction)bottomDeleteBtnClicked:(id)sender {
    
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        [self unloginDelete];
        return;
    }
    
    if (self.haveNoMoreData && self.temporaryDeleteDataArray.count == self.historyListModel.total) {
        
        NSDictionary *dict = @{@"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId};
        
        [PVNetTool postDataHaveTokenWithParams:dict url:deleteAllHitsory success:^(id responseObject) {
            if (responseObject) {
                if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200 ) {
                    [self.dataSource removeObjectsInArray:self.temporaryDeleteDataArray];
                    [self.recordTableView reloadData];
//                    [self showNoDataView];
                    self.noDataView.hidden = NO;
                    [self showDeleteAllDataView];
                }
            }
        } failure:^(NSError *error) {
            Toast(@"删除所有数据失败");
        } tokenErrorInfo:^(NSString *tokenErrorInfo) {
            
        }];
    }
    else {
        NSMutableArray* deleteArrs = [NSMutableArray array];
        NSString *idStr = [NSString new];
        for (PVHistoryModel* model in self.temporaryDeleteDataArray) {
            idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%@,",model.code]];
            [deleteArrs addObject:model];
        }

        NSDictionary *dict = @{@"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId, @"codes":idStr};
        
        [PVNetTool postDataHaveTokenWithParams:dict url:deleteHistory success:^(id responseObject) {
            if (responseObject) {
                if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                    [self.dataSource removeObjectsInArray:deleteArrs];
                    [self setBottomDeleteButtonTitleWithTitle:@"删除"];
                    [self.recordTableView reloadData];
                    [self showDeleteAllDataView];
                }else {
                    Toast(@"删除失败");
                }
            }
        } failure:^(NSError *error) {
            Toast(@"删除失败");
        } tokenErrorInfo:^(NSString *tokenErrorInfo) {
            
        }];
       
    }
    
}

/**没有登录时的删除操作*/
- (void)unloginDelete {
    for (PVHistoryModel *historyModel in self.temporaryDeleteDataArray) {
        PVDemandVideoAnthologyModel* anthologyModel = [[PVDemandVideoAnthologyModel alloc]  init];
        anthologyModel.code = historyModel.code;
        if ([[PVDBManager sharedInstance] deleteVisitVideoModel:anthologyModel]) {
            [self.dataSource removeObject:historyModel];
        }
    }
    
    [self.recordTableView reloadData];
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
    [self.recordTableView reloadData];
}


- (void)showDeleteAllDataView {
    if ([self.bottomDeleteBtn.titleLabel.text isEqualToString:@"全部删除"]) {
        self.allDeleted = YES;
        [self rightBtnClicked:self.deleteBtn];
        self.noDataView.hidden = NO;
        self.recordTableView.mj_footer.hidden = YES;
        return;
    }
    if (self.dataSource.count == 0) {
        self.allDeleted = YES;
        [self rightBtnClicked:self.deleteBtn];
        [self loadData];
    }
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

@end
