//
//  PVFamilyDetailViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyDetailViewController.h"
#import "PVModifyUserInfoViewController.h"
#import "PVInviteFamilyViewController.h"
#import "PVFamilyModel.h"
#import "PVFamilyMemberTableViewCell.h"
#import "PVFamilyInfoModel.h"
#import "PVModifyFamilyNameViewController.h"
@interface PVFamilyDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableViewCell *nickCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *familyNameCell;
@property (strong, nonatomic) IBOutlet UIView *footerView;
//@property (nonatomic, strong) UIView *headerView;
@property (strong, nonatomic) UITableView *familytableView;
@property (weak, nonatomic) IBOutlet UIButton *existFamilyCenterbutton;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *familyCenterNameLabel;
@property (nonatomic,strong)PVFamilyInfoModel *infoModel;
@property (nonatomic,strong)NSMutableArray *familyArray;
@end

@implementation PVFamilyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRequest];
    self.familytableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [self loadRequest];
    }];
    [self initView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRequest) name:FamilyGroupNameChange object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)loadRequest{
  
    PV(weakSelf);
    if ([PVUserModel shared].baseInfo.phoneNumber.length  < 1) {
        [weakSelf.familytableView.mj_header endRefreshing];
        return;
    }
    [PVNetTool postDataWithParams:@{@"phone":[PVUserModel shared].baseInfo.phoneNumber} url:getFamilyInfo success:^(id result) {
        [weakSelf.familytableView.mj_header endRefreshing];
        if (result) {
            weakSelf.infoModel = [PVFamilyInfoModel yy_modelWithJSON:result[@"data"]];
            weakSelf.scNavigationItem.title = weakSelf.infoModel.familyName;
            [weakSelf updateFamilyData];
        }
    } failure:^(NSError *error) {
        [weakSelf.familytableView.mj_header endRefreshing];
    }];
    
}
//更新家庭圈数据
- (void)updateFamilyData{
    [self.familyArray removeAllObjects];
    for (PVFamilyInfoListModel * model in self.infoModel.familyMemberList) {
        [self.familyArray addObject:model];
    }
    self.nickNameLabel.text = self.infoModel.myNickName;
    self.familyCenterNameLabel.text = self.infoModel.familyName;;
    [self.familytableView reloadData];
}


- (void)initView {
     [self.view addSubview:self.familytableView];
    UITapGestureRecognizer *existFaimlyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(existFamilyCenter)];
    [self.footerView addGestureRecognizer:existFaimlyTap];
}

//添加更多家庭成员
- (void)addMoremember {
    
    PVInviteFamilyViewController* vc = [[PVInviteFamilyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
    SCLog(@"-----添加更多成员---------");
}

- (void)existFamilyCenter {
    PV(pv);
    if ([PVFamilyModel shared].familyregidterArray.count == 1) {
        [self showLastmemberAlert];
    }else {
    
    PVAlertModel *model = [[PVAlertModel alloc] init];
    model.descript = @"退出家庭圈";
    model.cancleButtonName = @"暂不";
    model.eventName = @"确定";
    model.alertType = OnlyText;
    PVFamilyCircleAlertControlelr *controller = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:model];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    
    __weak PVFamilyCircleAlertControlelr *weakAlertCon = controller;
    
    [controller setAlertViewSureEventBlock:^(id sender) {
//        [[PVFamilyModel shared].familyregidterArray removeLastObject];
        [pv exitFamilyRequest:weakAlertCon];
        
    }];
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    }
}

- (void)exitFamilyRequest:(PVFamilyCircleAlertControlelr *)viewController{
    NSString * familyId = [NSString sc_stringForKey:MyFamilyGroupId];
    if (familyId.length < 1) {
        return;
    }
    PV(pv);
     __weak PVFamilyCircleAlertControlelr *weakAlertCon = viewController;
    [PVNetTool postDataWithParams:@{@"phone":[PVUserModel shared].baseInfo.phoneNumber,@"familyId":familyId} url:exitFamily success:^(id result) {
        NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:result url:login];
        if (errorMsg.length > 0) {
            Toast(errorMsg);
            return ;
        }
        [weakAlertCon dismissViewControllerAnimated:YES completion:nil];
        [NSString sc_removeObjectForKey:MyFamilyGroupId];
        [pv.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        Toast(@"服务器链接失败");
         [weakAlertCon dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)showLastmemberAlert {
    PV(pv);
    
    PVAlertModel *model = [[PVAlertModel alloc] init];
    model.descript = @"你是最后一个家庭成员，退出后此家庭圈和圈里所有资料将会删除";
    model.cancleButtonName = @"暂不";
    model.eventName = @"确定";
    model.alertType = OnlyText;
    PVFamilyCircleAlertControlelr *controller = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:model];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    
    __weak PVFamilyCircleAlertControlelr *weakAlertCon = controller;
    //    [controller setAlertCancleEventBlock:^(id sender) {
    //        [weakAlertCon dismissViewControllerAnimated:YES completion:nil];
    //    }];
    
    [controller setAlertViewSureEventBlock:^(id sender) {
        [pv exitFamilyRequest:weakAlertCon];
        
    }];
    [self.navigationController presentViewController:controller animated:NO completion:nil];
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"PVFamilyMemberTableViewCell";
        PVFamilyMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[PVFamilyMemberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
       [cell tableViewDataSource:self.familyArray];
        PV(weakSelf);
        cell.addFamilyBlock = ^{
            [weakSelf addMoremember];
        };
        return cell;
        
    }
    if (indexPath.section == 1) {
        self.nickCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.nickCell;
    }
    if (indexPath.section == 2) {
        self.familyNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.familyNameCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PV(pv);
    if (indexPath.section == 1) {
        
        PVModifyFamilyNameViewController *view = [[PVModifyFamilyNameViewController alloc] init];
        view.tabBarTitle = @"我的家族昵称";
        view.modifyType = FamilyModifyTypeNickName;
        view.nickname = self.nickNameLabel.text;
        view.block = ^(NSString *text) {
            pv.nickNameLabel.text = text;
        };
        [self.navigationController pushViewController:view animated:YES];
//        [self.navigationController presentViewController:view animated:YES completion:^{
//            YYLog(@"个人信息修改");
//        }];
    }
    if (indexPath.section == 2) {
        PVModifyFamilyNameViewController *view = [[PVModifyFamilyNameViewController alloc] init];
        view.tabBarTitle = @"圈昵称";
        view.modifyType = FamilyModifyTypeFamilyName;
        view.nickname = self.familyCenterNameLabel.text;
        view.block = ^(NSString *text) {
            pv.familyCenterNameLabel.text = text;
            pv.scNavigationItem.title = text;
        };
        [self.navigationController pushViewController:view animated:YES];
//        [self.navigationController presentViewController:view animated:YES completion:^{
//            YYLog(@"个人信息修改");
//        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self cellHeight];
    }
    if (indexPath.section == 1) {
        return 0;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 17;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4;
}

//获取到第一个单元格的高度
- (CGFloat)cellHeight{
    NSInteger row = 1;
    if ((self.familyArray.count + 1) % 5 == 0) {
        row = (self.familyArray.count + 1) / 5;
    }else{
        row = (self.familyArray.count + 1 + (5 - (self.familyArray.count + 1) % 5)) / 5;
    }
    return (IPHONE6WH(22) + IPHONE6WH(77) * row + (row - 1) * 10 + 5);
}

- (UITableView *)familytableView {
    if (!_familytableView) {
        _familytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _familytableView.delegate = self;
        _familytableView.dataSource = self;
        _familytableView.backgroundColor = UIColorHexString(0xf2f2f2);
        _familytableView.sectionHeaderHeight = 4;
        _familytableView.sectionFooterHeight = 100;
        
        _familytableView.tableFooterView = self.footerView;
//        self.footerView.userInteractionEnabled = NO;
    }
    return _familytableView;
}

- (NSMutableArray *)familyArray{
    if (_familyArray == nil) {
        _familyArray = [NSMutableArray array];
    }
    return _familyArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
