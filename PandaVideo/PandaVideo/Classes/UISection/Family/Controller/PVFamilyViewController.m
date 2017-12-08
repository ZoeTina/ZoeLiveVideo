//
//  PVFamilyViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyViewController.h"
#import "PVFamilyInvoteView.h"
#import "PVNoLoginFamilyView.h"
#import "PVFamilyTelevisionPlayController.h"
#import "PVInviteFamilyViewController.h"
#import "PVFamilyOpenUpViewController.h"
#import "PVLoginViewController.h"
#import "PVFamilyInvoteModel.h"
#import "SCMainViewController.h"
@interface PVFamilyViewController ()

@property(nonatomic, strong)UIScrollView* scrollView;
@property(nonatomic, strong)UIView* topView;
@property(nonatomic, strong)UIView* middleView;
@property(nonatomic, assign)CGFloat middleViewHeight;
@property(nonatomic, assign)CGFloat middleViewHeightNoLogin;//未登录
@property(nonatomic, assign)CGFloat middleViewHeightMore;//多邀请
@property(nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic,assign)NSInteger updateState;// 0:未登录  1:已经登录没有收到邀请  2:收到邀请信息

@property(nonatomic,strong)PVNoLoginFamilyView *noLoginFamilyView;
@property(nonatomic,strong)UIView *infoView;
@property(nonatomic,strong)NSMutableArray *familyInvoteArray;
@property(nonatomic,assign)BOOL dataSoureCountChange;//邀请数据发生改变

//Moedel
@property(nonatomic,strong)PVFamilyInvoteModel * invoteModel;
@property(nonatomic,strong)PVFamilyBasicUIModel * basicModel;

@property(nonatomic,strong)UIImageView * topImageView;
@property(nonatomic,strong)UIImageView *bottomImageView;
@end

#define FamilyInvoteViewMargin 10.0
#define FamilyInvoteViewHeight 80.0

@implementation PVFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.updateState = 0;
    [self setupUI];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(falilyGroupWhenChange) name:FamilyGroupYaoQingStateChange object:nil];
    PV(weakSelf);
    self.scrollView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [weakSelf loadRequest];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadRequest];
}
- (void)loadRequest{

    [PVNetTool cancelCurrentRequest];
    PV(weakSelf);
    //如果当前没有登录，则只刷新首页
    if ([PVUserModel shared].token.length < 1) {
        [PVNetTool getDataWithUrl:getFamilyBasic success:^(id result) {
           [weakSelf.scrollView.mj_header endRefreshing];
             if (result) {
                 weakSelf.basicModel = [PVFamilyBasicUIModel yy_modelWithJSON:result];
                 [weakSelf updateBasicUI];
             }
        } failure:^(NSError *error) {
             [weakSelf.scrollView.mj_header endRefreshing];
        }];
        return;
    }
    
    //登录成功则可以多个请求
    NSMutableArray * pramas = [NSMutableArray array];
    PVNetModel* basicModel = [[PVNetModel alloc]  initIsGetOrPost:YES Url:[NSString stringWithFormat:@"%@/%@",DynamicUrl, getFamilyBasic] param:nil];
    [pramas addObject:basicModel];
    
    
    NSString *phoneNumber = [NSString sc_stringWhenNil:[PVUserModel shared].baseInfo.phoneNumber] ;
    PVNetModel* inviteModel = [[PVNetModel alloc]  initIsGetOrPost:NO Url:[NSString stringWithFormat:@"%@/%@",DynamicUrl, getFamilyInvite] param:@{@"phone": phoneNumber}];
    [pramas addObject:inviteModel];
    
    [PVNetTool getMoreDataWithParams:pramas success:^(id result) {
        [weakSelf.scrollView.mj_header endRefreshing];
        if (result) {
             if (result[@"0"]) {
                 weakSelf.basicModel = [PVFamilyBasicUIModel yy_modelWithJSON:result[@"0"][@"data"]];
                 [weakSelf updateBasicUI];
             }
            if (result[@"1"]) {
                weakSelf.invoteModel = [PVFamilyInvoteModel yy_modelWithJSON:result[@"1"][@"data"]];
                [NSString sc_setObject:weakSelf.invoteModel.familyId key:MyFamilyGroupId];
                [weakSelf updateInvoteModel];
            }
        }
        
    } failure:^(NSArray *errors) {
        [weakSelf.scrollView.mj_header endRefreshing];
         [weakSelf updateInvoteModel];
    }];
   
}
//更新背景
- (void)updateBasicUI{
    if (self.basicModel.colorValue.length > 0) {
        self.view.backgroundColor = [UIColor hexStringToColor:self.basicModel.colorValue];
        self.scrollView.backgroundColor = [UIColor hexStringToColor:self.basicModel.colorValue];
        self.topView.backgroundColor = [UIColor hexStringToColor:self.basicModel.colorValue];
        self.middleView.backgroundColor = [UIColor hexStringToColor:self.basicModel.colorValue];
    }
    
    [self.topImageView sc_setImageWithUrlString:self.basicModel.theme placeholderImage:[UIImage imageNamed:@"grandpagrandma"] isAvatar:NO];
    [self.bottomImageView sc_setImageWithUrlString:self.basicModel.familyImage placeholderImage:[UIImage imageNamed:@"组54"] isAvatar:NO];
    
}
//更新邀请列表
- (void)updateInvoteModel{
    //如果当前未登录
    if ([PVUserModel shared].token.length < 1) {
        [self falilyGroupWhenChange];
        return;
    }
    //如果当前已经加入家庭圈，则跳转到家庭圈页面
    if (self.invoteModel.joinFamily || self.invoteModel.familyId.length > 0) {
        if (self.transFamilyChildVCBlock) {
            self.transFamilyChildVCBlock();
        }
        return;
    }
    //判断是否发生改变没改变 return
    //如果发生改变
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:self.invoteModel.inviteList];
    [self falilyGroupWhenChange];
}
- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)falilyGroupWhenChange{
    //这个地方要做判断，是否需要更新UI  目前只做登录是否判断，其它判断以后补上
    if ([PVUserModel shared].token.length < 1 ) {
        [self isHiddeninfoView:YES];
        self.middleViewHeight = self.middleViewHeightNoLogin;
        [self updatelayOut];
        self.noLoginFamilyView.isLogin = NO;
        
    }else if(self.dataSource.count < 1){
        [self isHiddeninfoView:YES];
        self.middleViewHeight = self.middleViewHeightNoLogin;
        [self updatelayOut];
        self.noLoginFamilyView.isLogin = YES;
    }else{
        for (PVFamilyInvoteView * view in self.familyInvoteArray) {
            [view removeFromSuperview];
        }
        [self createFamilyInvoteView];
        [self isHiddeninfoView:NO];
        self.middleViewHeight = self.middleViewHeightMore;
        [self updatelayOut];
    }
}

//是否隐藏
- (void)isHiddeninfoView:(BOOL)isHidden{
    
    self.infoView.hidden = isHidden;
    self.noLoginFamilyView.hidden = !isHidden;
    for (PVFamilyInvoteView * view in self.familyInvoteArray) {
        view.hidden = isHidden;
    }
}
- (void)updatelayOut{
    [self.middleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(-150 + 70);
        make.left.equalTo(@(0));
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(self.middleViewHeight));
    }];
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom);
        make.left.equalTo(@(0));
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(ScreenWidth*2167/750));
    }];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.topView.frame) + ScreenWidth*2167/750 + self.middleViewHeight-170 + 70 + 20 + 50);
}


-(void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.topView];
    [self.scrollView addSubview:self.middleView];
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(-150 + 70);
        make.left.equalTo(@(0));
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(self.middleViewHeight));
    }];
    UIImageView* twoImageView = [[UIImageView alloc]  init];
    twoImageView.image = [UIImage imageNamed:@"组54"];
    self.bottomImageView = twoImageView;
    [self.scrollView addSubview:twoImageView];
    [twoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom);
        make.left.equalTo(@(0));
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(ScreenWidth*2167/750));
    }];
//    UIImageView* threeImageView = [[UIImageView alloc]  init];
//    threeImageView.image = [UIImage imageNamed:@"chahua2_bg"];
//    threeImageView.userInteractionEnabled = true;
//    [self.scrollView addSubview:threeImageView];
//    [threeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(twoImageView.mas_bottom);
//        make.left.equalTo(@(0));
//        make.width.equalTo(@(ScreenWidth));
//        make.height.equalTo(@(ScreenWidth*1401/750));
//    }];
    UIView * fourView = [UIView sc_viewWithColor:[UIColor whiteColor]];
    [self.scrollView addSubview:fourView];
    [fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoImageView.mas_bottom).offset(-10);
        make.left.equalTo(@(0));
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(60));
    }];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(self.topView.frame) + ScreenWidth*2167/750 + self.middleViewHeight-170 + 70 + 20 + 50);
    
    
    UIButton* addFamilyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addFamilyBtn.adjustsImageWhenDisabled = false;
    addFamilyBtn.adjustsImageWhenHighlighted = false;
    [addFamilyBtn setImage:[UIImage imageNamed:@"btn_invite_family"] forState:UIControlStateNormal];
    [fourView addSubview:addFamilyBtn];
    
    [addFamilyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(addFamilyBtn.currentImage.size.width));
        make.height.equalTo(@(addFamilyBtn.currentImage.size.height));
        make.centerX.equalTo(fourView);
        make.centerY.equalTo(fourView).offset(-10);
    }];
    [addFamilyBtn addTarget:self action:@selector(addFamilyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
   
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor sc_colorWithHex:0xb0d8f0];
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.scrollsToTop = false;
        _scrollView.bounces = YES;
        _scrollView.frame = self.view.bounds;
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
        ;
    }
    return _scrollView;
}
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]  init];
        _topView.backgroundColor = [UIColor sc_colorWithHex:0xb0d8f0];
        _topView.frame = CGRectMake(0, 0, ScreenWidth,296);
        
        UIImageView* imageView = [[UIImageView alloc]  init];
        imageView.image = [UIImage imageNamed:@"grandpagrandma"];
        self.topImageView = imageView;
        [_topView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(imageView.image.size.width));
            make.height.equalTo(@(imageView.image.size.height));
            make.top.equalTo(_topView);
            make.centerX.equalTo(_topView);
        }];
        
        UIButton* addFamilyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addFamilyBtn.adjustsImageWhenDisabled = false;
        addFamilyBtn.adjustsImageWhenHighlighted = false;
        [addFamilyBtn setImage:[UIImage imageNamed:@"btn_invite_family"] forState:UIControlStateNormal];
        [_topView addSubview:addFamilyBtn];
        [addFamilyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(addFamilyBtn.currentImage.size.width));
            make.height.equalTo(@(addFamilyBtn.currentImage.size.height));
            make.centerY.equalTo(imageView.mas_centerY).offset(30);
            make.centerX.equalTo(_topView);
        }];
        [addFamilyBtn addTarget:self action:@selector(addFamilyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView* textimageView = [[UIImageView alloc]  init];
        textimageView.image = [UIImage imageNamed:@"slogen"];
        [_topView addSubview:textimageView];
        [textimageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(textimageView.image.size.width));
            make.height.equalTo(@(textimageView.image.size.height));
            make.top.equalTo(addFamilyBtn.mas_bottom).offset(IPHONE6WH(12));
            make.centerX.equalTo(_topView);
        }];
    }
    return _topView;
}

/**邀请家人弹窗，先把权限放开为直接邀请*/
-(void)addFamilyBtnClicked{
//    PVInviteFamilyViewController * vc = [[PVInviteFamilyViewController alloc] init];
//    vc.view.backgroundColor = [UIColor redColor];
//    UINavigationController* nav = [[UINavigationController alloc]  initWithRootViewController:vc];
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    SCMainViewController *mainView = (SCMainViewController *)[delegate window].rootViewController;
//    NSMutableArray  *newArray =[NSMutableArray arrayWithArray:mainView.childViewControllers];
//    [newArray replaceObjectAtIndex:2 withObject:nav];
//    mainView.viewControllers = newArray;
//    return;
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        PVLoginViewController *loginCon = [[PVLoginViewController alloc] init];
        [self.navigationController pushViewController:loginCon animated:YES];
    }else {
        
        PVInviteFamilyViewController* vc = [[PVInviteFamilyViewController alloc]  init];
        [self.navigationController pushViewController:vc animated:true];
        SCLog(@"邀请家人");
    }
   
}


-(UIView *)middleView{
    if (!_middleView) {
        _middleView = [[UIView alloc]  init];
        _middleView.backgroundColor = [UIColor sc_colorWithHex:0xb0d8f0];
        //无邀请
            [_middleView addSubview:self.noLoginFamilyView];
            [self.noLoginFamilyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(20));
                make.left.equalTo(@(10));
                make.right.equalTo(@(-10));
                make.height.equalTo(@(60));
            }];
//            self.noLoginFamilyView.isLogin = ([PVUserModel shared].token.length > 0);
        //多个邀请
            [_middleView addSubview:self.infoView];
            [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@(0));
                make.height.equalTo(@(40));
                make.left.equalTo(@(10));
                make.right.equalTo(@(-10));
            }];
        if ([PVUserModel shared].token.length< 1) {
            [self isHiddeninfoView:YES];
            self.middleViewHeight = self.middleViewHeightNoLogin;
            self.updateState = 0;
        }else if(self.dataSource.count  < 1){
            [self isHiddeninfoView:YES];
            self.middleViewHeight = self.middleViewHeightNoLogin;
            self.updateState = 1;
        }else{
            [self isHiddeninfoView:NO];
            self.middleViewHeight = self.middleViewHeightMore;
            self.updateState = 2;
        }
        PV(weakSelf);
        self.noLoginFamilyView.comeOnLoginBlock = ^{
            if ([PVUserModel shared].token.length > 0) {
                return ;
            }
            PVLoginViewController *loginCon = [[PVLoginViewController alloc] init];
            [weakSelf.navigationController pushViewController:loginCon animated:YES];
        };
    }
    return _middleView;
}

- (PVNoLoginFamilyView *)noLoginFamilyView{
    if (_noLoginFamilyView == nil) {
        _noLoginFamilyView =  [[NSBundle mainBundle] loadNibNamed:@"PVNoLoginFamilyView" owner:nil options:nil ].lastObject;
        
        self.middleViewHeightNoLogin = 100 + 10;
    }
    return _noLoginFamilyView;
}

- (UIView *)infoView{
    if (_infoView == nil) {
        _infoView = [[UIView alloc]  init];
        _infoView.backgroundColor = [UIColor clearColor];
        
        UILabel* infoLabel = [[UILabel alloc]  init];
        infoLabel.textColor = [UIColor sc_colorWithHex:0xFAFBFD];
        infoLabel.text = @"家庭圈验证信息";
        infoLabel.font = [UIFont systemFontOfSize:14];
        [_infoView addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_infoView);
            make.top.equalTo(@(13));
        }];
        
        UIView* twoleftView = [[UIView alloc]  init];
        twoleftView.backgroundColor = [UIColor whiteColor];
        twoleftView.clipsToBounds = true;
        twoleftView.layer.cornerRadius = 2.5f;
        [_infoView addSubview:twoleftView];
        [twoleftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(5));
            make.centerY.equalTo(infoLabel);
            make.right.equalTo(infoLabel.mas_left).offset(-5);
        }];
        
        UIView* twoRightView = [[UIView alloc]  init];
        twoRightView.backgroundColor = [UIColor whiteColor];
        twoRightView.clipsToBounds = true;
        twoRightView.layer.cornerRadius = 2.5f;
        [_infoView addSubview:twoRightView];
        [twoRightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(5));
            make.centerY.equalTo(infoLabel);
            make.right.equalTo(infoLabel.mas_right).offset(7);
        }];
        
        UIView* firstleftView = [[UIView alloc]  init];
        firstleftView.backgroundColor = [UIColor whiteColor];
        [_infoView addSubview:firstleftView];
        [firstleftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1));
            make.centerY.equalTo(infoLabel);
            make.right.equalTo(twoleftView.mas_left).offset(-5);
            make.left.equalTo(@(0));
        }];
        
        UIView* firstRightView = [[UIView alloc]  init];
        firstRightView.backgroundColor = [UIColor whiteColor];
        [_infoView addSubview:firstRightView];
        [firstRightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1));
            make.centerY.equalTo(infoLabel);
            make.left.equalTo(twoRightView.mas_right).offset(5);
            make.right.equalTo(@(0));
        }];
        
        [self createFamilyInvoteView];
         self.middleViewHeightMore = 50 + 10 + (FamilyInvoteViewMargin + FamilyInvoteViewHeight)*self.dataSource.count;
    }
    return _infoView;
}

- (void)createFamilyInvoteView{
    CGFloat leftAndRightMargin = 10;
    CGFloat width = ScreenWidth - 2*leftAndRightMargin;
    NSInteger count = self.dataSource.count;
    self.familyInvoteArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        PVFamilyInvoteView* familyInvoteView =  [[NSBundle mainBundle] loadNibNamed:@"PVFamilyInvoteView" owner:nil options:nil ].lastObject;
        CGFloat y = (FamilyInvoteViewHeight+FamilyInvoteViewMargin)*i + FamilyInvoteViewMargin + 40;
        [self.middleView addSubview:familyInvoteView];
        [familyInvoteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(leftAndRightMargin));
            make.top.equalTo(@(y));
            make.height.equalTo(@(FamilyInvoteViewHeight));
            make.width.equalTo(@(width));
        }];
        familyInvoteView.model = [self.dataSource sc_safeObjectAtIndex:i];
        [self.familyInvoteArray addObject:familyInvoteView];
        PV(pv)
        [familyInvoteView setPVFamilyInvoteViewBlock:^(NSInteger index) {
            [pv showAcceptAlertView:index];
        }];
         self.middleViewHeightMore = 50 + 10 + (FamilyInvoteViewMargin + FamilyInvoteViewHeight)*self.dataSource.count;
        
    }
}

//显示接受邀请弹窗
- (void)showAcceptAlertView:(NSInteger)index {
    PVAlertModel *model = [[PVAlertModel alloc] init];
    model.descript = @"您只能加入一个家庭圈哦～确认加入吗？";
    model.cancleButtonName = @"暂不";
    model.eventName = @"接受邀请";
    model.alertType = OnlyText;
    PVFamilyCircleAlertControlelr *controller = [[PVFamilyCircleAlertControlelr alloc] initAlertViewModel:model];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    
    __weak PVFamilyCircleAlertControlelr *weakAlertCon = controller;
    PV(pv);
    
//    [controller setAlertCancleEventBlock:^(id sender) {
//        [weakAlertCon dismissViewControllerAnimated:YES completion:nil];
//    }];
    [controller setAlertViewSureEventBlock:^(id sender) {
        [weakAlertCon dismissViewControllerAnimated:YES completion:nil];
        [pv sureJoinFamily:index];
        
//        PVFamilyOpenUpViewController* vc = [[PVFamilyOpenUpViewController alloc]  init];
//        [pv.navigationController pushViewController:vc animated:true];
    }];
}

- (void)sureJoinFamily:(NSInteger)index{
    PVFamilyInvoteListModel * model = [self.dataSource sc_safeObjectAtIndex:index];
    if (model.familyId.length < 1) {
        return;
    }
    if (model.phone.length < 1) {
        return;
    }

    if ([PVUserModel shared].baseInfo.phoneNumber.length < 1) {
        return;
    }
    PV(weakSelf);
    [PVNetTool postDataWithParams:@{@"familyId":model.familyId,@"phone":model.phone,@"targetPhone":[PVUserModel shared].baseInfo.phoneNumber} url:joinFamily success:^(id result) {
        NSString * errorMsg = result[@"errorMsg"];
        if (errorMsg.length>0) {
            Toast(errorMsg);
            return ;
        }
        [NSString sc_setObject:weakSelf.invoteModel.familyId key:MyFamilyGroupId];
        if (weakSelf.transFamilyChildVCBlock) {
            weakSelf.transFamilyChildVCBlock();
        }
    } failure:^(NSError *error) {

    }];
    
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
