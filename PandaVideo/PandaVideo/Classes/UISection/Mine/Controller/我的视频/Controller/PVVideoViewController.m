//
//  PVVideoViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoViewController.h"
#import "PVDBManager.h"
#import "PVUploadProgressViewController.h"
#import "PVMyVideoTableViewCell.h"
#import "PVDemandViewController.h"
#import "PVMyVideoModel.h"

static NSString* resuPVRecordTableViewCell = @"resuPVMyVideoTableViewCell";
@interface PVVideoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *tipsHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *progressCountTipsLabel;
@property (weak, nonatomic) IBOutlet UITableView *videoTableView;
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
//@property (nonatomic, strong) PVCollectionListModel *collectionListModel;
@property (nonatomic, assign) NSInteger index; //当前页数
@property (nonatomic, assign) NSInteger totalPage;   //总页数
@property (nonatomic, assign) CGFloat pageSize;    //每页数量
@property (nonatomic, strong) PVMyVideoListModel *videoListModel;
@property (weak, nonatomic) IBOutlet UIView *videoUploadProgressView;
@end

@implementation PVVideoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addUploadProgressViewGesture];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    适配iPhone X
    self.topLayout.constant = kNavBarHeight;
    self.safeViewHeightLyaout.constant = SafeAreaBottomHeight;
    
    self.pageSize = kPageSize;
    [self setupUI];
    [self addUploadProgressViewGesture];
    
}

-(void)setupNavigationBar{
    
    self.scNavigationItem.title = @"我的视频";
    
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


/**
 查看视频上传进度
 */
- (void)addUploadProgressViewGesture {
    if ([[PVDBManager sharedInstance] selectShortVideoModelAllData].count == 0) {
        self.progressCountTipsLabel.hidden = YES;
    }else {
        self.progressCountTipsLabel.hidden = NO;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchUploadProgress)];
    [self.videoUploadProgressView addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *panGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(searchUploadProgress)];
    panGes.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.videoUploadProgressView addGestureRecognizer:panGes];
}


/**
 手势响应事件
 */
- (void)searchUploadProgress {
//    if ([[PVDBManager sharedInstance] selectShortVideoModelAllData].count > 0) {
        PVUploadProgressViewController *con = [[PVUploadProgressViewController alloc] init];
        [self.navigationController pushViewController:con animated:YES];
//    }else {
//        Toast(@"没有正在上传的视频");
//    }
    
}


- (void)showDeleteAllDataView {
    if ([self.bottomDeleteBtn.titleLabel.text isEqualToString:@"全部删除"]) {
        self.allDeleted = YES;
        self.videoListModel = nil;
        [self rightBtnClicked:self.tabBarDeleteBtn];
        return;
    }
    if (self.dataSource.count == 0) {
        self.allDeleted = YES;
        [self rightBtnClicked:self.tabBarDeleteBtn];
    }
}

/** 右侧删除按钮，没有选择数据，底部删除按钮没有点击事件 */
-(void)rightBtnClicked:(UIButton*)btn{
    
    if (!self.allDeleted) {
        if (self.dataSource.count == 0) {
            Toast(@"没有视频记录可以删除");
            return;
        }else {
            self.allDeleted = NO;
        }
    }
    
    btn.selected = !btn.selected;
    if (!btn.selected) {
        for (PVMyVideoModel* model in self.dataSource) {
            model.isDelete = false;
        }
        self.videoTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.bottomContainerView.hidden = true;
        [btn setImage:[UIImage imageNamed:@"mine_btn_delete"] forState:UIControlStateNormal];
        self.videoTableView.mj_header.hidden = NO;
        
    }else{
        [btn setImage:nil forState:UIControlStateNormal];
        self.videoTableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        self.bottomContainerView.hidden = false;
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
        if (self.selectAllBtn.selected) {
            self.selectAllBtn.selected = !self.selectAllBtn.selected;
            [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        self.videoTableView.mj_footer.hidden = YES;
        self.videoTableView.mj_header.hidden = YES;
    }
    [self.videoTableView reloadData];
    SCLog(@"删除");
    if (self.dataSource.count == 0) {
        self.allDeleted = NO;
    }
}

-(void)setupUI{
    
    self.videoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.videoTableView registerNib:[UINib nibWithNibName:@"PVMyVideoTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVRecordTableViewCell];
    self.videoTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.videoTableView.mj_header beginRefreshing];
    
}


- (void)loadData {
    PV(PV);
    self.index = 1;
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
//    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
//        [PV.videoTableView.mj_header endRefreshing];
//        return;
//    }
    
    self.videoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.videoTableView.mj_footer.hidden = YES;
    
    NSDictionary *dict = @{@"index":@(self.index),@"pageSize":@(self.pageSize),@"token":huangToken,@"userId":huangUserId};
    
    [PVNetTool postDataHaveTokenWithParams:dict url:getUgcFileList success:^(id responseObject) {
        
        [PV.videoTableView.mj_header endRefreshing];
        
        if (responseObject) {
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:getMobileHistory];
            if (errorMsg.length > 0) {
                Toast(errorMsg);
            }else {
                PV.videoListModel = [PVMyVideoListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [PV analysisVideoListModelWithHeader:YES];
            }
        }
    } failure:^(NSError *error) {
        [PV.videoTableView.mj_header endRefreshing];
        
        Toast(@"获取我的视频记录失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        [PV.videoTableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData {
    PV(PV);
    self.index ++;
    if (self.index >= self.totalPage) {
        [self.videoTableView.mj_footer endRefreshingWithNoMoreData];
    }
    NSDictionary *dict = @{@"index":@(self.index),@"pageSize":@(self.pageSize),@"token":huangToken,@"userId":huangUserId};
    [PVNetTool postDataHaveTokenWithParams:dict url:getUgcFileList success:^(id responseObject) {
        [PV.videoTableView.mj_footer endRefreshing];
        if (responseObject) {
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:getMobileHistory];
            if (errorMsg.length > 0) {
                Toast(errorMsg);
            }else {
                PV.videoListModel = [PVMyVideoListModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                [PV analysisVideoListModelWithHeader:NO];
            }
        }
    } failure:^(NSError *error) {
        [PV.videoTableView.mj_footer endRefreshing];
        self.index --;
        self.haveNoMoreData = NO;
        Toast(@"获取我的视频记录失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        self.index --;
        self.haveNoMoreData = NO;
        [PV.videoTableView.mj_footer endRefreshing];
    }];
}

- (void)analysisVideoListModelWithHeader:(BOOL)isHeader {
    
    
    for (PVMyVideoModel *videoModel in self.videoListModel.videoList) {
        [self.dataSource addObject:videoModel];
    }
    
    if (self.dataSource.count == 0) {
        self.noDataView.hidden = NO;
        self.tipsHeaderView.hidden = YES;
        self.videoTableView.mj_footer.hidden = YES;
    }else {
        self.noDataView.hidden = YES;
        self.tipsHeaderView.hidden = NO;
        self.videoTableView.mj_footer.hidden = NO;
        self.totalPage = self.videoListModel.pageAllIndex;
        [self.videoTableView reloadData];
    }
    
    if (self.index >= self.totalPage && self.dataSource.count > 0) {
        self.videoTableView.mj_footer.hidden = NO;
        [self.videoTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

//展示没有数据的UI
- (void)showNoDataView {
    self.noDataView.hidden = NO;
    self.tipsHeaderView.hidden = YES;
}

/// MARK:- ====== UITableViewDelegate,UITableViewDataSource ==========

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVMyVideoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVRecordTableViewCell forIndexPath:indexPath];
    
    cell.isShow = self.tabBarDeleteBtn.selected;
    cell.videoModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.temporaryDeleteDataArray = [[NSMutableArray alloc] init];
    for (PVMyVideoModel* model in self.dataSource) {
        if (model.isDelete) {
            [self.temporaryDeleteDataArray addObject:model];
        }
    }
    
    PV(pv)
    [cell setPVMyVideoTableViewCellBlock:^(UIButton * btn) {
        PVMyVideoModel* model = [pv.dataSource sc_safeObjectAtIndex:indexPath.row];
        model.isDelete = btn.selected;
        NSInteger count = 0;
        
        for (PVMyVideoModel* model in pv.dataSource) {
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
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return IPHONE6WH(73);
    return 73;
}
///各种点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PVMyVideoModel *videoModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    if (videoModel.isDelete) return;
//    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
//    vc.url = videoModel.jsonUrl;
//    if (collectionModel.jsonUrl.length > 0) {
//        [self.navigationController pushViewController:vc animated:true];
//    }else {
//        Toast(@"url为空");
//    }
//
}

//全选
- (IBAction)selectBtnClicked:(UIButton*)sender {
    for (PVMyVideoModel* model in self.dataSource) {
        if (!sender.selected) {
            model.isDelete = true;
        }else{
            model.isDelete = false;
        }
    }
        
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    if (self.selectAllBtn.selected) {
        SCLog(@"-------全选---------");
        [self.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        for (PVMyVideoModel *model in self.dataSource) {
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
        for (PVMyVideoModel *model in self.dataSource) {
            model.isDelete = NO;
            if ([self.temporaryDeleteDataArray containsObject:model]) {
                [self.temporaryDeleteDataArray removeObject:model];
            }
        }
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
    }
    
    [self.videoTableView reloadData];
}


///删除
- (IBAction)bottomDeleteBtnClicked:(id)sender {
    
//    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
//        return;
//    }
//
   
    NSMutableArray* deleteArrs = [NSMutableArray array];
    NSString *idStr = [NSString new];
    for (PVMyVideoModel* model in self.temporaryDeleteDataArray) {
        idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%@,",model.videoId]];
        [deleteArrs addObject:model];
    }
    
    NSDictionary *dict = @{@"token":huangToken, @"userId":huangUserId, @"videoList":idStr};
    
    [PVNetTool postDataHaveTokenWithParams:dict url:delUgcFiles success:^(id responseObject) {
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                [self.dataSource removeObjectsInArray:deleteArrs];
                [self setBottomDeleteButtonTitleWithTitle:@"删除"];
                [self.videoTableView reloadData];
                [self showDeleteAllDataView];
            }else {
                Toast([responseObject pv_objectForKey:@"errorMsg"]);
            }
        }
    } failure:^(NSError *error) {
        Toast(@"删除失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        
    }];
    //    }
    
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
    [self.videoTableView reloadData];
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
