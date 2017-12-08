//
//  PVLookOrdermanagerViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLookOrdermanagerViewController.h"
#import "PVHistoryModel.h"
#import "PVLookOrderManagerCell.h"
#import "PVTeleCloudVideoModel.h"

static NSString* resuPVRecordTableViewCell = @"PVLookOrderManagerCell";

@interface PVLookOrdermanagerViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomDeleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIView *deleteContainerView;
@property (nonatomic, strong)UIButton* tabBarDeleteBtn;
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) NSMutableArray *temporaryDeleteDataArray;
@property (nonatomic, assign) BOOL haveNoMoreData;

@property (nonatomic,assign)NSInteger currentIndex;//从第几个开始
@property(nonatomic,assign)NSIndexPath * oldIndexPath;
@property(nonatomic,strong)PVTeleCloudVideoListModel * oldModel;

@end

@implementation PVLookOrdermanagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self initUI];
    self.currentIndex = 0;
    PV(weakSelf);
    self.orderTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        weakSelf.orderTableView.mj_footer.hidden = YES;
        weakSelf.currentIndex = 0;
        [weakSelf loadRequest];
    }];
    [self.orderTableView.mj_header beginRefreshing];
    self.orderTableView.mj_footer = [PVAnimFooterRefresh footerWithRefreshingBlock:^{
        [weakSelf loadRequest];
    }];
    self.orderTableView.mj_footer.hidden = YES;
}

- (void)loadRequest{
    PV(weakSelf);
    if ([PVUserModel shared].baseInfo.phoneNumber.length  < 1) {
        [self endRefreash];
        return;
    }
    if (self.targetPhone.length  < 1) {
       [self endRefreash];
        return;
    }
    if ([NSString sc_stringForKey:MyFamilyGroupId].length  < 1) {
        [self endRefreash];
        return;
    }
    NSDictionary * dic = @{@"familyId":[NSString sc_stringForKey:MyFamilyGroupId],
                           @"phone":[PVUserModel shared].baseInfo.phoneNumber,
                           @"targetPhone":self.targetPhone,
                           @"index":[NSNumber numberWithInteger:weakSelf.currentIndex],
                           @"pageSize":[NSNumber numberWithInteger:pageSizeForEvery]};
    
    [PVNetTool postDataWithParams:dic url:getCloudVideoList success:^(id result) {
        if (result) {
            if (self.currentIndex < 1) {
                [self.dataSource removeAllObjects];
            }
            PVTeleCloudVideoModel * videoModel = [PVTeleCloudVideoModel yy_modelWithJSON:result[@"data"]];
            [self.dataSource addObjectsFromArray:videoModel.cloudVideoList];
            if (videoModel.cloudVideoList.count < pageSizeForEvery) {
                if (self.currentIndex > 0) {
                    [weakSelf.orderTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                if (self.currentIndex <= 0) {
                    weakSelf.orderTableView.mj_footer.hidden = NO;
                }
                weakSelf.currentIndex = weakSelf.currentIndex + self.dataSource.count;
            }
            [weakSelf.orderTableView reloadData];
        }
        [weakSelf endRefreash];
        
    }failure:^(NSError *error) {
       [weakSelf endRefreash];
       [weakSelf.orderTableView reloadData];
    }];
    
}
//结束刷新
- (void)endRefreash{
    if (self.currentIndex < 1) {
        [self.orderTableView.mj_header endRefreshing];
    }else{
        [self.orderTableView.mj_footer endRefreshing];
    }
}

- (void)initUI {
    self.scNavigationItem.title = @"云看单管理";
    self.topLayout.constant = kNavBarHeight;
    self.orderTableView.backgroundColor =[UIColor clearColor];
    self.orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.orderTableView registerNib:[UINib nibWithNibName:resuPVRecordTableViewCell bundle:nil] forCellReuseIdentifier:resuPVRecordTableViewCell];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.orderTableView addGestureRecognizer:longPress];
    
//    if (@available(iOS 11.0, *)) {
//        self.orderTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//    else
//    {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//
//    }
}

- (void)setNavigationBar {
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

/** 右侧删除按钮，没有选择数据，底部删除按钮没有点击事件 */
-(void)rightBtnClicked:(UIButton*)btn{
    
    if (self.dataSource.count == 0) return;
    
    btn.selected = !btn.selected;
    if (!btn.selected) {
        for (PVHistoryModel* model in self.dataSource) {
            model.isDelete = false;
        }
        self.orderTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.deleteContainerView.hidden = true;
        [btn setImage:[UIImage imageNamed:@"mine_btn_delete"] forState:UIControlStateNormal];
        self.orderTableView.mj_footer.hidden = NO;
        [self.temporaryDeleteDataArray removeAllObjects];
    }else{
        [btn setImage:nil forState:UIControlStateNormal];
        self.orderTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        self.deleteContainerView.hidden = false;
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
        if (self.selectAllBtn.selected) {
            self.selectAllBtn.selected = !self.selectAllBtn.selected;
            [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        self.orderTableView.mj_footer.hidden = YES;
    }
    [self.orderTableView reloadData];
    SCLog(@"删除");
}

- (IBAction)selectAllBtnClick:(UIButton *)sender {
    for (PVHistoryModel* model in self.dataSource) {
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
        for (PVHistoryModel *model in self.dataSource) {
            model.isDelete = YES;
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
        }
        [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [self setBottomDeleteButtonTitleWithTitle:@"删除"];
    }
    
    [self.orderTableView reloadData];
}

//删除云看单
- (IBAction)deleteBtnClick:(id)sender {
    PV(weakSelf);
    if ([PVUserModel shared].baseInfo.phoneNumber.length  < 1) {
        return;
    }
    if (self.targetPhone.length  < 1) {
        return;
    }
    if ([NSString sc_stringForKey:MyFamilyGroupId].length  < 1) {
        return;
    }
    NSString * videoIds = @"";
     for (PVTeleCloudVideoListModel* model in self.temporaryDeleteDataArray) {
         videoIds = (videoIds.length < 1) ? model.videoId : [NSString stringWithFormat:@"%@,%@",videoIds,model.videoId];
    }
    NSDictionary * dic = @{@"familyId":[NSString sc_stringForKey:MyFamilyGroupId],
                           @"phone":[PVUserModel shared].baseInfo.phoneNumber,
                           @"targetPhone":self.targetPhone,
                           @"videoIds":videoIds};
    [PVNetTool postDataWithParams:dic url:deleteCloudVideo success:^(id result) {
        NSString * errorMsg = result[@"errorMsg"];
        if (errorMsg.length > 0) {
          Toast(errorMsg);
            return ;
        }
        [weakSelf.dataSource removeObjectsInArray:self.temporaryDeleteDataArray];
        [weakSelf.orderTableView reloadData];
        [self.temporaryDeleteDataArray removeAllObjects];
    } failure:^(NSError *error) {
        Toast(@"删除失败，请重试");
    }];
    
}


/// MARK:- ====== UITableViewDelegate,UITableViewDataSource ==========

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(self.dataSource.count, 0) ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVLookOrderManagerCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVRecordTableViewCell forIndexPath:indexPath];
    
    cell.isShow = self.tabBarDeleteBtn.selected;
    cell.model = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.temporaryDeleteDataArray = [[NSMutableArray alloc] init];
    for (PVTeleCloudVideoListModel* model in self.dataSource) {
        if (model.isDelete) {
            [self.temporaryDeleteDataArray addObject:model];
        }
    }
    
    PV(pv)
    [cell setPVLookOrderManagerCellBlock:^(UIButton * btn) {
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
//        [tableView reloadData];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6WH(63);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
///各种点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
//    [self.orderTableView reloadData];
}

#pragma mark -tableViewCell长按手势移动
- (void)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:_orderTableView];
    NSIndexPath *indexPath = [_orderTableView indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                self.oldIndexPath = indexPath;
                self.oldModel  = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
                PVLookOrderManagerCell *cell = [_orderTableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [_orderTableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    cell.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    cell.hidden = YES;
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                [self.dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                // ... move the rows.
                [self.orderTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
                // ... update data source.
               
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            
             [self upateChange:self.oldIndexPath targetSort:sourceIndexPath];
            PVLookOrderManagerCell *cell = [_orderTableView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                cell.alpha = 1.0f;
            } completion:^(BOOL finished) {
                cell.hidden = NO;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
        }
            break;
        default: {
            // Clean up.
            
            break;
        }
    }
}

- (void)upateChange:(NSIndexPath *)indexPath  targetSort:(NSIndexPath *)sourceIndexPath{
    if ([PVUserModel shared].baseInfo.phoneNumber.length  < 1) {
        return;
    }
    if (self.targetPhone.length  < 1) {
        return;
    }
    if ([NSString sc_stringForKey:MyFamilyGroupId].length  < 1) {
        return;
    }
    if (self.oldModel.videoId.length < 1) {
        return;
    }
    NSDictionary * dic = @{@"familyId":[NSString sc_stringForKey:MyFamilyGroupId],
                           @"phone":[PVUserModel shared].baseInfo.phoneNumber,
                           @"sort":[NSNumber numberWithInteger:(indexPath.row + 1)],
                           @"targetPhone":self.targetPhone,
                           @"targetSort":[NSNumber numberWithInteger:(sourceIndexPath.row + 1)],
                           @"videoId":self.oldModel.videoId};
    [PVNetTool postDataWithParams:dic url:reorderCloudVideo success:^(id result) {
        NSString * errorMsg  = result[@"errorMsg"];
        if (errorMsg.length > 0) {
            Toast(errorMsg);
            return ;
        }
        // ... and update source so it is in sync with UI changes.
    } failure:^(NSError *error) {
        Toast(@"移动位置失败，请刷新列表重试");
    }];
}

#pragma mark - Helper methods

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    UIView* snapshot = nil;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7.0) {
        //ios7.0 以下通过截图形式保存快照
        snapshot = [self customSnapShortFromViewEx:inputView];
    }else{
        //ios7.0 系统的快照方法
        snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    }
    
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (UIView *)customSnapShortFromViewEx:(UIView *)inputView
{
    CGSize inSize = inputView.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(inSize, NO, [UIScreen mainScreen].scale);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* snapshot = [[UIImageView alloc] initWithImage:image];
    
    return snapshot;
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
