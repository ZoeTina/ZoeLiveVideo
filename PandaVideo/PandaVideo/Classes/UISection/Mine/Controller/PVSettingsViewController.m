//
//  PVSettingsViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSettingsViewController.h"
#import "PVSettingsTableViewCell.h"
#import "PVClearMemoryAlertController.h"
#import "PVAboutUsViewController.h"
#import "PVWebViewController.h"

static NSString* resuPVSettingsTableViewCell = @"resuPVSettingsTableViewCell";


@interface PVSettingsViewController ()  <UITableViewDataSource,UITableViewDelegate>

///设置tableview
@property(nonatomic, strong)UITableView* settingsTableView;
///数据源
@property(nonatomic, strong)NSMutableArray* dataSource;

@end

@implementation PVSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
}
-(void)setupNavigationBar{
    self.scNavigationItem.title = @"设置";
    self.automaticallyAdjustsScrollViewInsets = false;
}
-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.settingsTableView belowSubview:self.scNavigationBar];
//    [self.view addSubview:self.settingsTableView];
}


/// MARK:- ===== UITableViewDelegate,UITableViewDataSource ==========
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PVSettingsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVSettingsTableViewCell forIndexPath:indexPath];
    cell.indexPath = indexPath;
//    NSInteger index =  (indexPath.section == 0) ? indexPath.row : ((indexPath.section == 1) ? 4 : (indexPath.row+5));
    cell.title = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }
        if (indexPath.row == 1) {
            
        }
        if (indexPath.row == 2) {
            
        }
        if (indexPath.row == 3) {
            [self clearMemory];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            PVAboutUsViewController *vc = [[PVAboutUsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {
            PVWebViewController *webCon = [[PVWebViewController alloc] initWebViewControllerWithWebUrl:loginProtocol webTitle:@"熊猫视频服务协议"];
            [self.navigationController pushViewController:webCon animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6WH(50);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)clearMemory {
    
    PVClearMemoryAlertController *con = [[PVClearMemoryAlertController alloc] init];
    con.modalPresentationStyle = UIModalPresentationCustom;
    PV(pv);
    [con setPVClearMemoryAlertControllerBlock:^(id sender) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [pv.settingsTableView reloadData];
        }];
    }];
    [self.navigationController presentViewController:con animated:NO completion:nil];
    
    
    
}
/// MARK:- ====================== 懒加载 ======================
-(UITableView *)settingsTableView{
    if (!_settingsTableView) {
        _settingsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        _settingsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _settingsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _settingsTableView.showsVerticalScrollIndicator = false;
        [_settingsTableView registerNib:[UINib nibWithNibName:@"PVSettingsTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVSettingsTableViewCell];
        _settingsTableView.delegate = self;
        _settingsTableView.dataSource = self;
        _settingsTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        
    }
    return _settingsTableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithObjects:@[@"2G/3G/4G网络下播放提醒",@"允许使用2G/3G/4G流量上传",@"允许使用2G/3G/4G流量缓存",@"清理系统缓存"],@[@"推送设置"],@[@"关于我们",@"当前版本",@"熊猫视频服务协议"], nil];
//       _dataSource = @[@"2G/3G/4G网络下播放提醒",@"允许使用2G/3G/4G流量上传",@"允许使用2G/3G/4G流量缓存",@"清理系统缓存",@"热门内容推送",@"关于我们",@"检查更新",@"客户端服务协议"];
    }
    return _dataSource;
}
@end
