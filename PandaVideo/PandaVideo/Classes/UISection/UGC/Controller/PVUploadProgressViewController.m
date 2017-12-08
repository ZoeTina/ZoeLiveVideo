//
//  PVUploadProgressViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUploadProgressViewController.h"
#import "SCAssetModel.h"
#import "PVUploadProgressCell.h"
#import "PVDBManager.h"
#import "PVUploadVideoTool.h"
#import "LZImageManager.h"
#import "SCImageManager.h"
#import "PVUGCModel.h"

static NSString* resuPVUploadProgressCell = @"PVUploadProgressCell";
@interface PVUploadProgressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *progressTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomDeleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *safeViewHeightLyaout;
@property (nonatomic, strong)UIButton* tabBarDeleteBtn;
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) NSMutableArray *temporaryDeleteDataArray;
@property (nonatomic, assign) BOOL haveNoMoreData;
@property (nonatomic, assign) BOOL allDeleted;
//@property (nonatomic, strong) PVCollectionListModel *collectionListModel;
@property (nonatomic, assign) NSInteger currentpage; //当前页数
@property (nonatomic, assign) NSInteger totalPage;   //总页数
@property (nonatomic, assign) CGFloat pageSize;    //每页数量
@property (nonatomic, strong) SCAssetModel *assetModel;
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@end

@implementation PVUploadProgressViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topLayout.constant = kNavBarHeight;
    self.safeViewHeightLyaout.constant = SafeAreaBottomHeight;
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewWithState) name:@"updateVideoState" object:nil];
}

- (void)reloadTableViewWithState {
    self.dataSource = [[PVDBManager sharedInstance] selectShortVideoModelAllData];
    [self.progressTableView reloadData];
}

-(void)setupNavigationBar{
    
    self.scNavigationItem.title = @"视频发布进度";
    
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


-(void)setupUI{
    
    self.progressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.progressTableView registerNib:[UINib nibWithNibName:@"PVUploadProgressCell" bundle:nil] forCellReuseIdentifier:resuPVUploadProgressCell];
    self.progressTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [self loadData];
    }];
    [self.progressTableView.mj_header beginRefreshing];
    
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
        for (SCAssetModel* model in self.dataSource) {
            model.isDelete = false;
        }
        self.progressTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.bottomContainerView.hidden = true;
        [btn setImage:[UIImage imageNamed:@"mine_btn_delete"] forState:UIControlStateNormal];
        self.progressTableView.mj_footer.hidden = NO;
    }else{
        [btn setImage:nil forState:UIControlStateNormal];
        self.progressTableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        self.bottomContainerView.hidden = false;
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
        if (self.selectAllBtn.selected) {
            self.selectAllBtn.selected = !self.selectAllBtn.selected;
            [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        self.progressTableView.mj_footer.hidden = YES;
        self.progressTableView.mj_header.hidden = YES;
    }
    [self.progressTableView reloadData];
    SCLog(@"删除");
    if (self.dataSource.count == 0) {
        self.allDeleted = NO;
    }
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
    [self.progressTableView reloadData];
}

- (void)loadData {
    
    if (self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    
    [self.progressTableView.mj_header endRefreshing];
    self.dataSource = [[PVDBManager sharedInstance] selectShortVideoModelAllData];
    if (self.dataSource.count == 0) {
        self.noDataView.hidden = NO;
    }else {
        self.noDataView.hidden = YES;
        [self.progressTableView reloadData];
    }
    
}

/**
 全选

 @param sender 全选按钮
 */
- (IBAction)selectAllButtonClick:(id)sender {
    for (SCAssetModel* model in self.dataSource) {
        if (!self.selectAllBtn.selected) {
            model.isDelete = true;
        }else{
            model.isDelete = false;
        }
    }
    
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    if (self.selectAllBtn.selected) {
        SCLog(@"-------全选---------");
        [self.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        for (SCAssetModel *model in self.dataSource) {
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
        for (SCAssetModel *model in self.dataSource) {
            model.isDelete = NO;
            if ([self.temporaryDeleteDataArray containsObject:model]) {
                [self.temporaryDeleteDataArray removeObject:model];
            }
        }
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
    }
    
    [self.progressTableView reloadData];
}


//视频上传状态， 0:压缩中，1:压缩失败，2:上传中，3:封面图上传失败，4.封面图上传成功，视频上传失败 5:视频上传成功，但是其他视频信息上传失败,6:上传成功
/**
 删除记录

 @param sender 删除按钮
 */
- (IBAction)bottomDeleteButtonClick:(id)sender {

    for (SCAssetModel *assetModel in self.temporaryDeleteDataArray) {
        if ([[PVDBManager sharedInstance] deleteShortVideoModelWithData:assetModel]) {
            [self.dataSource removeObject:assetModel];
            //上传中的视频要取消网络请求
            if ([assetModel.videoPublishState isEqualToString:@"2"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"canclePostNetwork" object:nil];
            }
        }
    }
    [self.progressTableView reloadData];
    [self showDeleteAllDataView];
}

- (void)showDeleteAllDataView {
    if ([self.bottomDeleteBtn.titleLabel.text isEqualToString:@"全部删除"]) {
        self.allDeleted = YES;
        [self rightBtnClicked:self.tabBarDeleteBtn];
        return;
    }
    if (self.dataSource.count == 0) {
        self.allDeleted = YES;
        [self rightBtnClicked:self.tabBarDeleteBtn];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVUploadProgressCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVUploadProgressCell forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //到时候取消注释
    cell.isShow = self.tabBarDeleteBtn.selected;
    cell.assetModel = self.dataSource[indexPath.row];
    
    self.temporaryDeleteDataArray = [[NSMutableArray alloc] init];
    for (SCAssetModel* model in self.dataSource) {
        if (model.isDelete) {
            [self.temporaryDeleteDataArray addObject:model];
        }
    }
    
    PV(pv)
    [cell setPVUploadProgressCellBlock:^(UIButton * btn) {
        SCAssetModel* model = pv.dataSource[indexPath.row];
        model.isDelete = btn.selected;
        NSInteger count = 0;
        
        for (SCAssetModel* model in pv.dataSource) {
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
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    return IPHONE6WH(73);
    return 73;
}
///各种点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SCAssetModel *videoModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    if (videoModel.isDelete) return;
    
    //有视频正在上传，不允许
    NSArray *assetArray = [[PVDBManager sharedInstance] selectShortVideoModelAllData];
    for (SCAssetModel *assetModel in assetArray) {
        if ([assetModel.videoPublishState isEqualToString:@"0"] || [assetModel.videoPublishState isEqualToString:@"2"]) {
            Toast(@"有视频正在上传，请稍后");
            return;
        }
    }
    
    //如果视频是找不到资源／正在压缩／正在上传，不处理
    if ([videoModel.videoPublishState isEqualToString:@"7"]) {
        Toast(@"该视频资源不存在");
        return;
    }
    
    if (videoModel.videoInfoData) {
        NSDictionary *videoInfo = [NSJSONSerialization JSONObjectWithData:videoModel.videoInfoData options:NSJSONReadingMutableLeaves error:nil];
        videoModel.videoInfo = [PVUGCVideoInfo yy_modelWithDictionary:videoInfo];
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[videoModel.assetInentifier] options:nil];
        
        //如果视频数据为0，改变视频状态
        if (fetchResult.count == 0) {
            videoModel.videoPublishState = @"7";
            if ([[PVDBManager sharedInstance] insertShortVideoModelWithModel:videoModel]) {
                [tableView reloadData];
            }
            
        }
        for (PHAsset *asset in fetchResult) {
            SCLog(@"sdfv");
            [[[PVUploadVideoTool alloc] init] compressWithAssetModel:videoModel assetModel:asset];
        }
    }else {
        Toast(@"视频信息为空，不能重新上传");
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
