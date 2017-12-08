//
//  PVVersionViewController.m
//  PandaVideo
//
//  Created by songxf on 2017/10/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVersionViewController.h"
#import "PVVersionTableViewCell.h"
#import "SCMainViewController.h"
#import "PVAdsViewController.h"
@interface PVVersionViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>
{
@private
    UITableView *_tableView;
}
@property(nonatomic,strong,readonly)UITableView * tableView;
@property(nonatomic,strong)UIButton *stopButton;
@property(nonatomic,strong)UIButton *updateButton;
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,assign)BOOL isData;//是否请求到数据
@end

@implementation PVVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isData = NO;
    //背景imageView
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"启动页-无广告"]];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.equalTo(@88.5);
    }];
    [self performSelector:@selector(skipClick) withObject:nil afterDelay:3];
    [self loadVersionAndADsRequest];
    // Do any additional setup after loading the view.
}
- (void)skipClick{
    if (self.isData) {
        return;
    }
     [self updateVersionAndAdsInfo];
}
//下载版本控制信息和引导广告
- (void)loadVersionAndADsRequest{
    NSMutableArray * pramas = [NSMutableArray array];
    PVNetModel* versionModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:versionManage param:nil];
    [pramas addObject:versionModel];
    PVNetModel* adsModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:startPage param:nil];
    [pramas addObject:adsModel];
    __weak typeof(self) weakSelf = self;
    [PVNetTool getMoreDataWithParams:pramas success:^(id result) {
        if (result) {
            if (result[@"0"]) {
                NSArray *versionArray = [NSArray yy_modelArrayWithClass:[PVVersionModel class] json:result[@"0"]];
                for (PVVersionModel * model in versionArray) {
                    if (model.type == 2) {
                        weakSelf.versionModel = model;
                    }
                }
                
            }
            if (result[@"1"]) {
                weakSelf.adsArray = [NSArray yy_modelArrayWithClass:[PVADsModel class] json:result[@"1"]];
            }
        }
        weakSelf.isData = YES;
        [weakSelf updateVersionAndAdsInfo];
    } failure:^(NSArray *errors) {
        weakSelf.isData = YES;
        [weakSelf updateVersionAndAdsInfo];
    }];
}
- (void)updateAdsInfo{
//    __weak typeof(self) weakSelf = self;
    if(self.adsArray.count > 0){
        PVAdsViewController * vc = [[PVAdsViewController alloc] init];
        vc.adsArray  = [NSMutableArray arrayWithArray:self.adsArray];;
        [self presentViewController:vc animated:NO completion:nil];
//        [self presentViewController:vc animated:NO completion:^{
//            [[UIApplication sharedApplication] keyWindow].rootViewController = vc;
//            [weakSelf removeFromParentViewController];
//        }];
    }else{
        SCMainViewController *mainViewController  = [[SCMainViewController alloc] init];
//        [self presentViewController:mainViewController animated:NO completion:^{
            kAppDelegate.window.rootViewController = mainViewController;
//            [weakSelf removeFromParentViewController];
//        }];
        
    }
}
- (void)updateVersionAndAdsInfo{
    
    if (self.versionModel.codeVerison > 1) { //跳版本页面

        [self updateAllData];
        return;

    }
    [self updateAdsInfo];
    
}

- (void)updateAllData{
    float height = [self sx_getTableViewHeight];
    [self setUpUI:height];
}

- (void)dealloc{

}


//数据请求到后设置UI
- (void)setUpUI:(float)tableHeight{
    UIView * coverView = [UIView sc_viewWithColor:[UIColor sc_colorWithHex:0x060606]];
    coverView.alpha = 0.5;
    [self.view addSubview:coverView];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-20);
        make.width.equalTo(@235);
        make.height.equalTo(@(107 + 20 + tableHeight + 44 + 15)); // 15 距离上边距5 下边距10
    }];
    
    UIImageView * topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_img_pop2"]];
    [backView addSubview:topView];
    UIView * bottomView = [UIView sc_viewWithColor:[UIColor whiteColor]];
    bottomView.layer.cornerRadius = 10;
    [backView addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView);
        make.centerX.mas_offset(0);
        make.width.equalTo(@235);
        make.height.equalTo(@(107));
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(-0.5);
        make.centerX.mas_offset(0);
        make.width.equalTo(@235);
        make.bottom.equalTo(backView);
    }];
    
    UILabel * titleLabel = [UILabel sc_labelWithText:@"软件更新" fontSize:15 textColor:[UIColor sc_colorWithHex:0x000000] alignment:NSTextAlignmentCenter];
    [bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView);
        make.width.equalTo(@100);
        make.top.mas_equalTo(0);
        make.height.equalTo(@20);
    }];
    [bottomView addSubview:self.tableView];
    [bottomView addSubview:self.stopButton];
    [bottomView addSubview:self.updateButton];
    
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bottomView);
        make.height.equalTo(@44);
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView.mas_centerX);
    }];
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stopButton);
        make.bottom.equalTo(self.stopButton);
        make.right.equalTo(bottomView);
        make.left.equalTo(bottomView.mas_centerX);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.height.equalTo(@(tableHeight));
        make.left.equalTo(bottomView);
        make.right.equalTo(bottomView);
    }];
    
    //两个图片，遮住上下圆角
    UIView *corView1 = [UIView sc_viewWithColor:[UIColor whiteColor]];
    UIView *corView2 = [UIView sc_viewWithColor:[UIColor whiteColor]];
    [backView addSubview:corView1];
    [backView addSubview:corView2];
    [corView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.top.equalTo(topView.mas_bottom).offset(-10);
        make.bottom.equalTo(bottomView.mas_top).offset(10);
        make.width.equalTo(@10);
    }];
    [corView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.top.equalTo(topView.mas_bottom).offset(-10);
        make.bottom.equalTo(bottomView.mas_top).offset(10);
        make.width.equalTo(@10);
    }];
    
    //分割线
    UIView *lineView1 = [UIView sc_viewWithColor:[UIColor sc_colorWithHex:0xdddddd]];
    UIView *lineView2 = [UIView sc_viewWithColor:[UIColor sc_colorWithHex:0xdddddd]];
    [backView addSubview:lineView1];
    [backView addSubview:lineView2];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.right.equalTo(backView);
        make.height.equalTo(@1);
        make.bottom.equalTo(backView).offset(-44);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1);
        make.bottom.equalTo(backView);
        make.centerX.equalTo(backView);
        make.width.equalTo(@1);
    }];
}

//获取到高度并且处理model
- (CGFloat)sx_getTableViewHeight{
    NSArray * titleArray = [self.versionModel.updateInfo componentsSeparatedByString:@"\n"];
    float height = 0.0;
    for (int i = 0; i<titleArray.count; i++) {
        PVVersionCellModel * model = [[PVVersionCellModel alloc] init];
        NSString * string = [NSString stringWithFormat:@"%@",[titleArray sc_safeObjectAtIndex:i]];
        string = [string stringByReplacingOccurrencesOfString:@"；" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
        model.updateText = string;
        model.cellheight = [self updateCellHeight:model.updateText];
        height =  height + model.cellheight;
        [self.listArray addObject:model];
    }
    if (height > (kScreenHeight - 107 - 20 -44 - 15 - 80 - 120)) {
        height = kScreenHeight - 107 - 20 -44 - 15 - 80 - 120;
    }
    if (height > 260) {
        height = 260;
    }
    return MAX(height, 20);
}
//更新单元格model
- (float)updateCellHeight:(NSString *)string{
    CGSize maxSize = CGSizeMake(235-44, MAXFLOAT);
    CGSize size =  [string boundingRectWithSize:maxSize
                                        options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}
                                        context:nil].size;
    
    return MAX(ceil(size.height) + 5, 20);
}

//更新
- (void)updateBtnClicked{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E7%86%8A%E7%8C%AB%E8%A7%86%E9%A2%91-%E5%9B%9B%E5%B7%9D%E6%9C%80%E5%A4%A9%E5%BA%9C%E6%8E%8C%E4%B8%8A%E8%A7%86%E9%A2%91%E6%92%AD%E6%94%BE%E5%B9%B3%E5%8F%B0/id1133394264?l=zh&ls=1&mt=8"]];
}
//取消
-(void)stopBtnClicked{
    
    if (self.versionModel.updateType) {
        exit(0);
        return;
    }
    [self updateAdsInfo];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return MAX(self.listArray.count, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     PVVersionCellModel * model = [self.listArray sc_safeObjectAtIndex:indexPath.row];
    return MAX(model.cellheight, 20);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"PVVersionTableView";
    PVVersionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PVVersionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    PVVersionCellModel * model = [self.listArray sc_safeObjectAtIndex:indexPath.row];
    cell.textLabel.text = model.updateText;
    return  cell;
    
}


#pragma setter,getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        DisableAutoAdjustScrollViewInsets(_tableView, self);
    }
    return _tableView;
}
- (UIButton *)stopButton{
    if (_stopButton == nil) {
        _stopButton = [UIButton sc_buttonWithTitle:self.versionModel.updateType?@"退出":@"暂不" fontSize:16 textColor:[UIColor sc_colorWithHex:0x808080]];
         [_stopButton addTarget:self action:@selector(stopBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}

- (UIButton *)updateButton{
    if (_updateButton == nil) {
        _updateButton = [UIButton sc_buttonWithTitle:@"立即更新" fontSize:16 textColor:[UIColor sc_colorWithHex:0x00c5ed]];
        [_updateButton addTarget:self action:@selector(updateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}

- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
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
