//
//  PVLoginViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/9/26.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLoginViewController.h"
#import "PVProtocolViewController.h"
#import "PVLoginTool.h"
#import "UIView+Toast.h"
#import "PVBindingTelViewController.h"
#import "PVThridLoginView.h"
#import "PVShareTool.h"
//#import "PVBaseWebViewController.h"
#import "PVWebViewController.h"

@interface PVLoginViewController ()<PVThridLoginViewButtonClickDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *telBoxView;
@property (weak, nonatomic) IBOutlet UIView *codeBoxView;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *telField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTopLayout;
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *QQButton;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
@property (weak, nonatomic) IBOutlet UILabel *QQLabel;

@property(nonatomic, copy)PVLoginViewControllerLoginSuccess callBlock;

@end

@implementation PVLoginViewController

-(void)dealloc{
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCodeView) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   [self initBaseView];
    //self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)setPVLoginViewControllerLoginSuccess:(PVLoginViewControllerLoginSuccess)block{
    self.callBlock = block;
}

-(void)setupNavigationBar{
    
    self.scNavigationItem.title = @"登录";
}

-(void)initBaseView{
    
    _telBoxView.layer.masksToBounds = YES;
//    _telBoxView.layer.cornerRadius  = _telBoxView.sc_height/2.;
    _telBoxView.layer.borderColor   = kColorWithRGB(215, 215, 215).CGColor;
    _telBoxView.layer.borderWidth   = .5;
    
    _codeBoxView.layer.masksToBounds = YES;
//    _codeBoxView.layer.cornerRadius  = _codeBoxView.sc_height/2.;
    _codeBoxView.layer.borderColor   = kColorWithRGB(215, 215, 215).CGColor;
    _codeBoxView.layer.borderWidth   = .5;
    
    _pwdField.delegate = self;
    
    _loginButton.layer.masksToBounds = YES;
//    _loginButton.layer.cornerRadius = _loginButton.sc_height/2;
    [self initThridLoginView];
    
}


//登录成功时，改变家庭圈状态  songxf test  
//- (void)loginOnSussucess{
//    [[NSNotificationCenter defaultCenter] postNotificationName:FamilyGroupYaoQingStateChange object:nil];
//}

- (void)initThridLoginView {
    PVThridLoginView *loginView = [[PVThridLoginView alloc] initWithFrame:CGRectZero];
    loginView.thridLoginViewDelegate = self;
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(IPHONE6WH(73));
        make.bottom.mas_offset(-(IPHONE6WH(43)+ SafeAreaBottomHeight));
    }];
    
    UIView *lineView = [UIView sc_viewWithColor:UIColorHexString(0xD7D7D7)];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(IPHONE6WH(13));
        make.right.mas_offset(-IPHONE6WH(13));
        make.height.mas_equalTo(1);
        make.bottom.equalTo(loginView.mas_top).mas_offset(-IPHONE6WH(30));
    }];
    
    UILabel *tipsLabel = [UILabel sc_labelWithText:@"其他三方登录" fontSize:13 textColor:UIColorHexString(0x000000) alignment:NSTextAlignmentCenter];
    tipsLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(lineView.mas_centerY);
        make.centerX.mas_equalTo(lineView.mas_centerX);
        make.width.mas_equalTo(99);
    }];
}

- (void)changeCodeView {
    if (self.pwdField.text.length == 0) {
        [self.loginButton setBackgroundColor:UIColorHexString(0x91D7F0)];
    }else {
        [self.loginButton setBackgroundColor:UIColorHexString(0x2AB4E4)];
    }
}

/**
 *  点击获取验证码
 *
 *  @param sender 当前按钮
 */
- (IBAction)obtainVerificationCode:(id)sender {
    if (self.telField.text.length == 0) {
        Toast(@"请输入电话号码");
        return;
    }
    if (![SCSmallTool checkTelNumber:self.telField.text]) {
        Toast(@"请输入正确的电话号码");
        return;
    }
    
    [[PVProgressHUD shared] showHudInView:self.view];
    
    [PVNetTool postDataWithParams:@{@"phoneNumber":self.telField.text} url:getVerifyCode success:^(id result) {
        if (result) {
            [[PVProgressHUD shared] hideHudInView:self.view];
            
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:result url:login];
            if (errorMsg.length > 0) {
                
                Toast(errorMsg);
            }
            if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                [self countdown];
            }
            
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        Toast(@"验证码发送失败");
    }];
    
}

/**
 *  点击注册按钮
 *
 *  @param sender 当前按钮
 */

- (IBAction)loginBtnClick:(id)sender {
    
    if (self.telField.text.length == 0) {
        Toast(@"请输入电话号码");
        return;
    }
    
    if (![SCSmallTool checkTelNumber:self.telField.text]) {
        Toast(@"请输入正确的电话号码");
        return;
    }
    if (self.pwdField.text.length == 0) {
        Toast(@"请输入验证码");
        return;
    }
    if (self.checkButton.selected) {
        Toast(@"请同意用户协议");
        return;
    }

    PV(weakSelf);
    [[PVProgressHUD shared] showHudInView:self.view];
    
    NSDictionary *paraDic = @{@"phoneNumber":self.telField.text, @"verifyCode":self.pwdField.text,  @"device":@(device)};
    [PVNetTool postDataWithParams:paraDic url:login success:^(id result) {
        if (result){
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:result url:login];
            if (errorMsg.length > 0) {
                [[PVProgressHUD shared] hideHudInView:self.view];
                Toast(errorMsg);
            }else {
                
                PVUserModel *userModel = [PVUserModel shared];
                [userModel yy_modelSetWithDictionary:[result pv_objectForKey:@"data"]];
                if (userModel.baseInfo.nickName.length == 0) {
                    userModel.baseInfo.nickName = weakSelf.telField.text;
                }
                [userModel dump];
                PVUserModel *newModel = [[PVUserModel shared] load];
                [[PVProgressHUD shared] hideHudInView:self.view];
                ///调用block
                if (self.callBlock) {
                    self.callBlock();
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserInfo" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoginState" object:nil];
//                [weakSelf loginOnSussucess];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        Toast(@"登录失败");
    }];
}

- (void)simulateLogin {
    PVUserModel *userModel = [PVUserModel shared];
    userModel.userId = @"61";
    userModel.token = @"token";
    [userModel dump];
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

/**
 *  点击协议按钮
 *
 *  @param sender 当前按钮
 */

- (IBAction)protocolBtnClick:(id)sender {
    
//    PVProtocolViewController *view = [[PVProtocolViewController alloc] init];
//    [self.navigationController pushViewController:view animated:YES];
    PVWebViewController *webCon = [[PVWebViewController alloc] initWebViewControllerWithWebUrl:loginProtocol webTitle:@"熊猫视频服务协议"];
    [self.navigationController pushViewController:webCon animated:YES];
}

/**
 是否同意协议

 @param sender 协议按钮
 */
- (IBAction)agreeProtocolButtonClick:(id)sender {
    self.checkButton.selected = !self.checkButton.selected;
}


/**
 *  微信登录按钮
 */
- (void)weixinClick {
   
    [[PVProgressHUD shared] showHudInView:self.view];
    
    [PVLoginTool loginWithPlatform:SSDKPlatformTypeWechat successBlock:^(SSDKUser *userInfo) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        if (userInfo) {
            NSDictionary *dict = @{@"avatar":userInfo.icon, @"nickName":userInfo.nickname, @"openId":userInfo.uid, @"platform":WECHAT, @"device":@(device)};
            [self thridLoginWirhParaDict:dict];
        }else {
            Toast(@"获取微信用户信息失败");
        }
    } failureBlock:^(NSString *errorStr, NSError *error) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        if (errorStr.length > 0) {

        }else {
            //登录失败提示信息
            Toast(@"微信登录失败");
        }
    }];
    
}

/**
 *  新浪登录按钮
 */
- (void)weiboClick {
    
    [[PVProgressHUD shared] showHudInView:self.view];
    
    [PVLoginTool loginWithPlatform:SSDKPlatformTypeSinaWeibo successBlock:^(SSDKUser *userInfo) {
        
        [[PVProgressHUD shared] hideHudInView:self.view];
        
        if (userInfo) {
            NSDictionary *dict = @{@"avatar":userInfo.icon, @"nickName":userInfo.nickname, @"openId":userInfo.uid, @"platform":SINAWEIBO, @"device":@(device)};
            [self thridLoginWirhParaDict:dict];
        }else {
            Toast(@"获取微博用户信息失败");
        }
    } failureBlock:^(NSString *errorStr, NSError *error) {
        //因为微博有网页分享，所以没必要有未安装的提示信息
        [[PVProgressHUD shared] hideHudInView:self.view];
        if (error) {
            Toast(@"微博登录失败");
        }
    }];
}

/**
 *  QQ登录按钮
 */
- (void)QQClick {
    
    [[PVProgressHUD shared] showHudInView:self.view];
    
    [PVLoginTool loginWithPlatform:SSDKPlatformTypeQQ successBlock:^(SSDKUser *userInfo) {
        
        [[PVProgressHUD shared] hideHudInView:self.view];
        
        if (userInfo) {
            NSDictionary *dict = @{@"avatar":userInfo.icon, @"nickName":userInfo.nickname, @"openId":userInfo.uid, @"platform":QQ, @"device":@(device)};
            [self thridLoginWirhParaDict:dict];
        }else {
            Toast(@"获取QQ用户信息失败");
        }
    } failureBlock:^(NSString *errorStr, NSError *error) {
        
        [[PVProgressHUD shared] hideHudInView:self.view];
        
        if (errorStr.length > 0) {
           
        }else {
            //分享失败提示信息
            Toast(@"QQ登录失败");
        }
    }];
    
}

- (void)thridLoginWirhParaDict:(NSDictionary *)parameter {
    [[PVProgressHUD shared] showHudInView:self.view];
    
    [PVNetTool postDataWithParams:parameter url:thirdAccountLogin success:^(id result) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        if (result) {
            if ([[result pv_objectForKey:@"rs"] integerValue] == 401) {
                PVBindingTelViewController *con = [[PVBindingTelViewController alloc] init];
                con.parameterDict = [NSMutableDictionary dictionaryWithDictionary:parameter];
                [con setBindSuccessBlock:^(BOOL bindIsSuccess) {
                    if (bindIsSuccess) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserInfo" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoginState" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                [self.navigationController pushViewController:con animated:YES];
//                 [self loginOnSussucess];
            }else {
                if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                    PVUserModel *userModel = [PVUserModel shared];
                    [userModel yy_modelSetWithDictionary:[result pv_objectForKey:@"data"]];
                    [userModel dump];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserInfo" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLoginState" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    Toast([result pv_objectForKey:@"errorMsg"]) {
                    }
                }
                
            }
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:self.view];
    }];
}

/**
 *  点击获取验证码
 *
 *  倒计时
 */
- (void) countdown {
    
    [self.pwdField becomeFirstResponder];
    
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
//                [self.codeButton setBackgroundImage:[Utils imageWithColor:kColorWithRGB(107, 152, 254)] forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeButton setTitle:[NSString stringWithFormat:@"%@秒后获取",strTime] forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = NO;
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
     _telBoxView.layer.cornerRadius  = _telBoxView.sc_height/2.;
     _codeBoxView.layer.cornerRadius  = _codeBoxView.sc_height/2.;
     _loginButton.layer.cornerRadius = _loginButton.sc_height/2;
    self.iconTopLayout.constant = kScreenHeight == 812.0 ? 88 + kDistanceHeightRatio(29) : 64 + kDistanceHeightRatio(29);
}
kRemoveCellSeparator

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
