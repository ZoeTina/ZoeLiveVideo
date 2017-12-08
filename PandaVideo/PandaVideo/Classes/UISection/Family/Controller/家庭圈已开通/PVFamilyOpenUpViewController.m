//
//  PVFamilyOpenUpViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyOpenUpViewController.h"
#import "PVFamilyDetailViewController.h"
#import "PVInviteFamilyViewController.h"
#import "PVFamilyTelevisionPlayController.h"
#import "PVFamilyInfoModel.h"

@interface PVFamilyOpenUpViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableViewCell *telPlayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *telLookOrderCell;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) UITableView *familyTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopLayout;
@property (nonatomic, strong) UIView *memberView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic,strong)NSMutableArray *imageViewArray;
@property (nonatomic,strong)PVFamilyInfoModel * infoModel;
@property (nonatomic,strong)UIImageView * moreImageView;
@end

@implementation PVFamilyOpenUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self requestMemberData];
    self.backButton.hidden = YES;
    PV(weakSelf);
    self.familyTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [weakSelf loadRequest];
    }];
    [self.familyTableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRequest) name:FamilyGroupNameChange object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)loadRequest{
    PV(weakSelf);
    if ([PVUserModel shared].baseInfo.phoneNumber.length  < 1) {
        [self.familyTableView.mj_header endRefreshing];
        return;
    }
    [PVNetTool postDataWithParams:@{@"phone":[PVUserModel shared].baseInfo.phoneNumber} url:getFamilyInfo success:^(id result) {
         [weakSelf.familyTableView.mj_header endRefreshing];
        if (result) {
            weakSelf.infoModel = [PVFamilyInfoModel yy_modelWithJSON:result[@"data"]];
            [weakSelf requestMemberData];
            weakSelf.titlelabel.text = weakSelf.infoModel.familyName;
             [weakSelf updateMemberUI];
        }
    } failure:^(NSError *error) {
        [weakSelf.familyTableView.mj_header endRefreshing];
    }];
    
}
- (void)initUI {
    self.automaticallyAdjustsScrollViewInsets = false;
    self.headerTopLayout.constant = kiPhoneX ? 56 : 32;
    [self.view addSubview:self.familyTableView];
    
}
- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestMemberData {
    [self.headerView addSubview:self.memberView];
    [self.memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.titlelabel.mas_bottom);
        make.height.mas_equalTo(kDistanceHeightRatio(114));
    }];
    
//    UILabel *headerlabel = [UILabel sc_labelWithText:@"家人在一起，分享互助更亲近" fontSize:12 textColor:UIColorHexString(0xf2f2f2) alignment:NSTextAlignmentCenter];
    UIImageView * headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slogen"]];
    headerImage.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:headerImage];
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.equalTo(self.memberView.mas_bottom).mas_offset(kDistanceHeightRatio(26));
    }];
    
}

- (void)updateMemberUI{
    if (self.imageViewArray.count > 0) {
        for (UIImageView * imageView in self.imageViewArray) {
            [imageView removeFromSuperview];
        }
        [self.moreImageView removeFromSuperview];
    }
    //获取到array
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i<self.infoModel.familyMemberList.count; i++) {
        if (i > 3) {
            break;
        }
        PVFamilyInfoListModel * model = [self.infoModel.familyMemberList sc_safeObjectAtIndex:i];
        [array addObject:model];
    }
    CGFloat leftmargin = kDistanceWidthRatio(39);
    CGFloat viewW = kDistanceWidthRatio(50);
    CGFloat margin = (kScreenWidth - leftmargin * 2 - 5 * viewW) / 4;
    for (int i = 0; i < array.count + 1; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user1"]];
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = kDistanceWidthRatio(50) / 2.0;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.memberView addSubview:imageView];
        [self.imageViewArray addObject:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(leftmargin + (viewW + margin) * i);
            make.bottom.mas_offset(0);
            make.width.height.mas_equalTo(viewW);
        }];
        
        if (i == array.count) {
            imageView.image = [UIImage imageNamed:@"add"];
            UIImageView *tipsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_btn_more_family-text"]];
            self.moreImageView = tipsImageView;
            [self.memberView addSubview:tipsImageView];
            [tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(imageView.mas_top).mas_offset(-AUTOLAYOUTSIZE_H(9));
                make.centerX.equalTo(imageView.mas_centerX);
                make.width.mas_equalTo(kDistanceWidthRatio(77));
                make.height.mas_equalTo(kDistanceHeightRatio(35));
            }];
            UITapGestureRecognizer *addMorePerson = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMorePerson)];
            [imageView addGestureRecognizer:addMorePerson];
        }else {
            UITapGestureRecognizer *familyDetailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpTofFamilyDetailTap)];
            [imageView addGestureRecognizer:familyDetailTap];
             PVFamilyInfoListModel * model = [self.infoModel.familyMemberList sc_safeObjectAtIndex:i];
            [imageView sc_setImageWithUrlString:model.avatar placeholderImage:[UIImage imageNamed:@"user1"] isAvatar:YES];
        }
    }
}

/**添加更多家人*/
- (void)addMorePerson {
    PVInviteFamilyViewController* vc = [[PVInviteFamilyViewController alloc]  init];
    [self.navigationController pushViewController:vc animated:true];
    SCLog(@"--------添加更多-------------");
}

- (void)jumpTofFamilyDetailTap {
    PVFamilyDetailViewController *con = [[PVFamilyDetailViewController alloc] init];
    self.scNavigationItem.title = self.infoModel.familyName;
    [self.navigationController pushViewController:con animated:YES];
}
- (IBAction)familyDetailButtonClick:(id)sender {
    PVFamilyDetailViewController *con = [[PVFamilyDetailViewController alloc] init];
    [self.navigationController pushViewController:con animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        self.telPlayCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.telPlayCell;
    }
    if (indexPath.row == 1) {
        self.telLookOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.telLookOrderCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PVFamilyTelevisionPlayController *con = [[PVFamilyTelevisionPlayController alloc] init];
    if (indexPath.row == 0) {
        con.isTelevisionPlay = true;
    }else {
        con.isTelevisionPlay = false;
    }
    [self.navigationController pushViewController:con animated:YES];
}

- (UITableView *)familyTableView {
    if (!_familyTableView) {
        
//        if (@available(iOS 11.0, *)) {
//            _familyTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
//        }
//
        if (@available(iOS 11.0, *)) {
            _familyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight + kOriginY) style:UITableViewStylePlain];
        }else {
            _familyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        }
        self.headerView.sc_height = kDistanceHeightRatio(252);
        self.familyTableView.tableHeaderView = self.headerView;
        _familyTableView.delegate = self;
        _familyTableView.dataSource = self;
        _familyTableView.backgroundColor = UIColorHexString(0xf2f2f2);
        _familyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _familyTableView;
}

- (UIView *)memberView {
    if (!_memberView) {
        _memberView = [[UIView alloc] initWithFrame:CGRectZero];
        _memberView.backgroundColor = [UIColor clearColor];
    }
    return _memberView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSMutableArray *)imageViewArray{
    if (_imageViewArray == nil) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}
@end
