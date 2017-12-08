//
//  PVSerachViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//
#import "PVSerachViewController.h"
#import "PVHistoryAndHotSearchController.h"
#import "PVSearchBar.h"
#import "PVSearchResultViewController.h"
#import "PVDBManager.h"
#import "PVVideoListModel.h"
#import "PVSearchResultAssociationCell.h"
#import "PVSearchResultModel.h"
#import "AppDelegate+UserGuide.h"
static NSString * const resuPVSearchResultAssociationCell = @"resuPVSearchResultAssociationCell";

@interface PVSerachViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)PVSearchBar* searchBar;
@property(nonatomic, strong)UIButton* cancelBtn;
@property(nonatomic, strong)PVHistoryAndHotSearchController* historyAndHotSearchController;
@property(nonatomic, strong)PVSearchResultViewController* searchResultViewController;
@property(nonatomic, strong)UIView* topView;
@property(nonatomic, strong)UIView* resultView;
@property(nonatomic, strong)NSMutableArray<PVVideoListModel*>* searchResultDataSource;
@property(nonatomic, strong)UITableView* resultAssociationTableView;
@property(nonatomic, strong)NSMutableArray* associationDataSource;
@property(nonatomic, strong)NSMutableArray* associationAllDataSource;

@property(nonatomic,strong)UILabel * totalLabel;
//结果集
@property(nonatomic,strong)PVSearchResultModel *resultModel;

@end

@implementation PVSerachViewController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.placeName.length) {
        self.cancelBtn.selected = true;
    }
    [self setupUI];
    if(![kUserDefaults boolForKey:@"guide_img_guide2"]){
        [kUserDefaults setBool:YES forKey:@"guide_img_guide2"];
        [kUserDefaults synchronize];
        PV(weakSelf);
        if ([self.searchBar canBecomeFirstResponder]) {
            [self.searchBar becomeFirstResponder];
        }
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate createUserGuide:1  withFrame:self.searchBar.frame];
        delegate.userGuideBlock = ^(NSInteger index){
        if (index != 1) {
            return ;
        }
        [weakSelf.searchBar resignFirstResponder] ;
        [weakSelf sendSearch:weakSelf.searchBar.text];
            
        };
    }else{
        if ([self.searchBar canBecomeFirstResponder]) {
            [self.searchBar becomeFirstResponder];
        }
    }
 
}
-(void)setIsFamily:(BOOL)isFamily{
    _isFamily = false;
}

- (void)createGuideThree{
    if(![kUserDefaults boolForKey:@"guide_img_guide3"]){
        [kUserDefaults setBool:YES forKey:@"guide_img_guide3"];
        [kUserDefaults synchronize];
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate createUserGuide:2  withFrame:CGRectZero];
    }
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.associationAllDataSource addObjectsFromArray:[PVDBManager sharedInstance].associationKeyWordDataSource];
    [self.searchBar addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    CGFloat Y = kiPhoneX ? 44 : 20;
    self.topView.hidden = true;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(35+Y));
        make.top.equalTo(@(0));
    }];
    if(self.isFamily){
        Y = Y + 35;
        self.topView.hidden = false;
    }
    UIView* containerView = [[UIView alloc]  init];
//    containerView.backgroundColor = [UIColor whiteColor];
    containerView.frame = CGRectMake(0, Y, ScreenWidth, 40);
    [self.view addSubview:containerView];
    [containerView addSubview:self.searchBar];
    [containerView addSubview:self.cancelBtn];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(IPHONE6WH(0)));
        make.top.equalTo(containerView.mas_bottom).offset(0);
    }];
    [self addChildViewController:self.historyAndHotSearchController];
    [self.view addSubview:self.historyAndHotSearchController.view];
    [self.historyAndHotSearchController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(@(ScreenWidth));;
        make.top.equalTo(self.resultView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [self.searchResultViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(@(ScreenWidth));;
        make.top.equalTo(self.resultView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [self.view addSubview:self.resultAssociationTableView];
    [self.resultAssociationTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(@(ScreenWidth));;
        make.top.equalTo(self.resultView.mas_bottom).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    NSArray* resultHistoryArr = [[PVDBManager sharedInstance] selectAllData];
    self.historyAndHotSearchController.historyDataSource = resultHistoryArr;
}

- (void)textFieldChanged:(UITextField *)textField{
    if (!textField.text.length){
        self.resultAssociationTableView.hidden = true;
        return;
    }
    NSString *str = textField.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"word CONTAINS '%@'",str]];
    NSArray *results = [self.associationAllDataSource filteredArrayUsingPredicate:predicate];
    [self.associationDataSource removeAllObjects];
    if (results == 0) {
        self.resultAssociationTableView.hidden = true;
        return;
    }
    [self.associationDataSource addObjectsFromArray:results];
    self.resultAssociationTableView.hidden = false;
    [self.resultAssociationTableView reloadData];
}
//点击返回按钮，搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchBar resignFirstResponder] ;
    if (self.searchBar.text.length) {
        [[PVDBManager sharedInstance] insertHistoryName:self.searchBar.text];
    }
    [self sendSearch:textField.text];
    return YES;
}
-(void)searchBarClicked{
    self.cancelBtn.selected = self.searchBar.text.length;
    if (!self.cancelBtn.selected) {
        [self.resultView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(IPHONE6WH(0)));
        }];
    }
}

-(void)cancelBtnClicked{
    [self.searchBar resignFirstResponder];
  //  NSString* rsultText = self.searchBar.text;
    if (self.cancelBtn.selected) {//搜索，发送请求
        [self sendSearch:self.searchBar.text];
        if(self.isFamily)
        [self.resultView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(IPHONE6WH(50)));
        }];
        self.cancelBtn.selected = false;
        if (self.searchBar.text.length) {
            [[PVDBManager sharedInstance] insertHistoryName:self.searchBar.text];
        }
        self.historyAndHotSearchController.view.hidden = true;
        self.searchResultViewController.view.hidden = false;
    }else{
        [self.navigationController popViewControllerAnimated:true];
    }
}

//发送搜索请求
-(void)sendSearch:(NSString*)searchWord{
    self.searchBar.text = searchWord;
    if (!searchWord.length) {
        Toast(@"请输入关键字");
        return;
    }
    //
//    if (self.isFamily) {
        NSDictionary* params = @{@"index":@(0),@"pageSize":@"20",@"type":@"0",@"key":searchWord};
        [PVNetTool postDataWithParams:params url:@"/search" success:^(id result) {
            
            NSLog(@"--result = --%@---",result);
            
            NSString * errorMsg = result[@"errorMsg"];
            if (errorMsg.length > 0) {
                return;
            }
            self.resultModel = [PVSearchResultModel yy_modelWithJSON:result[@"data"]];
            self.resultAssociationTableView.hidden = true;
            self.historyAndHotSearchController.view.hidden = true;
            self.searchResultViewController.view.hidden = false;
            self.searchResultViewController.isFamily = YES;
            self.searchResultViewController.targetPhone = self.targetPhone;
            if ((self.resultModel.videoList.count < 1) || (self.nikename.length < 1)) {
                 self.totalLabel.text = @"暂无搜索视频";
            }else{
            self.totalLabel.text = [NSString stringWithFormat:@"    已搜索%ld个视频，点击后在%@电视上播放",self.resultModel.videoList.count,self.nikename];
            }
            [self.searchResultViewController reloadSearchresultData:self.resultModel.videoList];
                 if (self.resultModel.videoList.count > 0) {
                     [self createGuideThree];
                 }
                } failure:^(NSError *error) {
            NSLog(@"-------error----- = %@",error);
        }];
    
        return;
//    }
    
//    NSDictionary* params = @{@"index":@(0),@"pageSize":@"10",@"type":@"0",@"key":@"花"};
//    [PVNetTool postDataWithParams:params url:@"search" success:^(id result) {
//        if (result[@"data"] && result[@"data"][@"videoList"] && [result[@"data"][@"videoList"] isKindOfClass:[NSArray class]]) {
//            NSArray* jsonArr = result[@"data"][@"videoList"];
//            [self.searchResultDataSource removeAllObjects];
//            for (NSDictionary* jsonDict in jsonArr) {
//                PVVideoListModel* videoListModel = [[PVVideoListModel alloc]  init];
//                [videoListModel setValuesForKeysWithDictionary:jsonDict];
//                [self.searchResultDataSource addObject:videoListModel];
//            }
//
//            //如果是多集发送请求剧集
//        }
//        self.resultAssociationTableView.hidden = true;
//        self.historyAndHotSearchController.view.hidden = true;
//        self.searchResultViewController.view.hidden = false;
//        NSLog(@"-------result----- = %@",result);
//    } failure:^(NSError *error) {
//        NSLog(@"-------error----- = %@",error);
//    }];
}

-(PVSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[PVSearchBar alloc] init];
        _searchBar.frame = CGRectMake(20, 5, ScreenWidth-80, 30);
        _searchBar.delegate = self;
        _searchBar.leftImageView.image = [UIImage imageNamed:@"search_btn_search"];
        _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchBar.text = self.placeName;
        _searchBar.placeholder = @"请输入搜索词";
        _searchBar.returnKeyType = UIReturnKeySearch;
        [_searchBar addTarget:self action:@selector(searchBarClicked) forControlEvents:UIControlEventEditingChanged];
        _searchBar.borderStyle = UITextBorderStyleNone;
    }
    return _searchBar;
}
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"搜索" forState:UIControlStateSelected];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn setTitleColor:[UIColor sc_colorWithHex:0x000000] forState:UIControlStateNormal];
        _cancelBtn.frame = CGRectMake(CGRectGetMaxX(self.searchBar.frame)+5,0, 45, 40);
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(PVHistoryAndHotSearchController *)historyAndHotSearchController{
    if (!_historyAndHotSearchController) {
        _historyAndHotSearchController = [[PVHistoryAndHotSearchController alloc] init];
        PV(pv)
        [_historyAndHotSearchController setHistoryAndHotSearchControllerBlock:^(NSString * keyString){
            if(pv.isFamily)
            [pv.resultView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(IPHONE6WH(50)));
            }];
            pv.historyAndHotSearchController.view.hidden = true;
            pv.resultAssociationTableView.hidden = true;
            pv.searchResultViewController.view.hidden = false;
            [pv createGuideThree];
            [pv sendSearch:keyString];
        }];
    }
    return _historyAndHotSearchController;
}
-(PVSearchResultViewController *)searchResultViewController{
    if (!_searchResultViewController) {
        _searchResultViewController = [[PVSearchResultViewController alloc]  init];
        _searchResultViewController.nav = self.nav;
        [self addChildViewController:_searchResultViewController];
        [self.view addSubview:_searchResultViewController.view];
        _searchResultViewController.view.hidden = true;
    }
    return _searchResultViewController;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.searchResultViewController.view.hidden = true;
    self.historyAndHotSearchController.view.hidden = false;
    NSArray* resultHistoryArr = [[PVDBManager sharedInstance] selectAllData];
    self.historyAndHotSearchController.historyDataSource = resultHistoryArr;
    return true;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]  init];
        _topView.backgroundColor = [UIColor sc_colorWithHex:0x2ab4e4];
        UILabel* nickLabel = [[UILabel alloc]  init];
        nickLabel.textAlignment = NSTextAlignmentCenter;
        nickLabel.text = self.nikename;
        nickLabel.font = [UIFont systemFontOfSize:15];
        nickLabel.textColor = [UIColor whiteColor];
        [_topView addSubview:nickLabel];
        [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(_topView);
            make.top.equalTo(@(10));
        }];
        [self.view addSubview:_topView];
    }
    return _topView;
}

-(UIView *)resultView{
    if (!_resultView) {
        _resultView = [[UIView alloc]  init];
        _resultView.backgroundColor = [UIColor whiteColor];
        UILabel* nickLabel = [[UILabel alloc]  init];
//        nickLabel.text = @"    已搜索123个视频，点击后在“昵称”电视上播放";
        nickLabel.font = [UIFont systemFontOfSize:14];
        nickLabel.textColor = [UIColor sc_colorWithHex:0x808080];
        self.totalLabel = nickLabel;
        [_resultView addSubview:nickLabel];
        [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(1));
            make.left.right.equalTo(_resultView);
            make.bottom.equalTo(@(0));
        }];
        [self.view addSubview:_resultView];
        
        UIView* topView = [[UIView alloc]  init];
        topView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        [_resultView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(_resultView);
            make.height.equalTo(@(1));
        }];
//
//        UIView* botttomView = [[UIView alloc]  init];
//        botttomView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
//        [_resultView addSubview:botttomView];
//        [botttomView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.left.right.equalTo(_resultView);
//            make.height.equalTo(@(1));
//        }];
    }
    return _resultView;
}
-(NSMutableArray<PVVideoListModel *> *)searchResultDataSource{
    if (!_searchResultDataSource) {
        _searchResultDataSource = [NSMutableArray array];
    }
    return _searchResultDataSource;
}


//--------------------------------搜索联想-----------------------
/// MARK:- ============ UITableViewDataSource,UITableViewDelegate=======
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.associationDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PVSearchResultAssociationCell* cell = [tableView dequeueReusableCellWithIdentifier:resuPVSearchResultAssociationCell];
    cell.searchWord = self.searchBar.text;
    cell.keyWordModel = self.associationDataSource[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IPHONE6WH(50);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:true];
    PVAssociationKeyWordModel* keyWordModel = self.associationDataSource[indexPath.row];
    [self sendSearch:keyWordModel.word];
}
-(UITableView *)resultAssociationTableView{
    if (!_resultAssociationTableView) {
        _resultAssociationTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _resultAssociationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_resultAssociationTableView registerClass:[PVSearchResultAssociationCell class] forCellReuseIdentifier:resuPVSearchResultAssociationCell];
        _resultAssociationTableView.backgroundColor = [UIColor whiteColor];
        _resultAssociationTableView.hidden = true;
        _resultAssociationTableView.dataSource = self;
        _resultAssociationTableView.delegate = self;
        _resultAssociationTableView.showsVerticalScrollIndicator = false;
        _resultAssociationTableView.showsVerticalScrollIndicator = false;
    }
    return _resultAssociationTableView;
}
-(NSMutableArray *)associationDataSource{
    if (!_associationDataSource) {
        _associationDataSource = [NSMutableArray array];
    }
    return _associationDataSource;
}
-(NSMutableArray *)associationAllDataSource{
    if (!_associationAllDataSource) {
        _associationAllDataSource = [NSMutableArray array];
    }
    return _associationAllDataSource;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:true];
}

@end
