//
//  PVModifyUserInfoViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/30.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVModifyUserInfoViewController.h"
static NSString *CellIdentifier = @"PVModifyUserInfoViewController";
@interface PVModifyUserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *lzTableView;

@property (strong, nonatomic) IBOutlet UITableViewCell  *tableviewCell;
@property (strong, nonatomic) IBOutlet UITextField      *textField;
@property (strong, nonatomic) IBOutlet UIView           *footerView;
@property (strong, nonatomic) IBOutlet UILabel          *tipsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end

@implementation PVModifyUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topLayout.constant = kNavBarHeight;
    [self initBaseView];
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
}

-(void)setupNavigationBar{
    
    self.scNavigationItem.title = self.tabBarTitle;
}

-(void)initBaseView{
    self.lzTableView.tableFooterView = _footerView;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, YYScreenWidth, 10)];
    headerView.backgroundColor = kColorWithRGB(234, 235, 236);
    self.lzTableView.tableHeaderView = headerView;
    
    [self.view insertSubview:self.lzTableView belowSubview:self.scNavigationBar];
    
    // 添加右边保存按钮
    self.scNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];

    // 添加左边保存按钮
    self.scNavigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    
    _textField.text = self.nickname;
}

/** 取消(关闭界面) */
- (void) cancelBtnClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 保存 */
- (void) saveBtnClick{
    
    NSString *nickname = _textField.text;
    
    if (nickname.length == 0) {
        Toast(@"昵称为空");
        return;
    }
    
    NSInteger length = [SCSmallTool convertToInt:nickname];
    if (length < 2) {
        Toast(@"昵称长度不够哦");
        return;
    }
    if (length > 20) {
        Toast(@"昵称长度超过20个字符了");
        return;
    }
    
    NSDictionary *dict = @{@"nickName":nickname, @"userId":[PVUserModel shared].userId, @"token":[PVUserModel shared].token};
    
    [[PVProgressHUD shared] showHudInView:self.view];
    
    [PVNetTool postDataHaveTokenWithParams:dict url:updateNickname success:^(id responseObject) {
        
        [[PVProgressHUD shared] hideHudInView:self.view];
        
        if (responseObject) {
           NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:responseObject url:updateNickname];
            if (errorMsg.length > 0) {
                Toast(errorMsg);
            }else {
                NSDictionary *nameDic = [responseObject pv_objectForKey:@"data"];
                [PVUserModel shared].baseInfo.nickName = [nameDic pv_objectForKey:@"nickName"];
                [[PVUserModel shared] dump];
                if (self.block != nil) {
                    self.block(nickname);
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }
    } failure:^(NSError *error) {
        [[PVProgressHUD shared] hideHudInView:self.view];
        Toast(@"昵称修改失败");
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        
    }];
    
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _tableviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return _tableviewCell;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

kRemoveCellSeparator

#pragma mark 给当前view添加识别手势
#pragma mark -- 当前tableView中带有输入框点击背景关闭键盘
-(void)addGesture {
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    [self.lzTableView addGestureRecognizer:tapGesture];
    tapGesture.cancelsTouchesInView = NO;
}

-(void)tapGesture {
    //    [self.tableView endEditing:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
