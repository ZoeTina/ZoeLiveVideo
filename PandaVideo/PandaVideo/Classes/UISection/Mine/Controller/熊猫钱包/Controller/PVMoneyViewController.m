//
//  PVMoneyViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMoneyViewController.h"
#import "PVMoneyHeaderView.h"
#import "PVMoneyTableViewCell.h"
#import "PVRechargeViewController.h"
#import "PVConsumptionViewController.h"
#import "PVPackageListModel.h"
#import "AppStorePurchase.h"

static NSString* resuPVMoneyHeaderView = @"resuPVMoneyHeaderView";
static NSString* resuPVMoneyTableViewCell = @"resuPVMoneyTableViewCell";

@interface PVMoneyViewController () <UITableViewDataSource,UITableViewDelegate>

///设置tableview
@property(nonatomic, strong)UITableView* moneyTableView;
///数据源
//@property(nonatomic, strong)NSMutableArray* dataSource;
@property (nonatomic, strong) PVPackageListModel *packageListModel;

@end

@implementation PVMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"喵币钱包";
    self.automaticallyAdjustsScrollViewInsets = false;
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self.view insertSubview:self.moneyTableView belowSubview:self.scNavigationBar];
    
    UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"  钱包明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor: [UIColor sc_colorWithHex:0x000000] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(0, 0, 80, 40);
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]  initWithCustomView:rightBtn];
    self.scNavigationItem.rightBarButtonItem = rightItem;
    
}

- (void)loadData {
    [PVNetTool getDataWithUrl:chargeProducationList success:^(id result) {
        [self.moneyTableView.mj_header endRefreshing];
        if (result) {
            self.packageListModel = [PVPackageListModel yy_modelWithDictionary:result];
            [self.moneyTableView reloadData];
        }
    } failure:^(NSError *error) {
        if (error) {
            Toast(@"获取充值信息失败");
            [self.moneyTableView.mj_header endRefreshing];
        }
    }];
}

-(void)rightBtnClicked{
    
    PVConsumptionViewController* vc = [[PVConsumptionViewController alloc]  init];
    [self.navigationController pushViewController:vc animated:true];
    NSLog(@"-----钱包明细------");
}

/// MARK:- ========== UITableViewDelegate,UITableViewDataSource ========
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.packageListModel.packageList.count;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PVMoneyHeaderView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVMoneyHeaderView];
    [headerView loadData];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVMoneyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVMoneyTableViewCell forIndexPath:indexPath];
    cell.packageModel = [self.packageListModel.packageList sc_safeObjectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return IPHONE6WH(80);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6WH(50);
}
///各种点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PVAlertModel *model = [[PVAlertModel alloc] init];
    model.cancleButtonName = @"暂不";
    model.eventName = @"购买";
    model.alertType = OnlyText;
    model.descript = @"是否要购买产品";
    PVFamilyCircleAlertControlelr *controller = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:model];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    
    __weak PVFamilyCircleAlertControlelr *weakAlertCon = controller;
    PV(pv);
    
    PVPackageModel *packageModel = [self.packageListModel.packageList sc_safeObjectAtIndex:indexPath.row];
    [controller setAlertViewSureEventBlock:^(id sender) {
        [weakAlertCon dismissViewControllerAnimated:YES completion:nil];
        [[AppStorePurchase shareStoreObserver] setAppStorePurchaseBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                [pv.moneyTableView reloadData];
            }
        }];
        [[AppStorePurchase shareStoreObserver] paymentStartWithProductId:[NSString stringWithFormat:@"%d",packageModel.packageId]];
    }];
    
}
// MARK:- ====================== 懒加载 ======================
-(UITableView *)moneyTableView{
    if (!_moneyTableView) {
        _moneyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _moneyTableView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0);
        _moneyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _moneyTableView.showsVerticalScrollIndicator = false;
        [_moneyTableView registerNib:[UINib nibWithNibName:@"PVMoneyHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:resuPVMoneyHeaderView];
        [_moneyTableView registerNib:[UINib nibWithNibName:@"PVMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVMoneyTableViewCell];
        _moneyTableView.delegate = self;
        _moneyTableView.dataSource = self;
        _moneyTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _moneyTableView.sectionFooterHeight = 1.0;
        _moneyTableView.sectionHeaderHeight = 1.0;
        _moneyTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
            [self loadData];
        }];
        [_moneyTableView.mj_header beginRefreshing];
    }
    return _moneyTableView;
}
//-(NSMutableArray *)dataSource{
//    if (!_dataSource) {
//        _dataSource = [[NSMutableArray alloc] init];
//    }
//    return _dataSource;
//}
@end
