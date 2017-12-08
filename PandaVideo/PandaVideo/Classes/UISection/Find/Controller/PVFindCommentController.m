//
//  PVFindCommentController.m
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFindCommentController.h"
#import "PVCommentHeadTable.h"
#import "PVCommentTableHeadView.h"
#import "PVCommentTableViewCell.h"
#import "PVCommentFooterTableView.h"
#import "PVFindCommentModel.h"
#import "ChatKeyBoard.h"
#import "PVToolView.h"
#import "PVLoginViewController.h"
#import "PVFindColumnViewController.h"
#import "NSString+SCExtension.h"
#import "PVWebShareView.h"
#import "PVShareViewController.h"

static NSString* resuPVCommentTableHeadView = @"resuPVCommentTableHeadView";
static NSString* resuPVCommentTableViewCell = @"resuPVCommentTableViewCell";
static NSString* resuPVCommentFooterTableView = @"resuPVCommentFooterTableView";

@interface PVFindCommentController ()  <UITableViewDataSource, UITableViewDelegate,VideoPlayerViewDelegate,ChatKeyBoardDelegate>

@property(nonatomic, strong)UITableView* commentTableView;
@property(nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic, strong)PVCommentHeadTable* headView;
@property(nonatomic, strong)PVToolView* toolView;
@property(nonatomic, strong)ChatKeyBoard* chatKeyBoard;
@property(nonatomic, strong)UIButton* coverBtn;
@property(nonatomic, assign)NSInteger headHeight;
@property(nonatomic, strong)PVWebShareView *shareView;
@property(nonatomic, strong)PVFindCommentModel *commentMode;
@property(nonatomic, assign)BOOL isShowFive;
///评论的页数
@property(nonatomic, assign)NSInteger page;
///是否在请求评论数据中
@property(nonatomic, assign)BOOL isRequestCommentIng;
@property(nonatomic, strong)UILabel* noDataLabel;

@end

@implementation PVFindCommentController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTopView.hidden = YES;
    [self loadData];
    [self setupUI];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self videoStopPlay];
}
-(void)setupNavigationBar{
    self.scNavigationItem.title = @"发现详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"find_btn_share_black"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 40, 40);
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]  initWithCustomView:shareBtn];
    
    self.scNavigationItem.rightBarButtonItem = rightItem;
}

-(void)shareBtnClicked{
    PVShareViewController *con = [[PVShareViewController alloc] init];
    PVShareModel *shareModel = [[PVShareModel alloc] init];
    shareModel.videoUrl = self.findHomeModel.videoUrl;
    shareModel.sharetitle = self.findHomeModel.title;
    shareModel.h5Url = self.findHomeModel.shareH5Url;
    shareModel.descriptStr = self.findHomeModel.subTitle;
    con.shareModel = shareModel;
    con.modalPresentationStyle = UIModalPresentationCustom;
    [self.navigationController presentViewController:con animated:NO completion:nil];
}

-(void)setFindHomeModel:(PVFindHomeModel *)findHomeModel{
    _findHomeModel = findHomeModel;
    self.headHeight = (ScreenWidth*9/16)+108;
    if (findHomeModel.subTitle.length) {
        CGSize size = [UILabel messageBodyText:findHomeModel.subTitle andSyFontofSize:[[UIFont systemFontOfSize:15] pointSize] andLabelwith:ScreenWidth-20 andLabelheight:MAXFLOAT];
        self.headHeight = size.height + (ScreenWidth*9/16)+108;
    }
}
-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.commentTableView belowSubview:self.scNavigationBar ];
    
    [self addShareView];
    
    self.commentTableView.tableHeaderView = self.headView;
    self.headView.findHomeModel = self.findHomeModel;
  //  [self.view addSubview:self.chatKeyBoard];
   // [self.view insertSubview:self.coverBtn belowSubview:self.chatKeyBoard];
    [self.view addSubview:self.toolView];
    [self.view insertSubview:self.coverBtn belowSubview:self.toolView];
    [self.toolView.praiseButton setTitle:[NSString stringWithFormat:@"  %@",[self.findHomeModel.upCount transformationStringToSimplify]] forState:UIControlStateNormal];
    self.toolView.praiseButton.selected = self.findHomeModel.isUp.intValue;
    //获取通知中心
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //注册为被通知者
    [notificationCenter addObserver:self selector:@selector(keyChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self.view addSubview:self.noDataLabel];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.top.equalTo(@((ScreenHeight-self.headHeight-kNavBarHeight)*0.25+self.headHeight+kNavBarHeight));
    }];
    
}

- (void)addShareView {
    [self.view insertSubview:self.shareView aboveSubview:self.commentTableView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(kScreenHeight);
    }];
}

-(void)loadData{
    self.page = 0;
    NSString* code = self.findHomeModel.code;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"index"];
    [params setObject:@"10" forKey:@"pageSize"];
    
    if ([PVUserModel shared].token.length) {
        [params setObject:[PVUserModel shared].token forKey:@"token"];
        [params setObject:[PVUserModel shared].userId forKey:@"userId"];
    }else{
        [params setObject:@" " forKey:@"token"];
        [params setObject:@" " forKey:@"userId"];
    }
    
    [params setObject:code forKey:@"code"];
    
    [PVNetTool postDataWithParams:params url:@"getFindCommentList" success:^(id result) {
        
        NSLog(@"-----resukt = %@-----",result);
        
        if (result[@"data"] && [result[@"data"] isKindOfClass:[NSArray class]]){
            NSArray* tempArr = result[@"data"];
            if (!tempArr.count) return;
        };
        if (result[@"data"][@"commentList"] && [result[@"data"][@"commentList"] isKindOfClass:[NSArray class]]){
            NSArray* jsonArr = result[@"data"][@"commentList"];
            [self.dataSource removeAllObjects];
            for (NSDictionary* josnDict in jsonArr) {
                PVFindCommentModel* findCommentModel = [[PVFindCommentModel alloc]  init];
                PVDemandCommentModel* demandCommentModel = [[PVDemandCommentModel alloc]  init];
                [demandCommentModel setValuesForKeysWithDictionary:josnDict];
                findCommentModel.demandCommentModel = demandCommentModel;
                findCommentModel.isShowMoreBtn = true;
                findCommentModel.text = demandCommentModel.content;
                if (demandCommentModel.replayList.count >= 5) {
                    findCommentModel.isShowComment = true;
                }
                [self.dataSource addObject:findCommentModel];
            }
        }
        [self.commentTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

//键盘出来的时候调整tooView的位置
-(void) keyChange:(NSNotification *) notify{
    NSDictionary *dic = notify.userInfo;
    CGRect endKey = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat bottom = kiPhoneX ? 34 : 0;

    CGRect frame = CGRectMake(0, ScreenHeight-self.toolView.sc_height-endKey.size.height, ScreenWidth, self.toolView.sc_height);
    if (endKey.origin.y == ScreenHeight) {
        self.coverBtn.hidden = true;
        frame = CGRectMake(0, ScreenHeight-self.toolView.sc_height-bottom, ScreenWidth, self.toolView.sc_height);
        self.commentTableView.contentInset = UIEdgeInsetsMake(64, 0, self.toolView.sc_height, 0);
    }else{
        self.coverBtn.hidden = false;
    }
    //运动时间
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];

        self.toolView.frame = frame;
        [self.view layoutIfNeeded];
    }];
}

/// MARK:- ====== UITableViewDataSource,UITableViewDelegate ==========

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    self.noDataLabel.hidden = self.dataSource.count;
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    PVFindCommentModel* commentModel = self.dataSource[section];
    if (commentModel.demandCommentModel.replayList == nil || commentModel.demandCommentModel.replayList.count == 0) {
        return 0;
    }
    if (!commentModel.isShowComment && commentModel.demandCommentModel.replayList.count >= 5 && self.isShowFive) {
        self.isShowFive = false;
        return 5;
    }
    return commentModel.demandCommentModel.replayList.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    PV(pv)
    PVCommentTableHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVCommentTableHeadView];
    PVFindCommentModel* commentModel = self.dataSource[section];
    headView.commentModel = commentModel;
    
    [headView setPraiseBtnClickedBlock:^(UIButton * btn) {
        if (![PVUserModel shared].token.length) {
            PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
            [loginVC setPVLoginViewControllerLoginSuccess:^{
                [pv loadData];
            }];
            [pv.navigationController pushViewController:loginVC animated:true];
            return;
        }
        
        NSUInteger likeIndex = commentModel.demandCommentModel.like.integerValue;
        if (commentModel.demandCommentModel.isLike.intValue) {//取消点赞
            commentModel.demandCommentModel.isLike = @"0";
            if (likeIndex) {
                likeIndex--;
            }
            [pv cancelCommentPraise:true commentId:commentModel.demandCommentModel.commentId];
        }else{//点赞
            commentModel.demandCommentModel.isLike = @"1";
            likeIndex++;
            [pv cancelCommentPraise:false commentId:commentModel.demandCommentModel.commentId];
        }
        commentModel.demandCommentModel.like = [NSString stringWithFormat:@"%ld",likeIndex];
        NSIndexSet* indexSect = [NSIndexSet indexSetWithIndex:section];
        [tableView reloadSections:indexSect withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [headView setCommentTableHeadViewTextBlock:^(UIButton * btn) {
        PVFindCommentModel* model = pv.dataSource[section];
        model.isShowText = btn.selected;
        [tableView reloadData];
        NSLog(@"全文");
    }];
    
    //评论点击事件
    [headView setCommentTableHeadViewTapGestureBlock:^(PVFindCommentModel *commentModel) {
        pv.commentMode = commentModel;
        pv.toolView.commentType = 1;
        pv.toolView.sendTextView.placehoder = [NSString stringWithFormat:@"回复  %@",commentModel.demandCommentModel.userData.userName];
        [pv.toolView.sendTextView becomeFirstResponder];
    }];
    
    return headView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVCommentTableViewCell];
    PVFindCommentModel* commentModel = self.dataSource[indexPath.section];
    cell.rePlayList = commentModel.demandCommentModel.replayList[indexPath.row];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    PVCommentFooterTableView* footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:resuPVCommentFooterTableView];
    
    PVFindCommentModel* model = self.dataSource[section];
    footView.commentModel = model;
    
    if (model.demandCommentModel.replayList.count < 5) {
        footView.moreBtn.hidden = true;
    }else{
        footView.moreBtn.hidden = false;
    }
    
    ///更多回复点击事件
    PV(pv)
    [footView setCommentTableFootViewMoreBlock:^(UIButton * btn) {
        PVFindCommentModel* model = pv.dataSource[section];
        if (model.isShowComment) {
            [pv loadMoreReplayComment:model];
        }else{
            pv.isShowFive = true;
            [tableView reloadData];
            model.isShowComment = true;
        }
    }];
    
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    PVFindCommentModel* commentModel = self.dataSource[section];
    if (commentModel.isShowText) {
        return commentModel.headFullHeight;
    }
    return commentModel.headHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVFindCommentModel* commentModel = self.dataSource[indexPath.section];
    PVReplayList* replayList = commentModel.demandCommentModel.replayList[indexPath.row];
//    if(indexPath.row == commentModel.demandCommentModel.replayList.count - 1){
//        return replayList.cellHeight+30;
//    }
    return replayList.cellHeight;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    PVFindCommentModel* model = self.dataSource[section];
    if ( 0 < model.demandCommentModel.replayList.count && model.demandCommentModel.replayList.count < 5) {
        return 15;
    }else if (model.demandCommentModel.replayList.count == 0){
        return 1;
    }
    return 35;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PVFindCommentModel* commentModel = self.dataSource[indexPath.section];
    self.commentMode = commentModel;
    self.toolView.commentType = 2;
    PVReplayList* replayList = commentModel.demandCommentModel.replayList[indexPath.row];
    commentModel.replayList = replayList;
    self.toolView.sendTextView.placehoder = [NSString stringWithFormat:@"回复  %@",replayList.userName];
    [self.toolView.sendTextView becomeFirstResponder];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:true];
}
-(UITableView *)commentTableView{
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _commentTableView.frame = self.view.bounds;
        CGFloat bottom = kiPhoneX ? 34 : 0;
        _commentTableView.sc_height = self.view.sc_height-bottom;
        _commentTableView.contentInset = UIEdgeInsetsMake(kNavBarHeight, 0, 17+40, 0);
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_commentTableView registerNib:[UINib nibWithNibName:@"PVCommentTableHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:resuPVCommentTableHeadView];
        [_commentTableView registerNib:[UINib nibWithNibName:@"PVCommentTableViewCell" bundle:nil] forCellReuseIdentifier:resuPVCommentTableViewCell];
        [_commentTableView registerNib:[UINib nibWithNibName:@"PVCommentFooterTableView" bundle:nil] forHeaderFooterViewReuseIdentifier:resuPVCommentFooterTableView];
        _commentTableView.backgroundColor = [UIColor whiteColor];
        _commentTableView.dataSource = self;
        _commentTableView.delegate = self;
        _commentTableView.showsVerticalScrollIndicator = false;
        _commentTableView.showsVerticalScrollIndicator = false;
    }
    return _commentTableView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(PVCommentHeadTable *)headView{
    if (!_headView) {
        _headView =  [[NSBundle mainBundle] loadNibNamed:@"PVCommentHeadTable" owner:nil options:nil].lastObject;
        _headView.frame = CGRectMake(0, 0, ScreenWidth, self.headHeight);
        PV(pv)
        __block UIView* superView = _headView.commentContainerView;
        [_headView setImageViewClickedBlock:^(NSInteger index) {
            if (index == 1) {
                [pv playVideo:pv.findHomeModel.videoUrl superView:superView];
            }else if (index == 2){
                PVFindColumnViewController* vc = [[PVFindColumnViewController alloc]  init];
                vc.code = pv.findHomeModel.authorData.authorCode;
                [pv.navigationController pushViewController:vc animated:true];
            }
        }];
    }
    return _headView;
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
    NSURL* url = [NSURL URLWithString:videoUrl];
    PVPlayVideoModel* playVideoModel = [[PVPlayVideoModel alloc]  init];
    playVideoModel.url = url;
    playVideoModel.type = 4;
    playVideoModel.videoDistrict = @"2";
    [self goTableViewPlayVideoModel:playVideoModel delegate:self superView:superView];    //准备播放
    [self.playView.playControView videoFirstPlay];
}
-(PVToolView *)toolView{
    if (!_toolView) {
        _toolView = [[PVToolView alloc]  initWithType:1];
        _toolView.sendTextView.placehoder = @"快和小伙伴一起畅聊吧~";
        _toolView.commentType = 0;
        CGFloat y = kiPhoneX ? (ScreenHeight-53-34) : (ScreenHeight-53);
        _toolView.frame = CGRectMake(0, y, ScreenWidth, 53);
        PV(pv)
        [_toolView setMyTextBlock:^(NSString *myText) {
            ///判断登
            if (![PVUserModel shared].token.length) {
                PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
                [loginVC setPVLoginViewControllerLoginSuccess:^{
                    [pv loadData];
                }];
                [pv.navigationController pushViewController:loginVC animated:true];
            }else{
                [pv commintComment:myText];
            }
        }];
        [_toolView setContentSizeBlock:^(CGSize contentSize) {
            [pv changeHeight:contentSize];
        }];
        [_toolView setPraiseButtonClickedBlock:^{
            if (![PVUserModel shared].token.length) {
                PVLoginViewController* loginVC = [[PVLoginViewController alloc]  init];
                [loginVC setPVLoginViewControllerLoginSuccess:^{
                    [pv loadData];
                }];
                [pv.navigationController pushViewController:loginVC animated:true];
                return;
            }
            if (pv.findHomeModel.isUp.integerValue) {//取消点赞
                pv.findHomeModel.isUp = @"0";
                [pv cancelPraise:true code:pv.findHomeModel.code];
            }else{//点赞
                pv.findHomeModel.isUp = @"1";
                [pv cancelPraise:false code:pv.findHomeModel.code];
            }
            pv.toolView.praiseButton.selected = pv.findHomeModel.isUp.intValue;
            NSLog(@"视频点赞");
        }];
        
    }
    return _toolView;
}

-(void)changeHeight:(CGSize)contentSize{
    float height = contentSize.height + 18;
    CGFloat y = kiPhoneX ? (ScreenHeight-53-34) : (ScreenHeight-53);
    if (height > 50) {
        [self.toolView.sendTextView flashScrollIndicators];
        static CGFloat maxHeight = 130.0f;
        CGRect frame = self.toolView.sendTextView.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [self.toolView.sendTextView sizeThatFits:constraintSize];
        if (size.height >= maxHeight){
            size.height = maxHeight;
            self.toolView.sendTextView.scrollEnabled = YES;
        }else{
            self.toolView.sendTextView.scrollEnabled = NO;
        }
        CGFloat tempHeight = ScreenHeight-CGRectGetMaxY(self.toolView.frame);
        self.toolView.frame = CGRectMake(self.toolView.sc_x, ScreenHeight-size.height-20-tempHeight, ScreenWidth, size.height+20);
    }else{
        self.toolView.frame = CGRectMake(0, y,ScreenWidth, 53);
    }
}
-(UIButton *)coverBtn{
    if (!_coverBtn) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.frame = self.view.bounds;
        _coverBtn.hidden = true;
        _coverBtn.backgroundColor = [UIColor clearColor];
        [_coverBtn addTarget:self action:@selector(coverBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}
-(void)coverBtnClicked{
    [self.view endEditing:true];
    self.coverBtn.hidden = true;
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
//取消与进行评论点赞
-(void)cancelCommentPraise:(BOOL)isCancel  commentId:(NSString*)commentId{
    NSString* url = @"addCommentLike";
    if (isCancel) {
        url = @"deletLike";
    }
    NSString* playOrCollectUrl = [NSString stringWithFormat:@"%@", url];
    NSMutableDictionary* playOrCollectPramas = [[NSMutableDictionary alloc]  init];
    [playOrCollectPramas setObject:[PVUserModel shared].token forKey:@"token"];
    [playOrCollectPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    [playOrCollectPramas setObject:commentId forKey:@"commentId"];
    [PVNetTool postDataWithParams:playOrCollectPramas url:playOrCollectUrl success:^(id result) {
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


//取消与进行视频点赞
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

//提交评论
-(void)commintComment:(NSString*)text{
    if (text.length == 0) {
        [MBProgressHUD showError:@"请您输入评论内容" toView:self.view];
        return;
    }
    NSString* sendComment = @"sendComment";
    NSMutableDictionary* sendCommentPramas = [[NSMutableDictionary alloc]  init];
    [sendCommentPramas setObject:[PVUserModel shared].token forKey:@"token"];
    [sendCommentPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    [sendCommentPramas setObject:self.findHomeModel.code forKey:@"code"];
    [sendCommentPramas setObject:text forKey:@"content"];
    if (self.toolView.commentType == 1) {
        [sendCommentPramas setObject:self.commentMode.demandCommentModel.commentId forKey:@"targetId"];
    }else if (self.toolView.commentType == 2){
        [sendCommentPramas setObject:self.commentMode.demandCommentModel.commentId forKey:@"targetId"];

    //    [sendCommentPramas setObject:self.commentMode.replayList.commentId forKey:@"targetId"];
    }else if (self.toolView.commentType == 0){
        [sendCommentPramas setObject:@"" forKey:@"targetId"];
    }
    self.toolView.commentType = 0;
    self.toolView.sendTextView.text = nil;
    self.toolView.sendTextView.placehoder = @"快和小伙伴一起畅聊吧~";
    [self coverBtnClicked];
    bool isIphoneX = (self.scNavigationBar.sc_height == 88.0) ? true : false;
    CGFloat botttomHeight = isIphoneX ? 34 : 0;
    self.toolView.frame = CGRectMake(0,ScreenHeight-53-botttomHeight, ScreenWidth, 53);
    [self.toolView.sendTextView resignFirstResponder];
    
    [PVNetTool postDataWithParams:sendCommentPramas url:sendComment success:^(id result) {
        if (result[@"errorMsg"] != nil && result[@"errorMsg"] != [NSNull null]) {
            [MBProgressHUD showSuccess:@"评论待审核" toView:self.view];
        }else if (result[@"errorMsg"]){
            [MBProgressHUD showError:result[@"errorMsg"] toView:self.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络连接失败" toView:self.view];
    }];
}



//获取评论回复详情列表
-(void)loadMoreReplayComment:(PVFindCommentModel*)findCommentModel{
    if (self.isRequestCommentIng) return;
    self.isRequestCommentIng = true;
    self.page++;
    NSString* replayCommentUrl = [NSString stringWithFormat:@"%@", @"getCommentReplyList"];
    NSMutableDictionary* replayCommentPramas = [[NSMutableDictionary alloc]  init];
    if([PVUserModel shared].token.length){
        [replayCommentPramas setObject:[PVUserModel shared].token forKey:@"token"];
        [replayCommentPramas setObject:[PVUserModel shared].userId forKey:@"userId"];
    }
    [replayCommentPramas setObject:findCommentModel.demandCommentModel.commentId forKey:@"commentId"];
    [replayCommentPramas setObject:@(self.page) forKey:@"index"];
    [replayCommentPramas setObject:@"10" forKey:@"pageSize"];
    
    [PVNetTool postDataWithParams:replayCommentPramas url:replayCommentUrl success:^(id result) {
        if (result[@"data"][@"replayList"] && [result[@"data"][@"replayList"] isKindOfClass:[NSArray class]] ) {
            NSArray* jsonArr = result[@"data"][@"replayList"];
            if (jsonArr.count < 10) {
                findCommentModel.isShowComment = false;
            }else{
                findCommentModel.isShowComment = true;
            }
            for (NSDictionary* jsonDict in jsonArr) {
                PVReplayList* rePlayList = [[PVReplayList alloc]  init];
                [rePlayList setValuesForKeysWithDictionary:jsonDict];
                [rePlayList calculationCellHeight];
                [findCommentModel.demandCommentModel.replayList addObject:rePlayList];
            }
        }else{
            self.page--;
        }
        [self.commentTableView reloadData];
        self.isRequestCommentIng = false;
    } failure:^(NSError *error) {
        self.page--;
        self.isRequestCommentIng = false;
    }];
}
- (PVWebShareView *)shareView {
    if (!_shareView) {
        _shareView = [[PVWebShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenHeight)];
        _shareView.hidden = YES;
    }
    return _shareView;
}
-(UILabel *)noDataLabel{
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc]  init];
        _noDataLabel.hidden = true;
        _noDataLabel.textColor = [UIColor sc_colorWithHex:0x808080];
        _noDataLabel.text = @"暂无评论";
        _noDataLabel.font = [UIFont systemFontOfSize:15];
    }
    return _noDataLabel;
}

@end
