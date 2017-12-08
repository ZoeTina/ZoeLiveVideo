//
//  PVFamilyTelevisionPlayController.m
//  PandaVideo
//
//  Created by cara on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyTelevisionPlayController.h"
#import "PVTelevisionPlayCell.h"
#import "PVTelevisionNoDataView.h"
#import "PVSerachViewController.h"
#import "PVTelevisionCloudViewController.h"
#import "PVFamilyInfoModel.h"
#import "PVTeleCloudVideoModel.h"
static NSString* resuPVTelevisionPlayCell = @"resuPVTelevisionPlayCell";

@interface PVFamilyTelevisionPlayController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView* televisionTabelview;
@property(nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic, strong)PVTelevisionNoDataView* noDataView;

@end

@implementation PVFamilyTelevisionPlayController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    PV(weakSelf);
    self.televisionTabelview.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [weakSelf loadRequest];
    }];
    [self.televisionTabelview.mj_header beginRefreshing];
}

- (void)loadRequest{
    PV(weakSelf);
    if ([PVUserModel shared].baseInfo.phoneNumber.length  < 1) {
        [weakSelf.televisionTabelview.mj_header endRefreshing];
        return;
    }
    [PVNetTool postDataWithParams:@{@"phone":[PVUserModel shared].baseInfo.phoneNumber} url:getFamilyInfo success:^(id result) {
        [weakSelf.televisionTabelview.mj_header endRefreshing];
        if (result) {
            PVFamilyInfoModel *infoModel = [PVFamilyInfoModel yy_modelWithJSON:result[@"data"]];
            if (weakSelf.dataSource.count > 0) {
                [weakSelf.dataSource removeAllObjects];
            }
            for (PVFamilyInfoListModel * model in infoModel.familyMemberList) {
//                if (model.isBindTV) {
                    [weakSelf.dataSource addObject:model];
//                }
            }
            [weakSelf.televisionTabelview reloadData];
        }
    } failure:^(NSError *error) {
        [weakSelf.televisionTabelview.mj_header endRefreshing];
    }];
}

-(void)setupNavigationBar{
    if(self.isTelevisionPlay){
        self.scNavigationItem.title = @"电视播放";
    }else{
        self.scNavigationItem.title = @"电视云看单";
    }
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.televisionTabelview belowSubview:self.scNavigationBar];
}


/// MARK:- ====== UITableViewDataSource,UITableViewDelegate ==========

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //self.noDataView.hidden = self.dataSource.count;
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVTelevisionPlayCell *cell =  [tableView dequeueReusableCellWithIdentifier:resuPVTelevisionPlayCell];
    cell.model = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isTelevisionPlay) {
        PVFamilyInfoListModel *infoModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
        PVSerachViewController* vc = [[PVSerachViewController alloc]  init];
        vc.isFamily = true;
        vc.nikename = infoModel.nickName;
        vc.targetPhone = infoModel.phone;
        vc.nav = self.navigationController;
        [self.navigationController pushViewController:vc animated:true];
        
        [self presentViewController:vc animated:false completion:nil];
    }else{
        [self getTVAuthorizeForPhone:indexPath.row];
    }
}

//获取tv端授权
- (void)getTVAuthorizeForPhone:(NSInteger)index{
    PV(weakSelf);
    NSString * phone = [PVUserModel shared].baseInfo.phoneNumber;
    NSString *familyId = [NSString sc_stringForKey:MyFamilyGroupId];
    PVFamilyInfoListModel *infoModel = [self.dataSource sc_safeObjectAtIndex:index];
    NSString *targetPhone = infoModel.phone;
    if (phone.length  < 1) {
        return;
    }
    if (familyId.length < 1) {
        return;
    }
    if (targetPhone.length < 1) {
        return;
    }
    [PVNetTool postDataWithParams:@{@"familyId":familyId,@"phone":phone,@"targetPhone":targetPhone} url:getTVAuthorizeByPhone success:^(id result) {
        NSString *errorMsg = [NetWorkAnalysisTool analysisNetworkDataWithDict:result url:login];
        if (errorMsg.length > 0) {
            Toast(errorMsg);
            return ;
        }
        if (result) {
            PVTeleCloudAuthorizeModel * model = [PVTeleCloudAuthorizeModel yy_modelWithJSON:result[@"data"]];
            if (model.isAuthorize) {
                PVTelevisionCloudViewController* vc = [[PVTelevisionCloudViewController alloc]  init];
                vc.targetPhone = targetPhone;
                vc.nikeName = infoModel.nickName;
                [weakSelf.navigationController pushViewController:vc animated:true];
            }else{
                [weakSelf sc_requestTVAuthorize:targetPhone nikeName:infoModel.nickName];
            }
        }
    } failure:^(NSError *error) {
    }];
}
//请求tv端授权
- (void)sc_requestTVAuthorize:(NSString *)targetPhone  nikeName:(NSString *)nikeName{
    PV(weakSelf);
    NSString * phone = [PVUserModel shared].baseInfo.phoneNumber;
    NSString *familyId = [NSString sc_stringForKey:MyFamilyGroupId];
    if (phone.length  < 1) {
        return;
    }
    if (familyId.length < 1) {
        return;
    }
    if (targetPhone.length < 1) {
        return;
    }
    [PVNetTool postDataWithParams:@{@"familyId":familyId,@"phone":phone,@"targetPhone":targetPhone} url:requestTVAuthorize success:^(id result) {
        NSString * errorMsg = result[@"errorMsg"];
        if (errorMsg.length > 0) {
            Toast(@"授权失败");
            return ;
        }
        if (result) {
            PVTelevisionCloudViewController* vc = [[PVTelevisionCloudViewController alloc]  init];
            vc.targetPhone = targetPhone;
            vc.nikeName = nikeName;
            [weakSelf.navigationController pushViewController:vc animated:true];
        }
    } failure:^(NSError *error) {
    }];
}
-(UITableView *)televisionTabelview{
    if (!_televisionTabelview) {
        _televisionTabelview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _televisionTabelview.frame = self.view.bounds;
        CGFloat bottom = kiPhoneX ? 34 : 0;
        _televisionTabelview.sc_height = self.view.sc_height-bottom;
        _televisionTabelview.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 0, 0);
        _televisionTabelview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_televisionTabelview registerNib:[UINib nibWithNibName:@"PVTelevisionPlayCell" bundle:nil] forCellReuseIdentifier:resuPVTelevisionPlayCell];
        _televisionTabelview.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _televisionTabelview.dataSource = self;
        _televisionTabelview.delegate = self;
        _televisionTabelview.showsVerticalScrollIndicator = false;
        _televisionTabelview.showsVerticalScrollIndicator = false;
    }
    return _televisionTabelview;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(PVTelevisionNoDataView *)noDataView{
    if (!_noDataView) {
        _noDataView =  [[NSBundle mainBundle] loadNibNamed:@"PVTelevisionNoDataView" owner:nil options:nil ].lastObject;
        _noDataView.hidden = true;
        _noDataView.frame = self.view.bounds;
        [self.view insertSubview:_noDataView belowSubview:self.scNavigationBar];
    }
    return _noDataView;
}

@end
