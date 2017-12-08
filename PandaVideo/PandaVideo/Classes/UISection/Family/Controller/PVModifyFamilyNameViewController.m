//
//  PVModifyFamilyNameViewController.m
//  PandaVideo
//
//  Created by songxf on 2017/11/8.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVModifyFamilyNameViewController.h"

@interface PVModifyFamilyNameViewController ()<UITextFieldDelegate>
{
@private
    UITextField *_textField;
}
@property(nonatomic,strong,readonly)UITextField * textField;
@end

@implementation PVModifyFamilyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self setLeftNavBarItemWithString:@"取消"];
    [self setRightNavBarItemWithString:@"保存"];
    self.scNavigationItem.title = self.tabBarTitle;
    [self setupUI];
    // Do any additional setup after loading the view.
}


- (void)leftItemClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightItemClick:(UIButton *)sender{
    NSString * familyId = [NSString sc_stringForKey:MyFamilyGroupId];
    if (familyId.length < 1) {
        return;
    }
    if (self.textField.text.length < 1) {
        return;
    }
    self.nickname = self.textField.text;
    PV(weakSelf);
    
    [PVNetTool postDataWithParams:@{@"name":self.nickname,@"familyId":familyId} url:(self.modifyType == FamilyModifyTypeFamilyName) ? modifyFamilyName : modifyFamilyNickName success:^(id result) {
//        if (weakSelf.block) {
//            weakSelf.block(weakSelf.nickname);
//        }
        [[NSNotificationCenter defaultCenter] postNotificationName:FamilyGroupNameChange object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            
        }];
//        return;
//    }
    
//    if (self.modifyType == FamilyModifyTypeNickName) {
//        [PVNetTool postDataWithParams:@{@"phone":[PVUserModel shared].baseInfo.phoneNumber,@"familyId":self.familyId} url:exitFamily success:^(id result) {
//
//        } failure:^(NSError *error) {
//
//        }];
//        return;
//    }
}
- (void)setupUI{
    UIView * backView = [UIView sc_viewWithColor:[UIColor whiteColor]];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kNavBarHeight+4);
        make.height.equalTo(@50);
        
    }];
    
    [backView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.left.mas_equalTo(13);
        make.height.equalTo(@40);
    }];
}
- (UITextField *)textField{
    if (_textField == nil) {
        _textField = [UITextField createTextFieldWithStyle:UITextBorderStyleNone];
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.text = self.nickname;
        _textField.delegate = self;
        if (self.modifyType == FamilyModifyTypeNickName) {
             _textField.placeholder =  @"请输您的家族昵称";
        }else if(self.modifyType == FamilyModifyTypeFamilyName){
            _textField.placeholder =  @"请输入您的圈昵称";
        }
    }
    return _textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location + string.length > 16) {
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
