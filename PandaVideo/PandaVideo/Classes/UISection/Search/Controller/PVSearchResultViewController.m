//
//  PVSearchResultViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSearchResultViewController.h"
#import "PVSearchResultCell.h"
#import "PVSearchResultTextCell.h"
#import "PVDemandTableFootView.h"
#import "PVSearchResultNumber.h"
#import "PVDemandRecommandTableViewCell.h"
#import "PVAnthologyViewController.h"
#import "PVSearchResultModel.h"
#import "PVSearchResultMoreViewController.h"
#import "PVDemandVideoAnthologyModel.h"
#import "PVDemandViewController.h"
#import "PVNoProGramView.h"

static NSString * const resuPVSearchResultCell = @"resuPVSearchResultCell";
static NSString * const resuPVSearchResultTextCell = @"resuPVSearchResultTextCell";
static NSString * const resuPVSearchResultMoreCell = @"resuPVSearchResultMoreCell";
static NSString * const resuPVSearchResultNumber = @"resuPVSearchResultNumber";
static NSString* resuPVDemandRecommandTableViewCell = @"resuPVDemandRecommandTableViewCell";

@interface PVSearchResultViewController ()  <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView* searchResultTableView;
@property(nonatomic, strong)NSMutableArray* dataSource;
@property (nonatomic, strong)PVNoProGramView* noProGramView;

@end

@implementation PVSearchResultViewController


-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.searchResultTableView];
    [self.searchResultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.noProGramView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(@(10));
    }];

    
}

-(void)reloadSearchresultData:(NSArray*)dataSource{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:dataSource];
    [self.searchResultTableView reloadData];
}


/// MARK:- ====== UITableViewDataSource,UITableViewDelegate ==========

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    self.noProGramView.hidden = self.dataSource.count;
    return MAX(self.dataSource.count, 0);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PVSearchVideoListModel * model = [self.dataSource sc_safeObjectAtIndex:section];
    
    if (model.videoType == 1) {
        if (model.showModel == 1) { //数字
            return 2;
        }
        return model.episodeList.count > 1 ? (2+model.episodeList.count) : model.episodeList.count;
        ;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVSearchVideoListModel * model = [self.dataSource sc_safeObjectAtIndex:indexPath.section];
    NSInteger  cellStatus = 0;
    if (model.videoType == 0) {//单集
        if (model.isMovie == 0) {//其它单集
            cellStatus = 1;
        }else{//电影
            cellStatus = 2;
        }
    }else if (model.videoType == 1){
        cellStatus = 3;
    }
    //控制cell的显示
    if (cellStatus == 1) { //横图
        PVDemandRecommandTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVDemandRecommandTableViewCell];
        cell.isSearch = true;
        cell.searchVideoListModel = model;
        return cell;
    }else if (cellStatus == 2){//电影
        PVSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVSearchResultCell];
        cell.model = model;
        PV(weakSelf);
        //tv播放
        cell.playTVBlock = ^{
            [weakSelf playVideoWithVideoId:model.code];
        };
        //
        cell.addCloudBlock = ^(UIButton *button) {
            [weakSelf deleteOrAddCloudVideo:!button.selected videoId:model.code button:button];
        };
        return cell;
    }else{
        //竖图
        if (indexPath.row == 0) {
            PVSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVSearchResultCell];
            cell.model = model;
            PV(weakSelf);
            //tv播放
            cell.playTVBlock = ^{
                [weakSelf playVideoWithVideoId:model.code];
            };
            //
            cell.addCloudBlock = ^(UIButton *button) {
                [weakSelf deleteOrAddCloudVideo:!button.selected videoId:model.code button:button];
            };
            return cell;
        }
        if (model.showModel == 1) { //纯数字
            PVSearchResultNumber* cell = [tableView dequeueReusableCellWithIdentifier:resuPVSearchResultNumber];
            cell.dataSource = model.episodeList;
            PV(pv)
            [cell setPVSearchResultNumberBlock:^(NSInteger index) {
                if (index == 5) {
                    PVSearchResultMoreViewController * vc = [[PVSearchResultMoreViewController alloc] init];
                    vc.videoTitle = model.videoTitle;
                    vc.url = model.videoUrl;
                    vc.showType = 1;
                    [pv.navigationController pushViewController:vc animated:true];
                }else{//调剧集
                    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
                    PVSearchEpisodeListModel* episodeListModel = model.episodeList[index];
                    vc.url = episodeListModel.episodeModel.videoUrl;
                    vc.code = episodeListModel.episodeModel.code;
                    vc.isScroll = true;
                    [pv.navigationController pushViewController:vc animated:true];
                }
            }];
            return cell;
        }
        if (indexPath.row >= 3) { //更多选项
            PVSearchResultMoreCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVSearchResultMoreCell];
            return cell;
        }
        //图文cell
        PVSearchResultTextCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVSearchResultTextCell];
        cell.episodeListModel = model.episodeList[indexPath.row-1];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVSearchVideoListModel * model = [self.dataSource sc_safeObjectAtIndex:indexPath.section];
    
    NSInteger  cellStatus = 0;
    if (model.videoType == 0) {//单集
        if (model.isMovie == 0) {//其它单集
            cellStatus = 1;
        }else{//电影
            cellStatus = 2;
        }
    }else if (model.videoType == 1){//多集
        cellStatus = 3;
    }
    ///控制高度
    if (cellStatus == 1) {
        return 100;
    }else if (cellStatus == 2){
        return 170;
    }
    if (indexPath.row == 0) {
        return 170;
    }
    if (model.showModel == 1) {
        return 80;
    }
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   PVSearchVideoListModel * model = [self.dataSource sc_safeObjectAtIndex:indexPath.section];
    NSInteger  cellStatus = 0;
    if (model.videoType == 0) {//单集
        if (model.isMovie == 0) {//其它单集
            cellStatus = 1;
        }else{//电影
            cellStatus = 2;
        }
    }else if (model.videoType == 1){//多集
        cellStatus = 3;
    }
    if (cellStatus == 1) { //横图(单集)
        PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
        vc.url = model.videoUrl;
        [self.navigationController pushViewController:vc animated:true];
    }else{
        if (indexPath.row == 0){//剧头开始
            PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
            vc.url = model.videoUrl;
            [self.navigationController pushViewController:vc animated:true];
            NSLog(@"剧头开始");
        }else{
            if (model.showModel == 1) {//数字
                return;
            }else{//文字
                if (indexPath.row >= 3) { //更多选项
                    PVSearchResultMoreViewController * vc = [[PVSearchResultMoreViewController alloc] init];
                    vc.videoTitle = model.videoTitle;
                    vc.url = model.videoUrl;
                    vc.showType = 2;
                    [self.navigationController pushViewController:vc animated:true];
                    NSLog(@"更多选项");
                }else{//剧集
                    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
                    PVSearchEpisodeListModel* episodeListModel = model.episodeList[indexPath.item-1];
                    vc.url = episodeListModel.episodeModel.videoUrl;
                    vc.code = episodeListModel.episodeModel.code;
                    vc.isScroll = true;
                    [self.navigationController pushViewController:vc animated:true];
                    NSLog(@"剧集");
                }
            }
        }
    }
    
//    if (indexPath.row == 3) {
       // [self sc_skipInfoVCWithModel:model];
//        return;
//    }
}

-(UITableView *)searchResultTableView{
    if (!_searchResultTableView) {
        _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //横图
        [_searchResultTableView registerNib:[UINib nibWithNibName:@"PVDemandRecommandTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVDemandRecommandTableViewCell];
        //竖图
        [_searchResultTableView registerNib:[UINib nibWithNibName:@"PVSearchResultCell" bundle:nil] forCellReuseIdentifier:resuPVSearchResultCell];
        //数字
        [_searchResultTableView registerClass:[PVSearchResultNumber class] forCellReuseIdentifier:resuPVSearchResultNumber];
        //图文
        [_searchResultTableView registerClass:[PVSearchResultTextCell class] forCellReuseIdentifier:resuPVSearchResultTextCell];
        [_searchResultTableView registerClass:[PVSearchResultMoreCell class] forCellReuseIdentifier:resuPVSearchResultMoreCell];
        
        _searchResultTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _searchResultTableView.dataSource = self;
        _searchResultTableView.delegate = self;
        _searchResultTableView.showsVerticalScrollIndicator = false;
        _searchResultTableView.showsVerticalScrollIndicator = false;
        _searchResultTableView.contentInset = UIEdgeInsetsMake(1, 0, 0, 0);
    }
    return _searchResultTableView;
}
//跳转详情页面
- (void)sc_skipInfoVCWithModel:( PVSearchVideoListModel  *)videoModel{
//    PVSearchResultMoreViewController * vc = [[PVSearchResultMoreViewController alloc] init];
//    vc.dataSource = [self sc_getMoreArray:videoModel];
//    [self presentViewController:vc animated:YES completion:nil];
}
//获取到需要的数组
- (NSMutableArray *)sc_getMoreArray:( PVSearchVideoListModel  *)videoModel{
    NSMutableArray * array = [NSMutableArray array];
    for (PVSearchEpisodeListModel * model in videoModel.episodeList) {
        PVDemandVideoAnthologyModel * antoModel = [[PVDemandVideoAnthologyModel alloc] init];
        antoModel.showModel =  [NSString stringWithFormat:@"%ld",videoModel.showModel];
        antoModel.videoUrl = model.episodeModel.videoUrl;
        antoModel.videoName = model.episodeModel.videoName;
        antoModel.videoType = model.episodeModel.videoType;
        antoModel.horizontalPic = model.episodeModel.horizontalPic;
        antoModel.verticalPic = model.episodeModel.verticalPic;
        antoModel.videoId = @"";
        antoModel.code = model.episodeModel.code;
        antoModel.sort =  [NSString stringWithFormat:@"%ld",model.episodeModel.sort];
        antoModel.count = [NSString stringWithFormat:@"%ld",videoModel.episodeList.count];
        antoModel.isPlaying = @"";
        antoModel.playStopTime = @"";
        antoModel.playVideoLength = @"";
        antoModel.totalVideoLength = @"";
        antoModel.jsonUrl = @"";
        
    }
    
    return array;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark -- 添加删除云看单
-(void)deleteOrAddCloudVideo:(BOOL)isAdd videoId:(NSString *)videoId  button:(UIButton *)button{
    PV(weakSelf);
    if ([PVUserModel shared].baseInfo.phoneNumber.length  < 1) {
        return;
    }
    if (self.targetPhone.length  < 1) {
        return;
    }
    if ([NSString sc_stringForKey:MyFamilyGroupId].length  < 1) {
        return;
    }
    if (videoId.length < 1) {
        return;
    }
    
    NSDictionary * dic = @{@"familyId":[NSString sc_stringForKey:MyFamilyGroupId],
                           @"phone":[PVUserModel shared].baseInfo.phoneNumber,
                           @"targetPhone":self.targetPhone,
                           isAdd? @"videoId":@"videoIds":videoId};
    [PVNetTool postDataWithParams:dic url: isAdd ? addCloudVideo:deleteCloudVideo success:^(id result) {
        NSString * errorMsg  = result[@"errorMsg"];
        if (errorMsg.length > 0) {
            Toast(errorMsg);
            return ;
        }
        button.selected = isAdd;
        [weakSelf.searchResultTableView reloadData];
        Toast(isAdd ? @"添加云看单成功" : @"删除云看单成功");
    } failure:^(NSError *error) {
        Toast(isAdd ? @"添加云看单失败" : @"删除云看单失败");
    }];
}
#pragma mark --tv端播放视频

-(void)playVideoWithVideoId:(NSString *)videoId{
    PV(weakSelf);
    if ([PVUserModel shared].baseInfo.phoneNumber.length  < 1) {
        return;
    }
    if (self.targetPhone.length  < 1) {
        return;
    }
    if ([NSString sc_stringForKey:MyFamilyGroupId].length  < 1) {
        return;
    }
    if (videoId.length < 1) {
        return;
    }
    NSInteger isFrom = 1;
    if (self.isFamily) {
        isFrom = 2;
    }
    NSDictionary * dic = @{@"phone":[PVUserModel shared].baseInfo.phoneNumber,
                           @"targetPhone":self.targetPhone,
                           @"videoId":videoId,
                           @"isFrom":[NSNumber numberWithInteger:isFrom]
                           };
    [PVNetTool postDataWithParams:dic url: playVideoForTV success:^(id result) {
        NSString * errorMsg  = result[@"errorMsg"];
        if (errorMsg.length > 0) {
            Toast(errorMsg);
            return ;
        }
        Toast(@"tv端播放成功");
        [weakSelf.searchResultTableView reloadData];
    } failure:^(NSError *error) {
        Toast(@"TV端播放失败");
    }];
}

-(PVNoProGramView *)noProGramView{
    if (!_noProGramView) {
        _noProGramView = [[NSBundle mainBundle] loadNibNamed:@"PVNoProGramView" owner:nil options:0].lastObject;
        _noProGramView.noDataLabel.text = @"未找到相关视频";
        _noProGramView.noDataImageView.image = [UIImage imageNamed:@"img_novideo"];
        [self.searchResultTableView addSubview:_noProGramView];
    }
    return _noProGramView;
}

@end
