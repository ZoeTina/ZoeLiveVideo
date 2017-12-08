//
//  PVBindingTelViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/30.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBindingTelViewController.h"
#import "PVProtocolViewController.h"
//#import "PVBaseWebViewController.h"
#import "PVWebViewController.h"

@interface PVBindingTelViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>


/** lzTableView */
@property (strong, nonatomic) IBOutlet UITableView  *lzTableView;
/** HeaderView */
@property (strong, nonatomic) IBOutlet UIView       *headerView;
/** 手机输入框 */
@property (strong, nonatomic) IBOutlet UITextField  *telField;
/** 密码输入框 */
@property (strong, nonatomic) IBOutlet UITextField  *pwdField;
/** 手机号盒子View */
@property (strong, nonatomic) IBOutlet UIView       *telBoxView;
/** 密码盒子View */
@property (strong, nonatomic) IBOutlet UIView       *pwdBoxView;
/** 获取短信验证码按钮 */
@property (strong, nonatomic) IBOutlet UIButton     *codeButton;
/** 注册按钮 */
@property (strong, nonatomic) IBOutlet UIButton     *registerButton;
/** 协议按钮 */
@property (strong, nonatomic) IBOutlet UIButton     *protocolButton;
/** 勾选按钮 */
@property (strong, nonatomic) IBOutlet UIButton     *checkButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (nonatomic, copy) BindSuccessBlock bindBlock;

@end

@implementation PVBindingTelViewController

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
    // Do any additional setup after loading the view from its nib.
    self.topLayout.constant = kNavBarHeight;
    [self initBaseView];
}

-(void)setupNavigationBar{
    
    self.scNavigationItem.title = @"绑定手机";
}

- (void)changeCodeView {
    if (self.pwdField.text.length == 0) {
        [self.registerButton setBackgroundColor:UIColorHexString(0x91D7F0)];
    }else {
        [self.registerButton setBackgroundColor:UIColorHexString(0x2AB4E4)];
    }
}

-(void)initBaseView{

    [Utils setExtraCellLineHidden:self.lzTableView];
//    self.lzTableView.scrollEnabled = NO;
    self.lzTableView.tableHeaderView = _headerView;
    
    _telBoxView.layer.masksToBounds = YES;
    _telBoxView.layer.cornerRadius  = _telBoxView.sc_height/2;
    _telBoxView.layer.borderColor   = kColorWithRGB(215, 215, 215).CGColor;
    _telBoxView.layer.borderWidth   = .5;
    
    _pwdBoxView.layer.masksToBounds = YES;
    _pwdBoxView.layer.cornerRadius  = _pwdBoxView.sc_height/2;
    _pwdBoxView.layer.borderColor   = kColorWithRGB(215, 215, 215).CGColor;
    _pwdBoxView.layer.borderWidth   = .5;
    
    
    _registerButton.layer.masksToBounds = YES;
    _registerButton.layer.cornerRadius = _registerButton.sc_height/2;
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
    
    NSDictionary *dict = @{@"phoneNumber":self.telField.text};
    [PVNetTool postDataWithParams:dict url:getVerifyCode success:^(id result) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        if (result) {
            NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:result url:getVerifyCode];
            if (errorMsg.length > 0) {
                Toast(errorMsg);
            }
            if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
                [self countdown];
            }
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:self.view];
    }];
    
}

/**
 *  点击注册按钮
 *
 *  @param sender 当前按钮
 */

- (IBAction)registerBtnClick:(id)sender {
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
    
    
    [self.parameterDict setObject:self.telField.text forKey:@"phoneNumber"];
    [self.parameterDict setObject:self.pwdField.text forKey:@"verifyCode"];
    [self.parameterDict setValue:[NSNumber numberWithInteger:device] forKey:@"device"];
    
    [[PVProgressHUD shared] showHudInView:self.view];
    
    [PVNetTool postDataWithParams:self.parameterDict url:bindAccount success:^(id result) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        if (result) {
         NSString *errMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:result url:bindAccount];
            if (errMsg.length > 0) {
                Toast(errMsg);
            }else {
                PVUserModel *userModel = [PVUserModel shared];
                [userModel yy_modelSetWithDictionary:[result pv_objectForKey:@"data"]];
                [userModel dump];
                
                if (self.bindBlock) {
                    self.bindBlock(YES);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserInfo" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        WindowToast(@"电话号码绑定失败");
    }];
}

- (void)setBindSuccessBlock:(BindSuccessBlock)block {
    self.bindBlock = block;
}


/**
 *  点击协议按钮
 *
 *  @param sender 当前按钮
 */

- (IBAction)protocolBtnClick:(id)sender {
    
    PVWebViewController *webCon = [[PVWebViewController alloc] initWebViewControllerWithWebUrl:loginProtocol webTitle:@"熊猫视频服务协议"];
    [self.navigationController pushViewController:webCon animated:YES];
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

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PVBindingTelViewController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

kRemoveCellSeparator

- (NSMutableDictionary *)parameterDict {
    if (!_parameterDict) {
        _parameterDict = [[NSMutableDictionary alloc] init];
    }
    return _parameterDict;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
