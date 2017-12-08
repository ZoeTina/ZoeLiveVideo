//
//  PVThreeTabItemViewController.m
//  PandaVideo
//
//  Created by songxf on 2017/11/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVThreeTabItemViewController.h"
#import "PVFamilyViewController.h"
#import "PVFamilyOpenUpViewController.h"
#import "PVFamilyInvoteModel.h"
@interface PVThreeTabItemViewController ()

@property(nonatomic,strong)PVFamilyInvoteModel * invotModel;
@end

@implementation PVThreeTabItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor sc_colorWithHex:0xb0d8f0];
    [self loadRequest];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString * familyId = [NSString sc_stringForKey:MyFamilyGroupId];
    if (self.childViewControllers.count > 0) {
        UIViewController *vc = [self.childViewControllers lastObject];
        if ([vc isKindOfClass:[PVFamilyOpenUpViewController class]]) {
            if (familyId.length < 1) {
                [self transitionChildViewController:NO];
            }
        }else if([vc isKindOfClass:[PVFamilyViewController class]]){
            if (familyId.length > 0) {
                [self transitionChildViewController:YES];
            }
        }
    }
}
//加载网络请求
- (void)loadRequest{
//    [self transitionChildViewController:YES];
//    return;
    NSString * phoneNumber = [PVUserModel shared].baseInfo.phoneNumber;
    if (phoneNumber.length < 1) {
        [self transitionChildViewController:NO];
        return;
    }
    PV(weakSelf);
    [PVNetTool postWithURLString:getFamilyInvite parameter:@{@"phone": phoneNumber} success:^(id responseObject) {
        weakSelf.invotModel = [PVFamilyInvoteModel yy_modelWithJSON:responseObject[@"data"]];
 
       [NSString sc_setObject:weakSelf.invotModel.familyId key:MyFamilyGroupId];
       [weakSelf transitionChildViewController:weakSelf.invotModel.joinFamily];
    } failure:^(NSError *error) {
            [weakSelf transitionChildViewController:NO];
    }];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)transitionChildViewController:(BOOL)isHaveFamily{
    
    if (self.childViewControllers.count > 0) {
        UIViewController *vc = [self.childViewControllers lastObject];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    if (isHaveFamily) {
        PVFamilyOpenUpViewController * vc = [[PVFamilyOpenUpViewController alloc] init];
        [self.view addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [self addChildViewController:vc];
    }else{
        PVFamilyViewController * vc = [[PVFamilyViewController alloc] init];
        [self.view addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        __weak typeof(self) weakSelf = self;
        vc.transFamilyChildVCBlock = ^{
            [weakSelf transitionChildViewController:YES];
        };
        [self addChildViewController:vc];
    }
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
