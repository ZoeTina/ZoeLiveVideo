//
//  PVPersonalInfoViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPersonalInfoViewController.h"
#import "LZActionSheet.h"
#import "LZDatePickerView.h"
#import "NSDate+LZAdd.h"
#import "PVModifyUserInfoViewController.h"
#import "PVBindingTelViewController.h"
#import "PVLoginViewController.h"
#import "LZTailoringViewController.h"
#import "LZImageManager.h"

@interface PVPersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate,LZActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *lzTableView;

@property (strong, nonatomic) IBOutlet UITableViewCell *headerImageViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *nickNameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sexCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *birthdayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *bindingTelCell;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *headerImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end

@implementation PVPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topLayout.constant = kNavBarHeight;
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.scNavigationBar.hidden = NO;
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"个人信息";
}


/**
 添加第三方登陆UI
 */
- (void)initView{

    // 分割线长度
    [self.lzTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    self.lzTableView.tableFooterView = _footerView;

    _headerImageBtn.layer.masksToBounds = YES;
    _headerImageBtn.layer.cornerRadius  = _headerImageBtn.sc_height/2;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius  = _headerImageView.sc_height/2;
    
    [_headerImageBtn addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
    [_exitButton addTarget:self action:@selector(exitClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) headClick:(UIButton *)sender{
    SCLog(@"点击头像");
}

- (void)exitClick:(UIButton *)sender{

    PVAlertModel *model = [[PVAlertModel alloc] init];
    model.cancleButtonName = @"暂不";
    model.eventName = @"退出";
    model.alertType = OnlyText;
    model.descript = @"确定要退出登录吗";
    PVFamilyCircleAlertControlelr *controller = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:model];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    
    __weak PVFamilyCircleAlertControlelr *weakAlertCon = controller;
    [controller setAlertViewSureEventBlock:^(id sender) {
        [[PVUserModel shared] logout];
        [[PVUserModel shared] dump];
        [NSString sc_removeObjectForKey:MyFamilyGroupId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserInfo" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:FamilyGroupYaoQingStateChange object:nil];
        [weakAlertCon dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    static NSString *CellIdentifier = @"PVPersonalInfoViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (section == 0) {
        
        if (row == 0) {
            [self.headerImageView sc_setImageWithUrlString:[PVUserModel shared].baseInfo.avatar placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"] isAvatar:false];
            _headerImageViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _headerImageViewCell;
        }
        if (row == 1) {
            self.nickNameLabel.text = [PVUserModel shared].baseInfo.nickName;
            _nickNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _nickNameCell;
        }
        if (row == 2) {
            if ([PVUserModel shared].baseInfo.sex == 0) {
                self.sexLabel.text = @"保密";
            }
            if ([PVUserModel shared].baseInfo.sex == 1) {
                self.sexLabel.text = @"男";
            }
            if ([PVUserModel shared].baseInfo.sex == 2) {
                self.sexLabel.text = @"女";
            }
            _sexCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _sexCell;
        }
        if (row == 3) {
            NSString *birthDay = [PVUserModel shared].baseInfo.birthday;
            if ([birthDay containsString:@":"]) {
                self.birthdayLabel.text = [[NSDate sc_dateFromString:[PVUserModel shared].baseInfo.birthday withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"yyyy-MM-dd"];
            }else {
                self.birthdayLabel.text = birthDay;
            }
            
            _birthdayCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _birthdayCell;
        }
        if (row == 4) {
    
            self.telLabel.text = [PVUserModel shared].baseInfo.phoneNumber;
            _bindingTelCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _bindingTelCell;
        }
    }
    return cell;
    
}

#pragma mark - Table view data source
//---------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

// 每个cell  高度多少
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 4) {
        
    }
    return 50;
}

#pragma mark -
#pragma mark Table View Delegate Methods
#pragma mark - 选中的哪个Cell
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger row = [indexPath row];
    if (row == 0) { // 修改头像
        [self showActionSheet];
    }
    if (row == 1) { // 修改昵称
        [self modifyUserInfo];
    }
    if (row == 2) { // 修改性别
        [self showSexActionSheet];
    }
    if (row == 3) { // 修改生日
        [self showDataPicker];
    }
    if (row == 4) { // 绑定手机
        if (self.telLabel.text.length != 0) {
            [self bindingTel];
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/** 显示头像修改弹窗 */
- (void) showActionSheet{
    
    CGFloat width = AUTOLAYOUTSIZE(294);
    PV(weakSelf);
    [[LZImageManager sharedManager] getCircleImageInVc:self
                                              withSize:CGSizeMake(width, width)
                                          withCallback:^(UIImage *image) {
                                              [weakSelf uploadImageDataWithImage:image];
        
    }];
}

- (void)uploadImageDataWithImage:(UIImage *)image {
    NSDictionary *dict = @{@"type":@(0)};
    [[PVProgressHUD shared] showHudInView:self.view];
    [PVNetTool postImageWithUrl:uploadFile parammeter:dict image:image success:^(id result) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        if ([result isKindOfClass:[NSDictionary class]]) {
            if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                NSString *imageUrl = [[result pv_objectForKey:@"data"] pv_objectForKey:@"url"];
                [self uploadHeaderImageWithImageUrl:imageUrl];
            }else {
                Toast([result pv_objectForKey:@"errorMsg"]);
                
            }
        }else {
            Toast(@"头像修改失败");
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:self.view];
    }];
}

- (void)uploadHeaderImageWithImageUrl:(NSString *)imageUrl {
    PV(weakSelf);
    
    NSDictionary *dict = @{@"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId, @"avatar":imageUrl};
    
    [[PVProgressHUD shared] showHudInView:self.view];
    [PVNetTool postDataHaveTokenWithParams:dict url:updateAvatar success:^(id responseObject) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        if (responseObject) {
        
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                NSString *imageUrl = [[responseObject pv_objectForKey:@"data"] pv_objectForKey:@"avatar"];
                [PVUserModel shared].baseInfo.avatar = imageUrl;
                [[PVUserModel shared] dump];
                [weakSelf.headerImageView sc_setImageWithUrlString:imageUrl placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"] isAvatar:false];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserInfo" object:nil];
            }else {
                NSString *errorMasg = [responseObject pv_objectForKey:@"errorMsg"];
                Toast(errorMasg);
            }
        }else {
            Toast(@"头像上传失败");
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        Toast(@"头像上传失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        Toast(@"头像上传失败");
    }];
    
}

/** 显示性别修改弹窗 */
- (void) showSexActionSheet{
    LZActionSheet *actionSheet = [[LZActionSheet alloc] initWithTitle:nil
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@[@"保密",@"男",@"女"]
                                                     actionSheetBlock:^(NSInteger buttonIndex) {
                                                         [self uploadUserSexInfoWithSex:buttonIndex];
                                                     }];
    [actionSheet show];
}

/**上传性别*/
- (void)uploadUserSexInfoWithSex:(NSInteger)sex {
    
    NSDictionary *dict = @{@"sex":@(sex), @"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId};
    
    [[PVProgressHUD shared] showHudInView:self.view];
    
    [PVNetTool postDataHaveTokenWithParams:dict url:updateSex success:^(id responseObject) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        if (responseObject) {
            
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:updateSex];
            if (errorMsg.length > 0) {
                Toast(errorMsg);
            }else {
                //这里需要改变，从字典里获取参数
                NSString *sexValue = [[responseObject pv_objectForKey:@"data"] pv_objectForKey:@"sex"];
                [PVUserModel shared].baseInfo.sex = sexValue.integerValue;
                [[PVUserModel shared] dump];
                
                if (sexValue.integerValue == 0) {
                    _sexLabel.text = @"保密";
                }else if (sexValue.integerValue == 1) {
                    _sexLabel.text = @"男";
                }else if (sexValue.integerValue == 2) {
                    _sexLabel.text = @"女";
                }
            }
            
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        Toast(@"性别信息修改失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        
    }];
    
}

/** 日期选择 */
- (void) showDataPicker{
    PV(LZ);

    NSString *currentText = [NSString new];
    if ([LZ.birthdayLabel.text isEqualToString:@"请输入您的生日"]) {
        currentText = [Utils getCurrentDate];
    }else{
        currentText = LZ.birthdayLabel.text;
    }

    /**
     *  显示时间选择器
     *
     *  @param title            标题
     *  @param type             类型（时间、日期、日期和时间、倒计时）
     *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
     *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
     *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
     *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
     *  @param resultBlock      选择结果的回调
     *
     */
    [LZDatePickerView showDatePickerWithTitle:@"出生年月" dateType:UIDatePickerModeDate defaultSelValue:currentText minDateStr:@"" maxDateStr:[NSDate currentDateString] isAutoSelect:NO resultBlock:^(NSString *selectValue) {
//        NSString *dateStr = [selectValue stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        
        NSDictionary *dict = @{@"birthday":selectValue, @"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId};
        
        [[PVProgressHUD shared] showHudInView:self.view];
        
        [PVNetTool postDataHaveTokenWithParams:dict url:updateBirthday success:^(id responseObject) {
            
            [[PVProgressHUD shared] hideHudInView:self.view];
            
            if (responseObject) {
                NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:updateSex];
                if (errorMsg.length > 0) {
                    Toast(errorMsg);
                }else {
                    NSDictionary *birthDayDic = [responseObject pv_objectForKey:@"data"];
                    NSString *birthDay = [birthDayDic pv_objectForKey:@"birthday"];
//                    NSString *userBirthDay = [[NSDate sc_dateFromString:birthDay withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"MM-dd HH:mm"];
                    [PVUserModel shared].baseInfo.birthday = birthDay;
                    [[PVUserModel shared] dump];
                    LZ.birthdayLabel.text = selectValue;
                }
                
            }
        } failure:^(NSError *error) {
            [[PVProgressHUD shared] hideHudInView:self.view];
            Toast(@"出生日期修改失败");
        } tokenErrorInfo:^(NSString *tokenErrorInfo) {
            
        }];
        
        
    }];
}

/** 个人信息修改 */
- (void) modifyUserInfo{

    PVModifyUserInfoViewController *view = [[PVModifyUserInfoViewController alloc] init];
    view.nickname = _nickNameLabel.text;
    view.tabBarTitle = @"个人信息";
    view.block = ^(NSString *text) {
        _nickNameLabel.text = text;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserInfo" object:nil];
    };
    [self.navigationController presentViewController:view animated:YES completion:^{
        YYLog(@"个人信息修改");
    }];
}

/** 绑定手机 */
- (void) bindingTel{
    
    if (self.telLabel.text.length > 0) return;
    
    PVBindingTelViewController *view = [[PVBindingTelViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
