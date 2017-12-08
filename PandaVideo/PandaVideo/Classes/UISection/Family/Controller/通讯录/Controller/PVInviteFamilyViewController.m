//
//  PVInviteFamilyViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInviteFamilyViewController.h"
#import "PVInviteFamilyTableViewCell.h"
#import "PVInviteFamilyHeaderView.h"
#import "PVInviteValidationViewController.h"
#import "PVTongxunluViewController.h"
#import "PVFamilyModel.h"
#import "LZChineseSort.h"
#import "PVFamilyInviteModel.h"

static NSString *CellIdentifier = @"PVInviteFamilyTableViewCell";
@interface PVInviteFamilyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

/** 设置tableview */
@property (nonatomic, strong) UITableView *lzTableView;
/** 通讯录数据源 */
@property (nonatomic, strong) NSMutableArray *itemModelArray;
/** 上传后台的联系人数组 */
@property (nonatomic, strong) NSMutableArray *contractArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) IBOutlet UIView *headerView;

/** 通讯录按钮 */
@property (weak, nonatomic) IBOutlet UIButton *tongxunluBtn;
/** 邀请按钮 */
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
/** 手机号输入框 */
@property (weak, nonatomic) IBOutlet UITextField *telTextField;

/** <排序后的整个数据源> */
@property (strong, nonatomic) NSDictionary *letterResultDictionary;
/** <索引数据源> */
@property (strong, nonatomic) NSArray *indexArray;
//页数
@property (nonatomic, assign) NSInteger index;
//每页请求量
@property (nonatomic, assign) NSInteger pageSize;
//总页数
@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, strong) PVFamilyInviteListModel *inviteListModel;

@end

@implementation PVInviteFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    self.telTextField.delegate =self;
    self.telTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self loadAddressBook];
}

#pragma mark - -------
- (void)loadAddressBook {
    // 模拟数据
    //    _itemModelArray = [PVTongxunluModel getModelData];
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (delegate.dataArray.count>0) {
        _itemModelArray = delegate.dataArray;
        _letterResultDictionary = [LZChineseSort sortAndGroupForArray:_itemModelArray PropertyName:@"name"];
        _indexArray = [LZChineseSort sortForStringAry:[_letterResultDictionary allKeys]];
//        [self.lzTableView reloadData];
    }else{
        YYLog(@"没有数据");
    }
}

- (void)loadData {
    if (self.itemModelArray.count == 0) {
        [self.lzTableView.mj_header endRefreshing];
        Toast(@"暂无手机联系人");
        return;
    }
    NSDictionary *dict = @{@"phone":[PVUserModel shared].userId};
    [PVNetTool postDataWithParams:dict url:getFamilyInvite success:^(id result) {
        [self.lzTableView.mj_header endRefreshing];
        if (result) {
            if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                self.inviteListModel = [PVFamilyInviteListModel yy_modelWithDictionary:[result pv_objectForKey:@"data"]];
            }
        }
    } failure:^(NSError *error) {
        [self.lzTableView.mj_header endRefreshing];
        Toast(@"获取家庭圈邀请列表失败");
    }];
    
  
}


- (void)analysisContractDataWithResponseArray:(NSArray *)responseArray uploadArray:(NSMutableArray *)contractArray {
    for (NSDictionary *dict in responseArray) {
        for (PVTongxunluModel *tongXunModel in contractArray) {
            if ([tongXunModel.phone isEqualToString:[dict pv_objectForKey:@"phone"]]) {
                tongXunModel.state = [[dict pv_objectForKey:@"state"] integerValue];
                [self.dataArray addObject:tongXunModel];
            }
        }
    }
    [self.lzTableView reloadData];
}

- (void) initView {
    
    [self.view addSubview:self.lzTableView];
    self.headerView.frame = CGRectMake(0, kNavBarHeight, kScreenWidth, 90);
//    self.lzTableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_offset(kNavBarHeight);
        make.height.mas_equalTo(90);
    }];
    [self.tongxunluBtn addTarget:self action:@selector(tongxunluOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteBtn addTarget:self action:@selector(inviteOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 圆角设置
    [self.inviteBtn setBordersWithColor:kColorWithRGB(42, 180, 228)
                           cornerRadius:self.inviteBtn.sc_height/2
                            borderWidth:0.5];
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"邀请家人";
}

- (void) tongxunluOnClick:(UIButton *) sender{
    
    Toast(@"通讯录");
    PVTongxunluViewController *view = [[PVTongxunluViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

- (void) inviteOnClick:(UIButton *) sender{

    if (self.telTextField.text.length == 0) {
        Toast(@"请输入电话号码");
        return;
    }
    
    if (![SCSmallTool checkTelNumber:self.telTextField.text]) {
        Toast(@"请输入正确的电话号码");
        return;
    }
    if ([self.telTextField.text isEqualToString: [PVUserModel shared].baseInfo.phoneNumber]) {
        Toast(@"您不能邀请自己，谢谢");
        return;
    }
    PVInviteValidationViewController * vc = [[PVInviteValidationViewController alloc] init];
    vc.targetPhone = self.telTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController pushViewController:vc animated:YES];
//     [[PVFamilyModel shared] load];
//
//    if (![[PVFamilyModel shared].familyregidterArray containsObject:self.telTextField.text]) {
//        [self phoneNumValidHelpRegist];
//    }else {
//        if (![[PVFamilyModel shared].familyArray containsObject:self.telTextField.text]) {
//         [self phoneNumInvalid];
//        }else {
//            Toast(@"已邀请过该用户");
//        }
//
//    }
    
}

/**此用户不存在，帮他注册*/
- (void)phoneNumValidHelpRegist {
//    PVAlertModel *alertModel = [[PVAlertModel alloc] init];
//    alertModel.alertType = OnlyText;
//    alertModel.cancleButtonName = @"暂不";
//    alertModel.eventName = @"帮Ta注册";
//    alertModel.descript = @"此用户不存在，你可以用此手机号帮他注册熊猫号";
//    PVFamilyCircleAlertControlelr *con = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:alertModel];
//    con.modalPresentationStyle = UIModalPresentationCustom;
//    [self.navigationController presentViewController:con animated:YES completion:nil];
//    __weak PVFamilyCircleAlertControlelr *weakCon = con;
//    PV(pv);
//    [con setAlertViewSureEventBlock:^(id sender) {
//        [weakCon dismissViewControllerAnimated:YES completion:nil];
//        PVHelpRegistViewController *con = [[PVHelpRegistViewController alloc] init];
//        con.telephone = pv.telTextField.text;
//        [pv.navigationController pushViewController:con animated:YES];
//    }];
}

- (void)phoneNumInvalid {
    PVAlertModel *alertModel = [[PVAlertModel alloc] init];
    alertModel.alertType = OnlyText;
    alertModel.cancleButtonName = @"知道了";
    alertModel.eventName = @"打电话";
    alertModel.descript = @"给对方打个电话吧，以便快速接受你的邀请";
    alertModel.alertTitle = @"邀请发送成功";
    PVFamilyCircleAlertControlelr *con = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:alertModel];
    con.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:con animated:YES completion:nil];
    __weak PVFamilyCircleAlertControlelr *weakCon = con;

    [con setAlertViewSureEventBlock:^(id sender) {
        [weakCon dismissViewControllerAnimated:YES completion:nil];
//        PVHelpRegistViewController *con = [[PVHelpRegistViewController alloc] init];
//        [pv.navigationController pushViewController:con animated:YES];
    }];
}

- (void)showShareAlertView {
    PVAlertModel *alertModel = [[PVAlertModel alloc] init];
    alertModel.alertType = BottomAlert;
    
    NSMutableArray *iconsImagesArray = [[NSMutableArray alloc] init];
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
   
    //判断微信是否安装
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
        [iconsImagesArray addObject:@"mine_btn_wechat"];
        [namesArray addObject:@"微信"];
    }
    [iconsImagesArray addObject:@"live_btn_msg"];
    [namesArray addObject:@"短信"];
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
        [iconsImagesArray addObject:@"mine_btn_qq"];
        [namesArray addObject:@"QQ好友"];
    }
    
    [iconsImagesArray addObject:@"mine_icon_phone"];
    [namesArray addObject:@"打电话"];
    alertModel.imagesArray = iconsImagesArray;
    alertModel.imagesTextArray = namesArray;
    PVFamilyCircleAlertControlelr *controller = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:alertModel];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PVInviteFamilyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.contractModel = [self.dataArray sc_safeObjectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PVTongxunluModel *model = [self.dataArray sc_safeObjectAtIndex:indexPath.row];
    if (model.state == 0) {
        [self showShareAlertView];
    }
}
/// MARK:- ====================== 懒加载 ======================
-(UITableView *)lzTableView{
    if (!_lzTableView) {
        
        _lzTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 90, kScreenWidth, kScreenHeight - kNavBarHeight - SafeAreaBottomHeight - 90) style:UITableViewStylePlain];
        _lzTableView.showsVerticalScrollIndicator = false;
        [_lzTableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil]
           forCellReuseIdentifier:CellIdentifier];
        [_lzTableView setSeparatorInset:UIEdgeInsetsMake(13,0,0,0)];
        _lzTableView.delegate = self;
        _lzTableView.dataSource = self;
        _lzTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _lzTableView.separatorStyle = UITableViewCellSeparatorStyleNone;;
        _lzTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
            [self loadData];
        }];
        [_lzTableView.mj_header beginRefreshing];
    }
    return _lzTableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location + string.length > 11) {
        return NO;
    }
    return YES;
}
@end
