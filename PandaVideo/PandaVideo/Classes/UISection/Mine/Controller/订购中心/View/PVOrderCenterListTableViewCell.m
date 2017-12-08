//
//  PVOrderCenterListTableViewCell.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVOrderCenterListTableViewCell.h"
#import "PVprivilegeListTableViewCell.h"
#import "PVorderInfoTableViewCell.h"
#import "PVOrderCenterSubHeaderView.h"
#import "AppStorePurchase.h"

@interface PVOrderCenterListTableViewCell ()<UITableViewDataSource, UITableViewDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *orderSubTableView;
@property (nonatomic, strong) UITableView *orderSubTableView;

@end

@implementation PVOrderCenterListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setOrderModel:(PVOrderCenterModel *)orderModel {
    _orderModel = orderModel;
    [self setupUI];
    [self.orderSubTableView reloadData];
}

- (void)setupUI {
    [self.contentView addSubview:self.orderSubTableView];
    [self.orderSubTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_offset(0);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.orderModel.orderInfo.count;
    }else {
        return self.orderModel.privilegeList.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.section == 0) {
            PVorderInfoTableViewCell *orderInfoCell = [tableView dequeueReusableCellWithIdentifier:@"PVorderInfoTableViewCell" forIndexPath:indexPath];
            orderInfoCell.orderInfoModel = [self.orderModel.orderInfo sc_safeObjectAtIndex:indexPath.row];
            orderInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return orderInfoCell;
    }
        if (indexPath.section == 1) {
            PVprivilegeListTableViewCell *privilegeCell = [tableView dequeueReusableCellWithIdentifier:@"PVprivilegeListTableViewCell" forIndexPath:indexPath];
            privilegeCell.privilageModel = [self.orderModel.privilegeList sc_safeObjectAtIndex:indexPath.row];
            privilegeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return privilegeCell;

        }
        
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if ([PVUserModel shared].token.length == 0 || [PVUserModel shared].userId == 0) {
            if (self.protocolDelegate) {
                [self.protocolDelegate purchaseOrderButtonClick];
            }
        }else {
            OrderInfoModel *orderModel = [self.orderModel.orderInfo sc_safeObjectAtIndex:indexPath.row];
            [[AppStorePurchase shareStoreObserver] paymentStartWithProductId:[NSString stringWithFormat:@"%ld",(long)orderModel.orderId]];
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PVOrderCenterSubHeaderView *header = [[PVOrderCenterSubHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    if (section == 0) {
        header.title = self.orderModel.orderName;
        UITapGestureRecognizer *protocolTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocolDelegateClick)];
        [header addGestureRecognizer:protocolTap];
    }
    if (section == 1) {
        header.title = [NSString stringWithFormat:@"%@特权",self.orderModel.orderName];
    }
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    }
    if (indexPath.section == 1) {
        return 60;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 53;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)protocolDelegateClick {
    if (self.protocolDelegate) {
        [self.protocolDelegate orderProtocolClick];
    }
}

- (void)setProtocolDelegate:(id<PVOrderCenterListTableViewProtocolDelegate>)protocolDelegate {
    _protocolDelegate = protocolDelegate;
}

- (UITableView *)orderSubTableView {
    if (!_orderSubTableView) {
        _orderSubTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _orderSubTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        _orderSubTableView.backgroundColor = [UIColor whiteColor];
        [_orderSubTableView registerNib:[UINib nibWithNibName:@"PVprivilegeListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PVprivilegeListTableViewCell"];
        [_orderSubTableView registerNib:[UINib nibWithNibName:@"PVorderInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PVorderInfoTableViewCell"];
        [_orderSubTableView registerNib:[UINib nibWithNibName:@"PVOrderCenterSubHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PVOrderCenterSubHeaderView"];
        _orderSubTableView.delegate = self;
        _orderSubTableView.dataSource = self;
        _orderSubTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _orderSubTableView.scrollEnabled = NO;
//        _orderSubTableView.estimatedRowHeight = 190;
//        _orderSubTableView.estimatedSectionHeaderHeight = 50;
    }
    return _orderSubTableView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
