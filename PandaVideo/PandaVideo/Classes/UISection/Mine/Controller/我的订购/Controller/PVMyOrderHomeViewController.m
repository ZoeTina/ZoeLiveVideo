//
//  PVMyOrderHomeViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMyOrderHomeViewController.h"
#import "PVprivilegeListTableViewCell.h"
#import "PVOrderCenterSubHeaderView.h"
#import "PVOrderDetailViewController.h"
#import "PVWebViewController.h"
#import "AppStorePurchase.h"
#import "PVOrderCenterViewController.h"

@interface PVMyOrderHomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *orderListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayout;
@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *prodoctNameLabel;
@property (nonatomic, strong) PVOrderCenterListModel *orderListModel;
@property (nonatomic, strong) PVOrderInfoModel *myOrderInfo;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *agreementUrl;
@end

@implementation PVMyOrderHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scNavigationItem.title = @"我的订购";
    [self initSubView];
    [self initSubViewData];
    [self addGesture];
    [self loadOrderData];
}

- (void)initSubView {
    self.topLayout.constant = kNavBarHeight;
    self.bottomLayout.constant = SafeAreaBottomHeight;
    [_orderTableView registerNib:[UINib nibWithNibName:@"PVprivilegeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PVprivilegeListTableViewCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"PVOrderCenterSubHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PVOrderCenterSubHeaderView"];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, 187);
    _orderTableView.tableHeaderView = self.headerView;
}

- (void)initSubViewData {
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[[PVUserModel shared].baseInfo.avatar sc_urlString]] placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"]];
    self.nameLabel.text = [PVUserModel shared].baseInfo.nickName;
    
   // PVUserModel *userModel = [PVUserModel shared];
    
    self.myOrderInfo = [[PVUserModel shared].orderInfo sc_safeObjectAtIndex:0];
    NSString *date = [[NSDate sc_dateFromString:self.myOrderInfo.expireTime withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"yyyy-MM-dd"];
    self.descLabel.text = [NSString stringWithFormat:@"%@    %@到期",self.myOrderInfo.orderName, date];
    self.prodoctNameLabel.text = [NSString stringWithFormat:@"%@特权",self.myOrderInfo.orderName];
}

- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchOrderList)];
    [self.orderListView addGestureRecognizer:tap];
}

- (void)searchOrderList {
    PVOrderDetailViewController *con = [[PVOrderDetailViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}

- (void)loadOrderData {
    [PVNetTool getDataWithUrl:orderProductionList success:^(id result) {
        [self.orderTableView.mj_header endRefreshing];
        if (result) {
            self.orderListModel = [PVOrderCenterListModel yy_modelWithDictionary:result];
            [self annlysisOrderListInfo];
            [self.orderTableView reloadData];
        }
    } failure:^(NSError *error) {
        if (error) {
            [self.orderTableView.mj_header endRefreshing];
            Toast(@"订购信息获取失败");
        }
    }];
}

- (void)annlysisOrderListInfo {
    for (PVOrderCenterModel *orderInfo in self.orderListModel.orderList) {
        for (OrderInfoModel *infoModel in orderInfo.orderInfo) {
            if (infoModel.orderId == self.myOrderInfo.orderId.integerValue) {
                for (PrivilegeModel *privilegeModel in orderInfo.privilegeList) {
                    [self.dataArray addObject:privilegeModel];
                }
                self.agreementUrl = orderInfo.agreementUrl;
                [self.orderTableView reloadData];
            }
        }
        
    }
}
/**
 续订

 @param sender 续订按钮
 */
- (IBAction)repeatOrderButtonClick:(id)sender {
//   [[AppStorePurchase shareStoreObserver] paymentStartWithProductId:[NSString stringWithFormat:@"%ld",(long)self.myOrderInfo.orderId]];
    PVOrderCenterViewController *vc = [[PVOrderCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 查看服务协议

 @param sender 服务协议按钮
 */
- (IBAction)protocolButtonClick:(id)sender {
    PVWebViewController *webCon = [[PVWebViewController alloc] initWebViewControllerWithWebUrl:self.agreementUrl webTitle:@"熊猫视频订购服务协议"];
    [self.navigationController pushViewController:webCon animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVprivilegeListTableViewCell *privilegeCell = [tableView dequeueReusableCellWithIdentifier:@"PVprivilegeListTableViewCell" forIndexPath:indexPath];
    privilegeCell.privilageModel = [self.dataArray sc_safeObjectAtIndex:indexPath.row];
    privilegeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return privilegeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.purchaseButton.layer.masksToBounds = YES;
    self.purchaseButton.layer.cornerRadius = self.purchaseButton.sc_height / 2.;
    self.purchaseButton.layer.borderWidth = 1;
    self.purchaseButton.layer.borderColor = [UIColorHexString(0x2AB4E4) CGColor];
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.sc_height / 2.;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
