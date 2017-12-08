//
//  PVHelpRegistViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHelpRegistViewController.h"
#import "PVInviteValidationViewController.h"
#import "PVFamilyOpenUpViewController.h"
#import "LZImageManager.h"
#import "PVFamilyModel.h"

@interface PVHelpRegistViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UIView *codeContentView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptInviteButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeProtocolButton;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;

@end

@implementation PVHelpRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.userPhoneLabel.text = self.telephone;
    self.agreeProtocolButton.selected = YES;
    [self initUI];
}

- (void)setupNavigationBar {
    self.scNavigationItem.title = @"帮Ta注册";
}

- (void)initUI {
    self.codeContentView.layer.borderColor = [UIColorHexString(0xD7D7D7) CGColor];
    self.codeContentView.layer.borderWidth = 1;
    self.codeContentView.layer.cornerRadius = self.codeContentView.sc_height / 2.;
    self.acceptInviteButton.layer.cornerRadius = self.acceptInviteButton.sc_height / 2.;
    self.acceptInviteButton.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderImage)];
    [self.headerView addGestureRecognizer:nameTap];
}

- (void)changeHeaderImage {
    CGFloat width = AUTOLAYOUTSIZE(294);
    PV(weakSelf);
    [[LZImageManager sharedManager] getCircleImageInVc:self
                                              withSize:CGSizeMake(width, width)
                                          withCallback:^(UIImage *image) {
                                              self.headerView.image = image;
//                                              [weakSelf uploadHeaderImageWithImage:image];
                                              
                                          }];
}

- (void)changePersonTel {
    SCLog(@"----修改通讯录名称------");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.topLayout.constant = kNavBarHeight;
}
//获取验证码
- (IBAction)getCodeButtonClick:(id)sender {
    if (self.telephone <= 0) {
        Toast(@"被邀请人电话号码错误");
        return;
    }
    if (![SCSmallTool checkTelNumber:self.telephone]) {
        Toast(@"被邀请人电话号码错误");
        return;
    }
    [[PVProgressHUD shared] showHudInView:self.view];
    PV(weakSelf);
    [PVNetTool postDataWithParams:@{@"phoneNumber":self.telephone} url:getVerifyCode success:^(id result) {
        if (result) {
            [[PVProgressHUD shared] hideHudInView:weakSelf.view];
            
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:result url:login];
            if (errorMsg.length > 0) {
                
                Toast(errorMsg);
            }
            if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                [weakSelf countdown];
            }
            
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:weakSelf.view];
        Toast(@"验证码发送失败");
    }];
}

//是否同意用户协议协议
- (IBAction)protocolAgreeButtonClick:(id)sender {
    self.agreeProtocolButton.selected = !self.agreeProtocolButton.selected;
}

//阅读协议
- (IBAction)readProtocolButtonClick:(id)sender {
}

//接受邀请
- (IBAction)acceptInviteButtonClick:(id)sender {
    if (self.agreeProtocolButton.selected) {
        return;
    }
    if (self.telephone <= 0) {
        Toast(@"被邀请人电话号码错误");
        return;
    }
    if (![SCSmallTool checkTelNumber:self.telephone]) {
        Toast(@"被邀请人电话号码错误");
        return;
    }
    if (self.codeTextField.text.length < 1){
        Toast(@"请输入验证码");
        return;
    }
    NSString * familyId = [NSString sc_stringForKey:MyFamilyGroupId];
    
    [[PVProgressHUD shared] showHudInView:self.view];
    NSDictionary * dic = @{@"code":self.codeTextField.text,
                           @"familyId":familyId,
                           @"phone":[PVUserModel shared].baseInfo.phoneNumber,
                           @"targetPhone":self.telephone
                           };
    PV(weakSelf);
    [PVNetTool postDataWithParams:dic url:registerFamily success:^(id result) {
        if (result) {
            [[PVProgressHUD shared] hideHudInView:weakSelf.view];
            
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:result url:login];
            if (errorMsg.length > 0) {
                
                Toast(errorMsg);
                return ;
            }
            [weakSelf showAcceptSuccessAlertView];
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:weakSelf.view];
        Toast(@"发送邀请失败");
    }];
    
//    if (!self.agreeProtocolButton.selected) {
//        SCLog(@"-----同意协议---------");
//
//        if (self.codeTextField.text.length > 0) {
//            [[PVFamilyModel shared].familyregidterArray addObject:self.telephone];
//            [[PVFamilyModel shared] dump];
//            [self showAcceptSuccessAlertView];
//        }else {
//            Toast(@"请输入验证码");
//        }
//
//        PVInviteValidationViewController *view = [[PVInviteValidationViewController alloc] init];
//        [self.navigationController pushViewController:view animated:YES];
//    }
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
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",weakSelf.telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    [controller setAlertCancleEventBlock:^(id sender) {
     [weakCon dismissViewControllerAnimated:YES completion:nil];
//        PVFamilyOpenUpViewController *controller = [[PVFamilyOpenUpViewController alloc] init];
//        [pv.navigationController pushViewController:controller animated:YES];
    }];
}

/**
 *  点击获取验证码
 *
 *  倒计时
 */
- (void) countdown {
    
    [self.codeTextField becomeFirstResponder];
    
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
                self.getCodeButton.userInteractionEnabled = YES;
                //                [self.codeButton setBackgroundImage:[Utils imageWithColor:kColorWithRGB(107, 152, 254)] forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeButton setTitle:[NSString stringWithFormat:@"%@秒后获取",strTime] forState:UIControlStateNormal];
                self.getCodeButton.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
