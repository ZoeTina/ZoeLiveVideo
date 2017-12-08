//
//  PVTelevisionCloudPlayController.m
//  PandaVideo
//
//  Created by cara on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTelevisionCloudPlayController.h"
#import "PVTelevisionFamilyTableViewCell.h"
#import "PVFamilyNoDataView.h"


static NSString* resuPVTelevisionFamilyTableViewCell = @"resuPVTelevisionFamilyTableViewCell";


@interface PVTelevisionCloudPlayController ()  <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)UIButton* covBtn;
@property(nonatomic, strong)UIView* containerView;
@property(nonatomic, strong)UITableView* familyTableView;
@property(nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic, strong)PVFamilyNoDataView* noDataView;
@property(nonatomic, strong)UIButton* myFamilyBtn;

@end

@implementation PVTelevisionCloudPlayController

-(instancetype)initIsCross:(BOOL)isCross{
    self = [super init];
    self.isCross = isCross;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}


-(void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = false;
    bool isIphoneX =  false;
    CGFloat y = isIphoneX ? (ScreenWidth*9/16 + 24) : ScreenWidth*9/16;
    [self.view addSubview:self.covBtn];
    [self.covBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (self.isCross) {
            make.top.equalTo(@(0));
        }else{
            make.top.equalTo(@(y));
        }
    }];
    
    UILabel* titleLabel = [[UILabel alloc]  init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (self.isCross) {
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
    }else{
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    }
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"电视播放";
    [self.containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView);
        make.height.equalTo(@(50));
    }];
    
    UILabel* televisionLabel = [[UILabel alloc]  init];
    televisionLabel.textAlignment = NSTextAlignmentCenter;
    televisionLabel.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    televisionLabel.font = [UIFont systemFontOfSize:13];
    televisionLabel.text = @"我的电视";
    [self.containerView addSubview:televisionLabel];
    [televisionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.left.equalTo(@(13));
        make.height.equalTo(@(25));
        make.width.equalTo(@(100));
    }];
    
    
    UIView*  televisionView = [[UIView alloc]  init];
    televisionView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self.containerView addSubview:televisionView];
    [televisionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(televisionLabel.mas_bottom).offset(0);
        make.left.equalTo(televisionLabel.mas_left).offset(0);
        make.right.equalTo(self.containerView.mas_right);
        make.height.equalTo(@(1));
    }];
    
    UIButton* myFamilyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myFamilyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [myFamilyBtn setTitleColor:[UIColor sc_colorWithHex:0x2AB4E4] forState:UIControlStateNormal];
    [myFamilyBtn setTitle:@"我的电视" forState:UIControlStateNormal];
    [self.containerView addSubview:myFamilyBtn];
    [myFamilyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.height.equalTo(@(50));
        make.top.equalTo(televisionView.mas_bottom).offset(0);
    }];
    self.myFamilyBtn = myFamilyBtn;
    
    UIView*  myFamilyView = [[UIView alloc]  init];
    myFamilyView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self.containerView addSubview:myFamilyView];
    [myFamilyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myFamilyBtn.mas_bottom).offset(0);
        make.left.equalTo(televisionLabel.mas_left).offset(0);
        make.right.equalTo(self.containerView.mas_right);
        make.height.equalTo(@(1));
    }];
    
    //[myFamilyBtn addTarget:self action:@selector(myFamilyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* noTelevisionLabel = [[UILabel alloc]  init];
    if(self.isCross){
        noTelevisionLabel.textColor = [UIColor sc_colorWithHex:0xd7d7d7];
    }else{
        noTelevisionLabel.textColor = [UIColor sc_colorWithHex:0x808080];
    }
    noTelevisionLabel.textAlignment = NSTextAlignmentCenter;
    noTelevisionLabel.font = [UIFont systemFontOfSize:13];
    noTelevisionLabel.text = @"(暂无可用的电视端)";
    noTelevisionLabel.hidden = true;
    [self.containerView addSubview:noTelevisionLabel];
    [noTelevisionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(televisionView.mas_bottom).offset(20);
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    
    UILabel* noLoginLabel = [[UILabel alloc]  init];
    noLoginLabel.hidden = true;
    if(self.isCross){
        noLoginLabel.textColor = [UIColor sc_colorWithHex:0xffffff];
    }else{
        noLoginLabel.textColor = [UIColor sc_colorWithHex:0x000000];
    }
    noLoginLabel.textAlignment = NSTextAlignmentCenter;
    noLoginLabel.font = [UIFont systemFontOfSize:13];
    noLoginLabel.text = @"请先登录“熊猫视频”电视端";
    [self.containerView addSubview:noLoginLabel];
    [noLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noTelevisionLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.containerView.mas_centerX);
    }];
    
    UILabel* familyTelevisionLabel = [[UILabel alloc]  init];
    familyTelevisionLabel.textAlignment = NSTextAlignmentCenter;
    familyTelevisionLabel.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    familyTelevisionLabel.font = [UIFont systemFontOfSize:13];
    familyTelevisionLabel.text = @"家庭圈电视";
    [self.containerView addSubview:familyTelevisionLabel];
    [familyTelevisionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noLoginLabel.mas_bottom).offset(40);
        make.left.equalTo(@(13));
        make.height.equalTo(@(25));
        make.width.equalTo(@(100));
    }];
    
    UIView*  familyTelevisionView = [[UIView alloc]  init];
    familyTelevisionView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self.containerView addSubview:familyTelevisionView];
    [familyTelevisionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(familyTelevisionLabel.mas_bottom).offset(0);
        make.left.equalTo(familyTelevisionLabel.mas_left).offset(0);
        make.right.equalTo(self.containerView.mas_right);
        make.height.equalTo(@(1));
    }];
    
    [self.containerView addSubview:self.familyTableView];
    [self.familyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(familyTelevisionView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [self.familyTableView addSubview:self.noDataView];
    [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.familyTableView);
        make.width.equalTo(@(CrossScreenWidth));
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@(200));
    }];
    
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:[UIColor sc_colorWithHex:0x000000] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.containerView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.containerView);
        make.height.equalTo(@(50));
    }];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    if(self.isCross){
        cancelBtn.hidden = true;
    }
    
    UIView* bottomView = [[UIView alloc]  init];
    bottomView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self.containerView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.bottom.equalTo(cancelBtn.mas_top).offset(0);
        make.height.equalTo(@(2));
    }];
    if(self.isCross){
        bottomView.hidden = true;
    }
    
}
-(void)cancelBtnClicked{
    [UIView animateWithDuration:0.25f animations:^{
        self.view.sc_y = CrossScreenHeight;
    } completion:^(BOOL finished) {
        self.view.hidden = true;
    }];
    //[self dismissViewControllerAnimated:true completion:nil];
}


/// MARK:- ====== UITableViewDataSource,UITableViewDelegate ==========

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.noDataView.hidden = false;
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVTelevisionFamilyTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:resuPVTelevisionFamilyTableViewCell];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6WH(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(UITableView *)familyTableView{
    if (!_familyTableView) {
        _familyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _familyTableView.contentInset = UIEdgeInsetsMake(0, 0, -52, 0);
        _familyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_familyTableView registerNib:[UINib nibWithNibName:@"PVTelevisionFamilyTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVTelevisionFamilyTableViewCell];
        if (self.isCross) {
            _familyTableView.backgroundColor = [UIColor clearColor];
        }else{
            _familyTableView.backgroundColor = [UIColor clearColor];
        }
        _familyTableView.dataSource = self;
        _familyTableView.delegate = self;
        _familyTableView.showsVerticalScrollIndicator = false;
        _familyTableView.showsVerticalScrollIndicator = false;
    }
    return _familyTableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc]  init];
        if (self.isCross) {
            _containerView.backgroundColor = [UIColor clearColor];
        }else{
            _containerView.backgroundColor = [UIColor whiteColor];
        }
    }
    return _containerView;
}
-(UIButton *)covBtn{
    if (!_covBtn) {
        _covBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _covBtn.backgroundColor = [UIColor blackColor];
        if (self.isCross) {
            _covBtn.alpha = 0.8;
        }else{
            _covBtn.alpha = 0.6;
        }
        [_covBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _covBtn;
}
-(PVFamilyNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView = [[PVFamilyNoDataView alloc]  initWithFrame:self.familyTableView.bounds];
    }
    return _noDataView;
}

@end
