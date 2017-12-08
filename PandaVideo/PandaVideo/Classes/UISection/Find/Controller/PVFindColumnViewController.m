//
//  PVFindColumnViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFindColumnViewController.h"
#import "PVFindColumnTableViewCell.h"
#import "PVFindHomeModel.h"
#import "PVFindColumnViewController.h"
#import "PVFindColumnHeadView.h"
#import "PVDemandViewController.h"
#import "PVFindCommentController.h"
#import "PVFindBaseInfoModel.h"
#import "PVVideoListModel.h"
#import "PVLoginViewController.h"
#import "PVShareViewController.h"

#define headViewHeight  ScreenWidth*215/375+30


static NSString* resuPVFindColumnTableViewCell = @"resuPVFindColumnTableViewCell";
//#define cellHeight 170+ScreenWidth*9/16

@interface PVFindColumnViewController () <UITableViewDataSource,UITableViewDelegate,VideoPlayerViewDelegate>

@property(nonatomic, strong)UITableView* findTableView;
@property(nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic, strong)NSIndexPath *selectedIndexPath;
@property(nonatomic, strong)PVFindColumnHeadView* headView;
@property(nonatomic, strong)UIButton* backBtn;
@property(nonatomic, strong)PVFindBaseInfoModel*  findBaseInfoModel;
@property(nonatomic, assign)NSInteger currentIndex;
@property(nonatomic, assign)NSInteger pageAllIndex;

@end

@implementation PVFindColumnViewController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.findTableView){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)setupNavigationBar{
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self videoStopPlay];
}

-(void)setupUI{
    self.scNavigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.headView belowSubview:self.backBtn];
    [self.view insertSubview:self.findTableView belowSubview:self.scNavigationBar];
    PV(pv)
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
    [params setObject:self.code forKey:@"code"];
    [PVNetTool postDataWithParams:params url:@"getFindUserList" success:^(id result) {
        if (result[@"data"][@"findList"] &&  [result[@"data"][@"findList"] isKindOfClass:[NSArray class]]) {
            [self.dataSource removeAllObjects];
            NSArray* jsonArr = result[@"data"][@"findList"];
            for (NSDictionary* jsonDict in jsonArr) {
                PVFindHomeModel* model = [[PVFindHomeModel alloc]  init];
                model.isHiddenPlayBtn = false;
                [model setValuesForKeysWithDictionary:jsonDict];
                [self.dataSource addObject:model];
            }
            self.currentIndex = 1;
            self.pageAllIndex = [NSString stringWithFormat:@"%@",result[@"data"][@"pageAllIndex"]].integerValue;
        }
        if (result[@"data"][@"authorData"] && [result[@"data"][@"authorData"] isKindOfClass:[NSDictionary class]]) {
            PVFindBaseInfoModel*  findBaseInfoModel = [[PVFindBaseInfoModel alloc]  init];
            [findBaseInfoModel setValuesForKeysWithDictionary:result[@"data"][@"authorData"]];
            self.findBaseInfoModel = findBaseInfoModel;
            self.headView.findBaseInfoModel = findBaseInfoModel;
            self.scNavigationItem.title = findBaseInfoModel.name;
        }
        [self.findTableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接失败" toView:self.view];
    }];
}
-(void)loadMoreData{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@(self.currentIndex) forKey:@"index"];
    [params setObject:@"10" forKey:@"pageSize"];
    if ([PVUserModel shared].token.length) {
        [params setObject:[PVUserModel shared].token forKey:@"token"];
        [params setObject:[PVUserModel shared].userId forKey:@"userId"];
    }else{
        [params setObject:@" " forKey:@"token"];
        [params setObject:@" " forKey:@"userId"];
    }
    [params setObject:self.code forKey:@"code"];
    [PVNetTool postDataWithParams:params url:@"getFindUserList" success:^(id result)
     {
        [self.findTableView.mj_footer endRefreshing];
        if (result[@"data"][@"findList"] &&  [result[@"data"][@"findList"] isKindOfClass:[NSArray class]]) {
            NSArray* jsonArr = result[@"data"][@"findList"];
            for (NSDictionary* jsonDict in jsonArr) {
                PVFindHomeModel* model = [[PVFindHomeModel alloc]  init];
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
    
    PVFindColumnTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[NSBundle mainBundle]  loadNibNamed:@"PVFindColumnTableViewCell" owner:self options:nil].lastObject;
    }
    PVFindHomeModel* findModel = self.dataSource[indexPath.row];
    
    PV(pv)
    __block UIView* superView = cell.videoContanierView;
    [cell setImageViewClickedBlock:^(UIButton * btn) {//播放短视频
        pv.selectedIndexPath = indexPath;
        [pv videoStopPlay];
        [pv playVideo:findModel.videoUrl superView:superView];
//        if (findModel.videoUrl.length == 0) {//发送请求
//            [pv loadVideoUrl:findModel superView:superView];
//        }else{
//            [pv playVideo:findModel.videoUrl superView:superView];
//        }
    }];
    
    cell.findHomeModel = findModel;
    
    [cell setCommentBtnClickedBlock:^(UIButton * btn) {
        PVFindCommentController* vc = [[PVFindCommentController alloc]  init];
        if (findModel.authorData.logo.length == 0) {
            findModel.authorData.logo = pv.findBaseInfoModel.logo;
        }
        if (findModel.authorData.name.length == 0) {
            findModel.authorData.name = pv.findBaseInfoModel.name;
        }
        vc.findHomeModel = findModel;
        [pv.navigationController  pushViewController:vc animated:true];
    }];
    
    
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
        shareModel.videoUrl = findModel.videoUrl;
        shareModel.h5Url = findModel.shareH5Url;
        shareCon.shareModel = shareModel;
        shareCon.modalPresentationStyle = UIModalPresentationCustom;
        [pv.navigationController presentViewController:shareCon animated:NO completion:nil];
        
        
    }];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PVFindHomeModel* model = self.dataSource[indexPath.row];
    return model.cellDetailHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PVFindHomeModel* findModel = self.dataSource[indexPath.row];
    PVFindCommentController* vc = [[PVFindCommentController alloc]  init];
    if (findModel.authorData.logo.length == 0) {
        findModel.authorData.logo = self.findBaseInfoModel.logo;
    }
    if (findModel.authorData.name.length == 0) {
        findModel.authorData.name = self.findBaseInfoModel.name;
    }
    vc.findHomeModel = findModel;
    [self.navigationController  pushViewController:vc animated:true];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    if (offsetY == 0) {
        self.headView.sc_y = 0;
        self.headView.sc_height = headViewHeight;
        self.headView.alpha = 1.0;
    }else if (offsetY < 0) {
        self.headView.sc_y = 0;
        self.headView.sc_height = headViewHeight-offsetY;
    }else{
        self.headView.sc_height = headViewHeight;
        CGFloat min = headViewHeight-64;
        self.headView.sc_y =  -((min <= offsetY) ? min : offsetY);
        CGFloat progress = 1- (offsetY/min);
        self.headView.alpha = progress;
    }
    
    
    if (self.headView.alpha < 0.1) {
        [_backBtn setImage:[UIImage imageNamed:@"all_btn_back_grey"] forState:UIControlStateNormal];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [_backBtn setImage:[UIImage imageNamed:@"all_btn_back_white"] forState:UIControlStateNormal];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    }
    
    if (!self.selectedIndexPath) return;
    CGRect rectInTableView = [self.findTableView rectForRowAtIndexPath:self.selectedIndexPath];
    CGRect rectInSuperview = [self.findTableView convertRect:rectInTableView toView:[self.findTableView superview]];
    CGFloat maxLimitHeightUp = rectInSuperview.size.height - fabs(rectInSuperview.origin.y) ;
    CGFloat maxLimitHeightDown = ScreenHeight- rectInSuperview.origin.y;
    bool isStop = (maxLimitHeightUp < 50 && rectInSuperview.origin.y < 0) || (maxLimitHeightDown < 130 && rectInSuperview.origin.y > 0);
    if (isStop) {
        [self videoStopPlay];
    }
}
-(UITableView *)findTableView{
    if (!_findTableView) {
        _findTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _findTableView.frame = self.view.bounds;
        CGFloat bottom = kiPhoneX ? 34 : 0;
        _findTableView.sc_height = self.view.sc_height-bottom;
        _findTableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.headView.frame), 0, -kTabBarHeight+5, 0);
        _findTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_findTableView registerNib:[UINib nibWithNibName:@"PVFindColumnTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVFindColumnTableViewCell];
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
-(PVFindColumnHeadView *)headView{
    if (!_headView) {
        _headView =  [[NSBundle mainBundle] loadNibNamed:@"PVFindColumnHeadView" owner:nil options:nil].lastObject;
        _headView.frame = CGRectMake(0, 0, ScreenWidth, headViewHeight);
        PV(pv)
        [_headView setBackBtnClickedBlock:^{
            [pv.navigationController popViewControllerAnimated:true];
        }];
    }
    return _headView;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = kiPhoneX ? 44 : 20;
        _backBtn.frame = CGRectMake(5, y, 40, 40);
        [_backBtn setImage:[UIImage imageNamed:@"all_btn_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
    }
    return _backBtn;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:true];
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
-(void)loadVideoUrl:(PVFindHomeModel*)findHomeModel  superView:(UIView*)superView{
    [PVNetTool getDataWithUrl:findHomeModel.videoListModel.info.jsonUrl success:^(id result) {
        if (result[@"videoUrl"] && [result[@"videoUrl"]  isKindOfClass:[NSString class]]) {
            findHomeModel.videoUrl = result[@"videoUrl"];
            [self playVideo:findHomeModel.videoUrl superView:superView];
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
    
    //准备播放
    [self.playView.playControView videoFirstPlay];
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
@end
