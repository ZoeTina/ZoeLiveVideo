//
//  PVOrderCenterViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVOrderCenterViewController.h"
#import "PVOrderCenterModel.h"
#import "PVSubCenterTableViewCell.h"
#import "PVOrderDetailViewController.h"
#import <StoreKit/StoreKit.h>
#import "PVOrderCenterHeaderView.h"
#import "AppStorePurchase.h"
#import "PVLoginViewController.h"
#import "PVOrderCenterListTableViewCell.h"
//#import "PVBaseWebViewController.h"
#import "PVWebViewController.h"

static NSString* resuPVOrderCenterTableViewCell = @"resuPVOrderCenterTableViewCell";
static NSString* resuPVSubCenterTableViewCell = @"resuPVSubCenterTableViewCell";

@interface PVOrderCenterViewController () <UITableViewDataSource,UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver, PVOrderCenterListTableViewProtocolDelegate>

///设置tableview
@property(nonatomic, strong)UITableView* orderCenterTableView;
///数据源
//@property(nonatomic, strong)NSMutableArray* dataSource;

@property (nonatomic, strong) SKProductsRequest *skRequest;

@property (nonatomic, strong) PVOrderCenterListModel *orderListModel;
@property (nonatomic, strong) PVOrderCenterHeaderView *headerView;

@end

@implementation PVOrderCenterViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginState) name:@"changeLoginState" object:nil];
}


-(void)setupNavigationBar{
    self.scNavigationItem.title = @"订购中心";
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self.view insertSubview:self.orderCenterTableView belowSubview:self.scNavigationBar];
}

- (void)changeLoginState {
    [self.headerView initSubView];
    [self.orderCenterTableView reloadData];
}

- (void)loadOrderData {
    [PVNetTool getDataWithUrl:orderProductionList success:^(id result) {
        [self.orderCenterTableView.mj_header endRefreshing];
        if (result) {
            self.orderListModel = [PVOrderCenterListModel yy_modelWithDictionary:result];
            SCLog(@"%@",self.orderListModel);
            [self.orderCenterTableView reloadData];
        }
    } failure:^(NSError *error) {
        if (error) {
            [self.orderCenterTableView.mj_header endRefreshing];
            Toast(@"订购信息获取失败");
        }
    }];
}

/// MARK:- ========== UITableViewDelegate,UITableViewDataSource ========
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderListModel.orderList.count;
//    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVOrderCenterListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PVOrderCenterListTableViewCell"];
    if (cell == nil) {
        cell = [[PVOrderCenterListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PVOrderCenterListTableViewCell"];
    }
    cell.protocolDelegate = self;
    cell.backgroundColor = [UIColor yellowColor];
//    cell.orderModel = [self.orderListModel.orderList sc_safeObjectAtIndex:0];
    cell.orderModel = [self.orderListModel.orderList sc_safeObjectAtIndex:indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)orderProtocolClick {
    PVWebViewController *baseVC = [[PVWebViewController alloc] initWebViewControllerWithWebUrl:@"http://app.sctv.com/tv/info/201711/t20171128_3683631.shtml" webTitle:@"熊猫视频订购服务协议"];
    [self.navigationController pushViewController:baseVC animated:YES];
}

- (void)purchaseOrderButtonClick {
    PVLoginViewController *loginCon = [[PVLoginViewController alloc] init];
    [self.navigationController pushViewController:loginCon animated:YES];
}

///各种点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVOrderCenterModel *model = [self.orderListModel.orderList sc_safeObjectAtIndex:indexPath.section];
    CGFloat height = (53 + 53)* self.orderListModel.orderList.count;
    if (model.orderInfo.count > 0) {
        height += 50 * model.orderInfo.count;
    }
    if (model.privilegeList.count > 0) {
        height += 60 * model.privilegeList.count;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (BOOL)isLogin {
    if ([PVUserModel shared].userId.length == 0) {
        return NO;
    }
    return YES;
}

// MARK:- ====================== 懒加载 ======================
-(UITableView *)orderCenterTableView{
    if (!_orderCenterTableView) {
        _orderCenterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _orderCenterTableView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, SafeAreaBottomHeight, 0);
        
        _orderCenterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderCenterTableView.showsVerticalScrollIndicator = false;
        [_orderCenterTableView registerNib:[UINib nibWithNibName:@"PVOrderCenterListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PVOrderCenterListTableViewCell"];
        _orderCenterTableView.delegate = self;
        _orderCenterTableView.dataSource = self;
        _orderCenterTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        self.headerView = [[PVOrderCenterHeaderView alloc] initOrderCenterViewWithFrame:CGRectMake(0, 0, kScreenWidth, IPHONE6WH(79))];
        _orderCenterTableView.tableHeaderView = self.headerView;
        PV(pv);
        _orderCenterTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
            [pv loadOrderData];
        }];
        [_orderCenterTableView.mj_header beginRefreshing];
        
        [self.headerView setPVOrderCenterHeaderViewBlock:^(id sender) {
            PVLoginViewController *login = [[PVLoginViewController alloc] init];
            [pv.navigationController pushViewController:login animated:YES];
        }];
    }
    return _orderCenterTableView;
}



@end


