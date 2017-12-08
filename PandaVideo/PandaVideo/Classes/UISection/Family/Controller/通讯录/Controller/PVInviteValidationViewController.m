//
//  PVInviteValidationViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInviteValidationViewController.h"
#import "PVHelpRegistViewController.h"
@interface PVInviteValidationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

/** 设置tableview */
@property (nonatomic, strong) UITableView *lzTableView;
/** tabViewCell */
@property (nonatomic, strong) IBOutlet UITableViewCell *tableViewCell;
@property (nonatomic, strong) IBOutlet UITextField *validationTextField;
@property(nonatomic,copy)NSString * phone;
@end

@implementation PVInviteValidationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.phone = [PVUserModel shared].baseInfo.phoneNumber;
     self.validationTextField.delegate =self;
    self.validationTextField.text = [NSString stringWithFormat:@"我是%@",self.phone];
    self.validationTextField.delegate = self;
    self.validationTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self initView];
    
}

- (void) initView {
    [self.view addSubview:self.lzTableView];
    self.lzTableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 10);
    [Utils setExtraCellLineHidden:self.lzTableView];
    [self initcustomNavigationrightItem];
}

/**
 *  添加发布按钮
 */
-(void)initcustomNavigationrightItem{
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissEvent)];
    self.scNavigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(clickEvent)];
    self.scNavigationItem.rightBarButtonItem = rightBtn;
    
}

/** 发送 */
-(void)clickEvent{
    if (self.validationTextField.text.length < 1) {
        return;
    }
    if (self.phone.length < 1) {
        return;
    }
    if (self.targetPhone.length < 1) {
        return;
    }
    PV(weakSelf);
    NSString * familyId = [NSString sc_stringForKey:MyFamilyGroupId].length > 0 ? [NSString sc_stringForKey:MyFamilyGroupId] : @"";
    NSDictionary * dic = @{@"familyId":familyId,
                           @"inviteMsg":self.validationTextField.text,
                           @"phone":self.phone,
                           @"targetPhone":self.targetPhone};
    [PVNetTool postDataWithParams:dic url:sendInviteMsg success:^(id result) {
        if (result) {
            NSString * errorMsg  = result[@"errorMsg"];
            if (errorMsg.length > 0) {
                if ([errorMsg isEqualToString:@"被邀请用户未注册"] || [errorMsg isEqualToString:@"被邀请用户不存在"]) {
                    [weakSelf phoneNumValidHelpRegist];
                }else{
                Toast(errorMsg);
                }
                return ;
            }
            [weakSelf showAcceptSuccessAlertView];
//
        }
        // ... and update source so it is in sync with UI changes.
    } failure:^(NSError *error) {
        
    }];
}

/**邀请发送成功，打电话*/
- (void)showAcceptSuccessAlertView {
    PVAlertModel *model = [[PVAlertModel alloc] init];
    model.cancleButtonName = @"知道了";
    model.eventName = @"打电话";
    model.alertType = OnlyText;
    model.descript = @"通知Ta用此号码登录自己的“熊猫视频”电视端，您可为Ta点播精彩视频";
    model.alertTitle = @"帮Ta注册成功";
    PVFamilyCircleAlertControlelr *controller = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:model];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    PV(weakSelf);
    __weak PVFamilyCircleAlertControlelr *weakCon = controller;
    [controller setAlertViewSureEventBlock:^(id sender) {
        [weakCon dismissViewControllerAnimated:YES completion:nil];
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",weakSelf.targetPhone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    [controller setAlertCancleEventBlock:^(id sender) {
        [weakCon dismissViewControllerAnimated:YES completion:nil];
    }];
}


/**此用户不存在，帮他注册*/
- (void)phoneNumValidHelpRegist {
    PVAlertModel *alertModel = [[PVAlertModel alloc] init];
    alertModel.alertType = OnlyText;
    alertModel.cancleButtonName = @"暂不";
    alertModel.eventName = @"帮Ta注册";
    alertModel.descript = @"此用户不存在，你可以用此手机号帮他注册熊猫号";
    PVFamilyCircleAlertControlelr *con = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:alertModel];
    con.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:con animated:NO completion:nil];
    __weak PVFamilyCircleAlertControlelr *weakCon = con;
    PV(pv);
    [con setAlertViewSureEventBlock:^(id sender) {
        [weakCon dismissViewControllerAnimated:YES completion:nil];
        PVHelpRegistViewController *con = [[PVHelpRegistViewController alloc] init];
        con.telephone = pv.targetPhone;
        [pv .navigationController pushViewController:con animated:YES];
    }];
}

/** 取消 */
-(void)dismissEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"验证信息";
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.tableViewCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

/// MARK:- ====================== 懒加载 ======================
-(UITableView *)lzTableView{
    if (!_lzTableView) {
        
        _lzTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight - kNavBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
        _lzTableView.showsVerticalScrollIndicator = false;
        [_lzTableView setSeparatorInset:UIEdgeInsetsMake(13,0,0,0)];
        _lzTableView.delegate = self;
        _lzTableView.dataSource = self;
        _lzTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    }
    return _lzTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

