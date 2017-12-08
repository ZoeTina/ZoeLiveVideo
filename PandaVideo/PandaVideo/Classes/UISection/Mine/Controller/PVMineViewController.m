//
//  PVMineViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMineViewController.h"
#import "PVPersonalInfoViewController.h"
#import "PVPersonModel.h"
#import "PVPersonTableViewCell.h"
#import "PVPersonMoneyTableViewCell.h"
#import "PVPersonTableHeadView.h"
#import "PVHistoryViewController.h"
#import "PVSettingsViewController.h"
#import "PVHelpViewController.h"
#import "PVProposalViewController.h"
#import "PVOrderCenterViewController.h"
#import "PVMoneyViewController.h"
#import "PVConsumptionViewController.h"
#import "PVLoginViewController.h"
#import "PVBaseWebViewController.h"
#import "PVHelpRegistViewController.h"
#import "PVBindingTelViewController.h"
#import "PVFamilyOpenUpViewController.h"
#import "PVLookOrdermanagerViewController.h"
#import "PVLookHistoryTableViewCell.h"
#import "PVCollectionViewController.h"
#import "PVInfomationViewController.h"
#import "PVDBManager.h"
#import "PVHistoryModel.h"
#import "PVCollectionModel.h"
#import "PVVideoViewController.h"
#import "PVUgcHtmlViewController.h"
#import "PVOrderDetailModel.h"
#import "PVMyOrderHomeViewController.h"
#import "PVDemandViewController.h"


static NSString* resuPVPersonMoneyTableViewCell = @"resuPVPersonMoneyTableViewCell";
static NSString* resuPVPersonTableViewCell = @"resuPVPersonTableViewCell";

@interface PVMineViewController () <UITableViewDelegate, UITableViewDataSource, PVLookHistoryTableViewCellDelegate>

///设置tableview
@property(nonatomic, strong)UITableView* personTableView;
///数据源
@property(nonatomic, strong)NSMutableArray* dataSource;

@property(nonatomic,strong)NSMutableArray *hitoryArray;//观看历史
@property(nonatomic,strong)NSMutableArray *collectionArray;//收藏记录

@end

@implementation PVMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sc_getHistoryAndCollectionData];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self checkUserOrderListInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo) name:@"changeUserInfo" object:nil];
//    [self sc_getHistoryAndCollectionData];
}

- (void)sc_getHistoryAndCollectionData{
    if ([PVUserModel shared].userId.length != 0 || [PVUserModel shared].token.length != 0) {
        
        NSMutableDictionary *hisDic = [NSMutableDictionary dictionaryWithDictionary:@{@"index":@(1),@"pageSize":@(4),@"token":[PVUserModel shared].token,@"userId":[PVUserModel shared].userId}];
        PVNetModel *hisNetModel = [[PVNetModel alloc] init];
        hisNetModel.url = [NSString stringWithFormat:@"%@%@",DynamicUrl,getMobileHistory];
        hisNetModel.param = hisDic;
        hisNetModel.isGetOrPost = NO;
        
        NSMutableDictionary *collecDic = [NSMutableDictionary dictionaryWithDictionary:@{@"index":@(1),@"pageSize":@(4),@"token":[PVUserModel shared].token,@"userId":[PVUserModel shared].userId}];
        PVNetModel *collecNetModel = [[PVNetModel alloc] init];
        collecNetModel.url = [NSString stringWithFormat:@"%@%@",DynamicUrl,getFavList];
        collecNetModel.param = collecDic;
        collecNetModel.isGetOrPost = NO;
        
        NSArray *array = @[hisNetModel, collecNetModel];
        
        self.hitoryArray = [NSMutableArray array];
        self.collectionArray = [NSMutableArray array];
        [PVNetTool getMoreDataWithParams:array success:^(id result) {
            if (result) {
                NSDictionary *hisDic = [result pv_objectForKey:@"0"];
                NSDictionary *collDic = [result pv_objectForKey:@"1"];
                if (hisDic) {
                    if ([[hisDic pv_objectForKey:@"rs"] integerValue] == 200) {
                        PVHistoryListModel *hisListModel = [PVHistoryListModel yy_modelWithDictionary:[hisDic pv_objectForKey:@"data"]];
                        for (PVHistoryModel *hisModel in hisListModel.historyList) {
                            [self.hitoryArray addObject:hisModel];
                        }
                    }
//
                }
                if (collDic) {
                    if ([[collDic pv_objectForKey:@"rs"] integerValue] == 200) {
                        PVCollectionListModel *collListModel = [PVCollectionListModel yy_modelWithDictionary:[collDic pv_objectForKey:@"data"]];
                        for (PVCollectionModel *collModel in collListModel.favList) {
                            [self.collectionArray addObject:collModel];
                        }
                    }
                }
                [self.personTableView reloadData];
            }
        } failure:^(NSArray *errors) {
            
        }];

        
    }else {
        self.hitoryArray = [NSMutableArray arrayWithArray:[[PVDBManager sharedInstance] selectVisitVideoAllData]];
        self.collectionArray = [NSMutableArray arrayWithArray:[[PVDBManager sharedInstance] selectCollectVideoAllData]];
        [self.personTableView reloadData];
    }
    
}

- (void)changeUserInfo {
    [self setupUI];
    [self checkUserOrderListInfo];
}

-(void)setupUI{
    PVPersonTableHeadView *tableHeadView = [[[NSBundle mainBundle] loadNibNamed:@"PVPersonTableHeadView" owner:self options:nil] lastObject];
    tableHeadView.sc_width = ScreenWidth;
    tableHeadView.sc_height = ScreenWidth*160/375;
    self.personTableView.tableHeaderView = tableHeadView;
    
    PV(pv)
    [tableHeadView setPersonTableHeadViewBlock:^{
        
        if ([PVUserModel shared].userId.length == 0) {
            PVLoginViewController *loginCon = [[PVLoginViewController alloc] init];
            [pv.navigationController pushViewController:loginCon animated:YES];
        }else{
            PVPersonalInfoViewController *view = [[PVPersonalInfoViewController alloc] init];
            [pv.navigationController pushViewController:view animated:YES];
            YYLog(@"------个人信息");
        }
        
    }];
    
}

/// MARK:- ========== UITableViewDelegate,UITableViewDataSource ========
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            NSArray *subArray = [self.dataSource sc_safeObjectAtIndex:0];
            return subArray.count;
        }
            break;
        case 1:{
            NSArray *subArray = [self.dataSource sc_safeObjectAtIndex:1];
            return subArray.count;
        }
            break;
        default:{
            NSArray *subArray = [self.dataSource sc_safeObjectAtIndex:2];
            return subArray.count;
        }
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        PVPersonMoneyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVPersonMoneyTableViewCell forIndexPath:indexPath];
        
        PVPersonModel* model = self.dataSource[indexPath.section][indexPath.row];
        model.index = indexPath.item;
        NSString *balance = [NSString stringWithFormat:@"%ld",[PVUserModel shared].pandaAccount.balance];
        model.subtitle = (model.index == 0) ? @"" : balance;
        cell.personModel = model;
        
        return cell;
    }
    if (indexPath.section == 1 ) {
        //
        if ((indexPath.row == 0 && self.hitoryArray.count > 0) || (indexPath.row == 1 && self.collectionArray.count > 0)) {
            static NSString *CellIdentifier = @"PVLookHistoryTableViewCell";
            PVLookHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[PVLookHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            cell.cellDelegate = self;
            //获取上边内容
//            NSInteger index = indexPath.section+indexPath.item+1;
            PVPersonModel* model = self.dataSource[indexPath.section][indexPath.row];
            model.index = indexPath.item;
            cell.personModel = model;
            [cell tableViewDataSource:indexPath.row ? self.collectionArray:self.hitoryArray isHistory:!indexPath.row];
            return cell;
        }
    }
    PVPersonTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVPersonTableViewCell forIndexPath:indexPath];
//    NSInteger index = indexPath.section == 1 ? (indexPath.section+indexPath.item+1) : (indexPath.section+indexPath.item+3);
    PVPersonModel* model = self.dataSource[indexPath.section][indexPath.row];
    model.index = indexPath.item;
    cell.personModel = model;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 ) {
        if ((indexPath.row == 0 && self.hitoryArray.count > 0) || (indexPath.row == 1 && self.collectionArray.count > 0)) {
            return 157;
        }
    }
    switch (indexPath.section) {
        case 0:
            return IPHONE6WH(65);
            break;
        default:
            return IPHONE6WH(50);
            break;
    }
}
///各种点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//跳订购中心和熊猫钱包
        indexPath.row == 0 ? [self jumpOrderVC] : [self jumpMoneyVC];
    }else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0://观看历史
                [self jumpHistoryVC];
                break;
            case 1://收藏记录
                [self jumpCollectVC];
                break;
            case 2://消息记录
                [self jumpInfomationVC];
                break;
            case 3:
                [self jumpMyVideoVC];
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0://设置
                [self jumpSettingsVC];
                break;
            case 1://帮助
                [self jumpHelpsVC];
                break;
            case 2://意见反馈
                [self jumpAdvanceVC];
                break;
            default:
                break;
        }
    }
}
-(void)jumpOrderVC{
    NSMutableArray *subArray = [self.dataSource sc_safeObjectAtIndex:0];
    PVPersonModel* personModel = [subArray sc_safeObjectAtIndex:0];
    if ([personModel.title isEqualToString:@"我的订购"]) {
        PVMyOrderHomeViewController *con= [[PVMyOrderHomeViewController alloc] init];
        [self.navigationController pushViewController:con animated:YES];
    }else {
        PVOrderCenterViewController* vc = [[PVOrderCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }
   
}

-(void)jumpMoneyVC{
    
    if ([self isLogin]){
        PVMoneyViewController* vc = [[PVMoneyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }
}
-(void)jumpHistoryVC{
    
    PVHistoryViewController* vc = [[PVHistoryViewController alloc]  init];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:true];
    
//    PVUgcHtmlViewController *con = [[PVUgcHtmlViewController alloc] init];
//    [self.navigationController pushViewController:con animated:YES];
}

-(void)jumpCollectVC{
    
    PVCollectionViewController *vc = [[PVCollectionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpMyVideoVC {
//    if ([self isLogin]) {
        PVVideoViewController *view = [[PVVideoViewController alloc] init];
        [self.navigationController pushViewController:view animated:true];
//    }
}
/** 消费记录-充值记录*/
-(void)jumpConsumptionVC{
    if ([self isLogin]) {
        PVConsumptionViewController *view = [[PVConsumptionViewController alloc] init];
        [self.navigationController pushViewController:view animated:true];
    }
}

- (void)jumpInfomationVC {
    if ([self isLogin]) {
        PVInfomationViewController *con = [[PVInfomationViewController alloc] init];
        [self.navigationController pushViewController:con animated:YES];
    }
}

-(void)jumpSettingsVC{
    PVSettingsViewController* vc = [[PVSettingsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}
-(void)jumpHelpsVC{
    PVHelpViewController* vc = [[PVHelpViewController alloc]  init];
    [self.navigationController pushViewController:vc animated:true];
    
}
-(void)jumpAdvanceVC{
    if ([self isLogin]) {
        PVProposalViewController* vc = [[PVProposalViewController alloc]  init];
        [self.navigationController pushViewController:vc animated:true];
    }
}

//历史和收藏记录跳转
- (void)historyorCollectionCellClickWithUrl:(NSString *)url code:(NSString *)code{
    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
    
    if (url.length > 0) {
        vc.url = url;
        vc.code = code;
        [self.navigationController pushViewController:vc animated:true];
    }else {
        Toast(@"视频链接为空");
    }
}

- (BOOL)isLogin {
   
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        PVLoginViewController *loginCon = [[PVLoginViewController alloc] init];
        [self.navigationController pushViewController:loginCon animated:YES];

        return NO;
    }
     return YES;
    
}
/// MARK:- ====================== 懒加载 ======================
-(UITableView *)personTableView{
    if (!_personTableView) {
        _personTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        _personTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _personTableView.showsVerticalScrollIndicator = false;
        [_personTableView registerNib:[UINib nibWithNibName:@"PVPersonMoneyTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVPersonMoneyTableViewCell];
        [_personTableView registerNib:[UINib nibWithNibName:@"PVPersonTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVPersonTableViewCell];
        _personTableView.delegate = self;
        _personTableView.dataSource = self;
        _personTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _personTableView.sectionFooterHeight = 1.0;
        _personTableView.sectionHeaderHeight = 1.0;
        [self.view addSubview:_personTableView];
    }
    return _personTableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        NSArray* titleArr = @[@[@"订购中心",@"喵币钱包"],@[@"观看历史",@"收藏记录",@"消息记录",@"我的视频"],@[@"设置",@"帮助",@"意见反馈"]];
        NSArray* imagesArr = @[@[@"mine_icon_store",@"mine_icon_wallet"],@[@"mine_icon_history",@"mine_icon_collection",@"mine_icon_message",@"mine_icon_video"],@[@"mine_icon_setup",@"mine_icon_help",@"mine_icon_opinion"]];
//        NSArray* titleArr = @[@"订购中心",@"熊猫钱包",@"观看历史",@"收藏记录",@"消息记录",@"我的视频",@"设置",@"帮助",@"意见反馈"];
//        NSArray* imagesArr = @[@"mine_icon_store",@"mine_icon_wallet",@"mine_icon_history",@"mine_icon_collection",@"mine_icon_message",@"mine_icon_video",@"mine_icon_setup",@"mine_icon_help",@"mine_icon_opinion"];
        
        for (int i=0; i<titleArr.count; i++) {
            NSArray *subTitlesArray = [titleArr sc_safeObjectAtIndex:i];
            NSArray *subImagesArray = [imagesArr sc_safeObjectAtIndex:i];
            NSMutableArray *subArray = [NSMutableArray array];
            for (int j = 0; j < subTitlesArray.count; j ++) {
                PVPersonModel* personModel = [[PVPersonModel alloc] init];
                personModel.title = [subTitlesArray sc_safeObjectAtIndex:j];
                personModel.imageText = [subImagesArray sc_safeObjectAtIndex:j];
                [subArray addObject:personModel];
            }
            [_dataSource addObject:subArray];
        }
    }
    return _dataSource;
}


- (void)checkUserOrderListInfo {
    if ([PVUserModel shared].userId.length == 0 || [PVUserModel shared].token.length == 0) {
        NSMutableArray *subArray = [self.dataSource sc_safeObjectAtIndex:0];
        PVPersonModel* personModel = [subArray sc_safeObjectAtIndex:0];
        personModel.title = @"订购中心";
        [self.personTableView reloadData];
    }else {
        PVUserModel *userModel = [PVUserModel shared];
        for (PVOrderInfoModel *infoModel in userModel.orderInfo) {
            if (infoModel.orderId.length > 0) {
                NSMutableArray *subArray = [self.dataSource sc_safeObjectAtIndex:0];
                PVPersonModel* personModel = [subArray sc_safeObjectAtIndex:0];
                personModel.title = @"我的订购";
                [self.personTableView reloadData];
                break;
            }
        }
    }
}


@end
