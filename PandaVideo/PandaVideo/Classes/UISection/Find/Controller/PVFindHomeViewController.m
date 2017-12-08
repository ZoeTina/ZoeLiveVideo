//
//  PVFindHomeViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFindHomeViewController.h"
#import "PVFindHomeTableViewCell.h"
#import "PVFindHomeModel.h"
#import "PVFindColumnViewController.h"
#import "PVFindCommentController.h"
#import "PVLoginViewController.h"
#import "PVShareViewController.h"
#import "PVVideoShareView.h"
#import "PVShareTool.h"

#define videoMoreHeight  342*CaraScreenH/1334

static NSString* resuPVFindHomeTableViewCell = @"resuPVFindHomeTableViewCell";

@interface PVFindHomeViewController () <UITableViewDataSource,UITableViewDelegate,VideoPlayerViewDelegate>

@property(nonatomic, strong)UITableView* findTableView;
@property(nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic, strong)NSIndexPath *selectedIndexPath;
@property(nonatomic, strong)PVFindHomeModel* seletcedModel;
@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic, assign)NSInteger pageAllIndex;
///分享
@property(nonatomic, strong)PVVideoShareView* videoShareView;
///遮盖
@property(nonatomic, strong)UIButton* coverBtn;

@end

@implementation PVFindHomeViewController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self videoStopPlay];
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"发现";
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.findTableView belowSubview:self.scNavigationBar];
    PV(pv)

    self.findTableView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        [pv loadData];
    }];
    [self.findTableView.mj_header beginRefreshing];
    self.findTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        if(pv.currentIndex == pv.pageAllIndex)return;
        pv.currentIndex++;
        [pv loadMoreData];
    }];
}
-(void)loadData{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"index"];
    [params setObject:@"10" forKey:@"pageSize"];
    if ([PVUserModel shared].token.length) {
        [params setObject:[PVUserModel shared].token forKey:@"token"];
        [params setObject:[PVUserModel shared].userId forKey:@"userId"];
    }else{
        [params setObject:@" " forKey:@"token"];
        [params setObject:@" " forKey:@"userId"];
    }
    [PVNetTool postDataWithParams:params url:@"getFindData" success:^(id result) {
        [self.findTableView.mj_header endRefreshing];
        [self.findTableView.mj_footer resetNoMoreData];
        if (result[@"data"][@"findList"] &&  [result[@"data"][@"findList"] isKindOfClass:[NSArray class]]) {
            [self.dataSource removeAllObjects];
            NSArray* jsonArr = result[@"data"][@"findList"];
            for (NSDictionary* jsonDict in jsonArr) {
                PVFindHomeModel* model = [[PVFindHomeModel alloc]  init];
                model.isHiddenPlayBtn = false;
                model.cellHeight = ScreenWidth*9/16 + 150;
                [model setValuesForKeysWithDictionary:jsonDict];
                [self.dataSource addObject:model];
            }
            self.currentIndex = 1;
            self.pageAllIndex = [NSString stringWithFormat:@"%@",result[@"data"][@"pageAllIndex"]].integerValue;
        }
        [self.findTableView reloadData];
    } failure:^(NSError *error) {
        [self.findTableView.mj_header endRefreshing];
        [MBProgressHUD showError:@"网络连接失败" toView:self.view];
    }];
}

-(void)loadMoreData{
    NSDictionary* params = @{@"index":@(self.currentIndex),@"pageSize":@"10"};
    [PVNetTool postDataWithParams:params url:@"getFindData" success:^(id result) {
        [self.findTableView.mj_footer endRefreshing];
        if (result[@"data"][@"findList"] &&  [result[@"data"][@"findList"] isKindOfClass:[NSArray class]]) {
            NSArray* jsonArr = result[@"data"][@"findList"];
            for (NSDictionary* jsonDict in jsonArr) {
                PVFindHomeModel* model = [[PVFindHomeModel alloc]  init];
                model.cellHeight = ScreenWidth*9/16 + 150;
                model.isHiddenPlayBtn = false;
                [model setValuesForKeysWithDictionary:jsonDict];
                [self.dataSource addObject:model];
            }
            self.pageAllIndex = [NSString stringWithFormat:@"%@",result[@"data"][@"pageAllIndex"]].integerValue;
        }else{
            self.currentIndex--;
        }
        [self.findTableView reloadData];
    } failure:^(NSError *error) {
        [self.findTableView.mj_footer endRefreshing];
        self.currentIndex--;
        [MBProgressHUD showError:@"网络连接失败" toView:self.view];
    }];
    
}



/// MARK:- ====== UITableViewDataSource,UITableViewDelegate ==========

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PVFindHomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[NSBundle mainBundle]  loadNibNamed:@"PVFindHomeTableViewCell" owner:self options:nil].lastObject;
    }
    PVFindHomeModel* findModel = self.dataSource[indexPath.row];
    
    PV(pv)
    __block UIView* superView = cell.videoContanierView;
    [cell setImageViewClickedBlock:^(UIButton * btn) {//播放短视频
        pv.selectedIndexPath = indexPath;
        [pv videoStopPlay];
        [pv playVideo:findModel.videoUrl superView:superView];
    }];
    
    cell.findHomeModel = findModel;

    [cell setCommentBtnClickedBlock:^(UIButton * btn) {
        PVFindCommentController* vc = [[PVFindCommentController alloc]  init];
        vc.findHomeModel = findModel;
        [pv.navigationController  pushViewController:vc animated:true];
    }];
    //是否点赞
    [cell  setPraiseBtnClickedBlock:^(UIButton *  btn) {
        if (![PVUserModel shared].token.length) {
            PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
            [loginVC setPVLoginViewControllerLoginSuccess:^{
                [pv loadData];
            }];
            [pv.navigationController pushViewController:loginVC animated:true];
            return;
        }
        NSInteger upIndex = findModel.upCount.intValue;
        if (findModel.isUp.intValue) {//取消点赞
            findModel.isUp = @"0";
            if(upIndex){
                upIndex--;
                findModel.upCount = [NSString stringWithFormat:@"%ld",upIndex];
            }
            [pv cancelPraise:true code:findModel.code];
        }else{//点赞
            findModel.isUp = @"1";
            upIndex++;
            findModel.upCount = [NSString stringWithFormat:@"%ld",upIndex];
            [pv cancelPraise:false code:findModel.code];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [cell  setShareBtnClickedBlock:^(UIButton * btn) {
        PVShareViewController *shareCon = [[PVShareViewController alloc] init];
        PVShareModel *shareModel = [[PVShareModel alloc] init];
        shareModel.sharetitle = findModel.title;
        shareModel.descriptStr = findModel.subTitle;
        shareModel.imageUrl = findModel.image;
        shareModel.h5Url = findModel.shareH5Url;
        shareCon.shareModel = shareModel;
        shareCon.modalPresentationStyle = UIModalPresentationCustom;
        [pv.navigationController presentViewController:shareCon animated:NO completion:nil];
    }];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVFindHomeModel* model = self.dataSource[indexPath.row];
    return model.cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PVFindHomeModel* model = self.dataSource[indexPath.row];
    PVFindColumnViewController* vc = [[PVFindColumnViewController alloc]  init];
    vc.code = model.authorData.authorCode;
    [self.navigationController pushViewController:vc animated:true];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.selectedIndexPath) return;
    CGRect rectInTableView = [self.findTableView rectForRowAtIndexPath:self.selectedIndexPath];
    CGRect rectInSuperview = [self.findTableView convertRect:rectInTableView toView:[self.findTableView superview]];
    CGFloat maxLimitHeightUp = rectInSuperview.size.height - fabs(rectInSuperview.origin.y) ;
    CGFloat maxLimitHeightDown = ScreenHeight- rectInSuperview.origin.y;
    bool isStop = (maxLimitHeightUp < 110 && rectInSuperview.origin.y < 0) || (maxLimitHeightDown < 130 && rectInSuperview.origin.y > 0);
    if (isStop) {
        [self videoStopPlay];
    }
   NSLog(@"rectInTableView = %@---------rectInSuperview = %@------%f",NSStringFromCGRect(rectInTableView),NSStringFromCGRect(rectInSuperview),maxLimitHeightDown);
}


-(NSInteger)selectedTableViewRow{
    if ([self getCellMaxY:(self.findTableView.contentOffset.y+self.findTableView.bounds.size.height) contentSizeHeight:(self.findTableView.contentSize.height) margin:10]) {
        return self.dataSource.count - 1;
    }else{
        double tempIndex = self.findTableView.contentOffset.y/(float)(168+ScreenWidth*213/375);
        int index = (int)tempIndex;
        double distanceIndex = tempIndex - index;
        if (distanceIndex<0.45) {
            return tempIndex;
        }else{
            return (tempIndex+1);
        }
    }
}


-(void)selectedTargetAutoRow{
    if (!self.dataSource.count) {
        return;
    }
    
    NSInteger index = [self selectedTableViewRow];
    if (index == self.selectedIndexPath.row) {
        return;
    }
    
    PVFindHomeModel* previousModel = self.dataSource[self.selectedIndexPath.row];
    previousModel.isHiddenPlayBtn = false;
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    PVFindHomeModel* nextModel = self.dataSource[self.selectedIndexPath.row];
    nextModel.isHiddenPlayBtn = true;
    
    [self.findTableView reloadData];
    
}
-(BOOL)getCellMaxY:(CGFloat)maxY contentSizeHeight:(CGFloat)contentSizeHeight  margin:(CGFloat)margin{
    CGFloat distance = maxY-contentSizeHeight;
    if (distance > -margin && distance < margin) {
        return YES;
    }else{
        return NO;
    }
}
-(UITableView *)findTableView{
    if (!_findTableView) {
        _findTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _findTableView.frame = self.view.bounds;
        _findTableView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, -kTabBarHeight+5, 0);
        _findTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_findTableView registerNib:[UINib nibWithNibName:@"PVFindHomeTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVFindHomeTableViewCell];
        _findTableView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        _findTableView.dataSource = self;
        _findTableView.delegate = self;
        _findTableView.showsVerticalScrollIndicator = false;
        _findTableView.showsVerticalScrollIndicator = false;
    }
    return _findTableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(void)videoStopPlay{
    if (self.playView.playControView.player != nil) {
        [self.playView.playControView videoStop];
        [self.playView removeFromSuperview];
        self.playView = nil;
        [self.playContainerView removeFromSuperview];
        self.playContainerView = nil;
    }
}

//取消与进行点赞
-(void)cancelPraise:(BOOL)isCancel code:(NSString*)code{
    NSString* url = @"doLike";
    if (isCancel) {
        url = @"doUnlike";
    }
    NSMutableDictionary* doLikePramas = [[NSMutableDictionary alloc]  init];
    [doLikePramas setObject:[PVUserModel shared].token forKey:@"token"];
    [doLikePramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    [doLikePramas setObject:code forKey:@"code"];
    [PVNetTool postDataWithParams:doLikePramas url:url success:^(id result) {
        NSString* errorStr = [NSString stringWithFormat:@"%@",result[@"errorMsg"]];
        if(isCancel){
            if (!errorStr.length) {
                [MBProgressHUD showSuccess:@"取消点赞" toView:self.view];
            }else{
                [MBProgressHUD showError:result[@"errorMsg"]  toView:self.view];
            }
        }else{
            if (!errorStr.length) {
                [MBProgressHUD showSuccess:@"点赞成功" toView:self.view];
            }else{
                [MBProgressHUD showError:result[@"errorMsg"] toView:self.view];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接失败"  toView:self.view];
    }];
}
-(void)loadVideoUrl:(PVFindHomeModel*)findHomeModel  superView:(UIView*)superView{
    [PVNetTool getDataWithUrl:findHomeModel.videoUrl success:^(id result) {
        if (result[@"videoJson"][@"url"] && [result[@"videoJson"][@"url"]  isKindOfClass:[NSString class]]) {
            findHomeModel.playVideoUrl = result[@"videoJson"][@"url"];
            [self playVideo:findHomeModel.playVideoUrl superView:superView];
        }
    } failure:^(NSError *error) {
        NSLog(@"该视频不存在");
    }];
}
-(void)playVideo:(NSString*)videoUrl  superView:(UIView*)superView{
    if (!videoUrl.length) return;
    //            NSString* urlString = @"http://baobab.wdjcdn.com/1457546796853_5976_854x480.mp4";
    NSURL* url = [NSURL URLWithString:videoUrl];
    PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
    playVideoModel.url = url;
    playVideoModel.type = 4;
    playVideoModel.videoDistrict = @"2";
    [self goTableViewPlayVideoModel:playVideoModel delegate:self superView:superView];
    
    //分享界面
   // [self setupVideoUI];
    
    //准备播放
    [self.playView.playControView videoFirstPlay];
}


-(void)setupVideoUI{
    [self.playContainerView addSubview:self.coverBtn];
    [self.coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.playContainerView);
    }];
    [self.playContainerView addSubview:self.videoShareView];
    [self setMoreViewConstrints:self.videoShareView];
    
}
-(void)setMoreViewConstrints:(UIView*)view{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.playContainerView);
        make.right.equalTo(self.playContainerView.mas_right).offset(videoMoreHeight);
        make.width.equalTo(@(videoMoreHeight));
    }];
}
-(UIButton *)coverBtn{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.backgroundColor = [UIColor clearColor];
        _coverBtn.hidden = true;
        [_coverBtn addTarget:self action:@selector(coverBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}
-(void)coverBtnClicked{
    [self closeMoreView:self.videoShareView];
}
-(void)closeMoreView:(UIView*)view{
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(videoMoreHeight));
    }];
    [UIView animateWithDuration:0.2f animations:^{
        [self.playContainerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.coverBtn.hidden = true;
        view.hidden = true;
    }];
}

-(PVVideoShareView *)videoShareView{
    if (!_videoShareView) {
        _videoShareView = [[[NSBundle mainBundle]loadNibNamed:@"PVVideoShareView" owner:self options:nil]objectAtIndex:0];
        _videoShareView.hidden = true;
        
        PV(pv)
        [_videoShareView setPVVideoShareViewCallBlock:^(NSString *title) {
            PVShareModel *shareModel = [[PVShareModel alloc] init];
            shareModel.sharetitle = pv.seletcedModel.title;
            shareModel.descriptStr = pv.seletcedModel.subTitle;
            shareModel.imageUrl = pv.seletcedModel.image;
            shareModel.h5Url = pv.seletcedModel.shareH5Url;
            SSDKPlatformType type = -101;
            if ([title isEqualToString:@"微信"]) {
                type = SSDKPlatformSubTypeWechatSession;
            }else if ([title isEqualToString:@"朋友圈"]){
                type = SSDKPlatformSubTypeWechatTimeline;
            }else if ([title isEqualToString:@"QQ好友"]){
                type = SSDKPlatformSubTypeQQFriend;
            }else if ([title isEqualToString:@"QQ空间"]){
                type = SSDKPlatformSubTypeQZone;
            }else if ([title isEqualToString:@"微博"]){
                type = SSDKPlatformTypeSinaWeibo;
            }else if ([title isEqualToString:@"复制链接"]){
                UIPasteboard *copyStr = [UIPasteboard generalPasteboard];
                copyStr.string = shareModel.videoUrl;
                [pv.playContainerView makeToast:@"链接复制成功" duration:2 position:CSToastPositionCenter];
            }
            if (![title isEqualToString:@"复制链接"]) {
                [PVShareTool shareWithPlatformType:type PVDemandVideoDetailModel:shareModel shareresult:^(NSString *shareResultStr) {
                  //  [pv.playContainerView makeToast:shareResultStr duration:2 position:CSToastPositionCenter];
                }];
            }
        }];
        
    }
    return _videoShareView;
}

-(void)delegateShareBtnClicked{
    [self showMoreView:self.videoShareView];
    NSLog(@"分享");
}
-(void)showMoreView:(UIView*)view{
    _coverBtn.hidden = false;
    view.hidden = false;
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.playContainerView.mas_right);
    }];
    [UIView animateWithDuration:0.25f animations:^{
        [self.playContainerView layoutIfNeeded];
    }];
}

@end
