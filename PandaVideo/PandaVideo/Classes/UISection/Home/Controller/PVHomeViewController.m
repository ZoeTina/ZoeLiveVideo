//
//  PVHomeViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHomeViewController.h"
#import "PVSearchBar.h"
#import "SCSegmentTitleView.h"
#import "PVHomeTopContainerView.h"
#import "PVSerachViewController.h"
#import "PVColumnEditViewController.h"
#import "PVActivityViewController.h"
#import "PVChoiceColumnController.h"
#import "PVShakeViewController.h"
#import "PVFindHomeViewController.h"
#import "PVHistoryViewController.h"
#import "PVHomModel.h"
#import "PVDBManager.h"
#import "PVTeleplayListViewController.h"
#import "PVDemandViewController.h"
#import "AppDelegate.h"
#import "AppDelegate+UserGuide.h"
@interface PVHomeViewController () <SCSegmentTitleViewDelegate,UIScrollViewDelegate>

///顶部滚动栏
@property(nonatomic, strong)PVHomeTopContainerView* topContainerView;
///view栏
@property(nonatomic, strong)UIScrollView* contentView;
///栏目标题
@property(nonatomic, strong)NSMutableArray* titles;
///数据源
@property(nonatomic, strong)NSMutableArray* dataSource;
///顶部容器高度
@property(nonatomic, assign)CGFloat topViewHeight;
@property(nonatomic, strong)NSTimer* timer;

@end

@implementation PVHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray* resultArr  = [[PVDBManager sharedInstance] selectVisitVideoAllData];
    if (resultArr.count) {
        self.topViewHeight = 150;
    }else{
        self.topViewHeight = 109;
    }
    
    CGRect  frame = CGRectZero;
    for (UIView * view in self.tabBarController.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            frame = view.frame;
            break;
        }
    }
    [self loadData];
    if(![kUserDefaults boolForKey:@"guide_img_guide1"]){
        [kUserDefaults setBool:YES forKey:@"guide_img_guide1"];
        [kUserDefaults synchronize];
        PV(weakSelf);
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate createUserGuide:0 withFrame:frame];
         delegate.userGuideBlock = ^(NSInteger index){
             if (index != 0) {
                 return ;
             }
            [weakSelf loadData];
        };
    }else{
       
    }

    //执行推送跳转
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.isImplementPush){
        appDelegate.isImplementPush = false;
        [appDelegate handleRemoteNotificationWhenAppInBackground:[UIApplication sharedApplication] userInfo:appDelegate.userInfo];
    }
    
}

-(void)startTime{
    NSTimer* timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(timerClicked) userInfo:nil repeats:false];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
    self.timer = timer;
}
-(void)timerClicked{
    [self stopTimer];
    self.topContainerView.continueVideoView.hidden = true;
    self.topViewHeight = 109;
    self.topContainerView.sc_height = self.topViewHeight;
}
-(void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}


-(void)reLoadVCData{
    [self loadData];
}

-(void)loadData{
    if (self.menuUrl.length == 0) return;
    [PVNetTool getDataWithUrl:self.menuUrl success:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            [self.dataSource removeAllObjects];
            NSArray* jsonArr = result;
            for (NSDictionary* dict in jsonArr) {
                PVHomModel* homeModel = [[PVHomModel alloc]  init];
                [homeModel setValuesForKeysWithDictionary:dict];
                [self.dataSource addObject:homeModel];
            }
            /*
            //处理顺序
            NSMutableArray*  columnArr = [NSMutableArray arrayWithArray:[[PVDBManager sharedInstance] selectPVHomModeAllData]];
            if (columnArr.count) {
                //减少本地多余的
                NSMutableArray* reduceDataSource = [NSMutableArray array];
                for (PVHomModel* homeModel in columnArr){
                    for (PVHomModel* tempHomeModel in self.dataSource) {
                        if ([tempHomeModel.columName isEqualToString:homeModel.columName]) {
                            [reduceDataSource addObject:homeModel];
                            break;
                        }
                    }
                }
                [columnArr removeAllObjects];
                [columnArr addObjectsFromArray:reduceDataSource];
                
                //增加网络多余的
                NSMutableArray* newTempDataSource = [NSMutableArray array];
                for (PVHomModel* homeModel in self.dataSource){
                    bool isHaveColumn = false;
                    PVHomModel* recordHomeModel = nil;
                    for (PVHomModel* tempHomeModel in columnArr) {
                        recordHomeModel = homeModel;
                        if ([tempHomeModel.columName isEqualToString:homeModel.columName]) {
                            isHaveColumn = true;
                            break;
                        }
                    }
                    if (!isHaveColumn && ![newTempDataSource containsObject:recordHomeModel]) {//保存新加的栏目
                        [newTempDataSource addObject:recordHomeModel];
                        recordHomeModel = nil;
                    }
                }
                [columnArr addObjectsFromArray:newTempDataSource];
                
                NSMutableArray* newDataSource = [NSMutableArray array];
                NSMutableArray* newColumnArr = [NSMutableArray array];
                for (PVHomModel* tempHomeModel in columnArr){
                    bool isHaveColumn = false;
                    PVHomModel* recordHomeModel = nil;
                    for (PVHomModel* homeModel in self.dataSource) {
                        recordHomeModel = homeModel;
                        if ([tempHomeModel.columName isEqualToString:homeModel.columName]) {
                            isHaveColumn = true;
                            [newDataSource addObject:homeModel];
                            break;
                        }
                    }
                    if (!isHaveColumn && recordHomeModel) {//保存新加的栏目
                        [newColumnArr addObject:recordHomeModel];
                        recordHomeModel = nil;
                    }
                }
                [newDataSource addObjectsFromArray:newColumnArr];
                [self.dataSource removeAllObjects];
                [self.dataSource addObjectsFromArray:newDataSource];
                BOOL resultFlag = [[PVDBManager sharedInstance] deleteAllPVHomModelData];
                if (resultFlag) {
                    for (PVHomModel* homeModel in self.dataSource) {
                        [[PVDBManager sharedInstance]  insertPVHomModel:homeModel];
                    }
                }
            }
             */
            [self setupUI];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scNavigationBar.hidden = true;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.scNavigationBar.hidden = false;
}

-(void)setupUI{
    [self.view addSubview:self.topContainerView];
    self.topContainerView.model = self.dataSource.firstObject;
    [self.view addSubview:self.contentView];
    [self creatContentView];
    [self startTime];
}

///创建contentView上面的子view
-(void)creatContentView{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(self.topContainerView.mas_bottom).offset(0);
        make.bottom.equalTo(@(kTabBarHeight));
    }];
    for (int i=0; i<self.titles.count; i++) {
        PVChoiceColumnController* vc = [[PVChoiceColumnController alloc]  init];
        PVHomModel* model = self.dataSource[i];
        vc.url = model.columUrl;
        [self addChildViewController:vc];
    }
    self.contentView.contentSize = CGSizeMake(self.titles.count*ScreenWidth, 0);
    [self scrollViewDidEndDecelerating:self.contentView];
}

/// MARK:- ===== SCSegmentTitleViewDelegate,UIScrollViewDelegate =======
- (void)SCSegmentTitleView:(SCSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
     [self.contentView setContentOffset:CGPointMake(endIndex*ScreenWidth, 0) animated:false];
    [self scrollViewDidEndDecelerating:self.contentView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setContentChildView];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setContentChildView];
}
-(void)setContentChildView{
    NSInteger index = (int) (self.contentView.contentOffset.x / ScreenWidth);
    self.topContainerView.model = self.dataSource[index];
  //  self.topContainerView.isHiddenTitleView = (index % 2);
//    CGFloat topHeight = (index % 2) ? (self.topViewHeight-self.topContainerView.titleView.sc_height) : self.topViewHeight;
    CGFloat topHeight = self.topViewHeight;
    self.topContainerView.sc_height = topHeight;
    self.topContainerView.titleView.selectIndex = index;
    UIViewController* vc = self.childViewControllers[index];
   // self.isHiddenTitleView = (index % 2);
    vc.view.frame = CGRectMake(index*ScreenWidth, 0, ScreenWidth, self.contentView.sc_height);
    [self.contentView addSubview:vc.view];
}

-(void)scrollColumn:(NSInteger)index{
    CGFloat topHeight = self.topViewHeight;
    self.topContainerView.sc_height = topHeight;
    self.topContainerView.titleView.selectIndex = index;
    UIViewController* vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index*ScreenWidth, 0, ScreenWidth, self.contentView.sc_height);
    [self.contentView addSubview:vc.view];
}

/// MARK:- =========================== 懒加载 ================================
-(PVHomeTopContainerView *)topContainerView{
    if (!_topContainerView) {
        CGFloat y = kiPhoneX ? 24 : 0;
        _topContainerView = [[PVHomeTopContainerView alloc]  initWithFrame:CGRectMake(0, y, ScreenWidth,self.topViewHeight) titles:self.titles delegate:self];
        _topContainerView.searchBar.userInteractionEnabled = false;
        PV(pv);
        [_topContainerView setSearchBarClickedBlock:^{
            PVSerachViewController* vc = [[PVSerachViewController alloc]  init];
            vc.nav = pv.navigationController;
            vc.placeName = pv.topContainerView.searchBar.placeholder;
            [pv.navigationController pushViewController:vc animated:true];
            NSLog(@"搜索点击");
        }];
        [_topContainerView setTimeBtnClickedBlock:^{
            if (pv.topContainerView.model.topType.intValue == 1) {
                PVHistoryViewController* vc = [[PVHistoryViewController alloc]  init];
                vc.type = 0;
                [pv.navigationController pushViewController:vc animated:true];
            }else if (pv.topContainerView.model.topType.intValue == 2){
                PVChoiceColumnController* columnVC = pv.childViewControllers[pv.topContainerView.titleView.selectIndex];
                PVTeleplayListViewController* vc = [[PVTeleplayListViewController alloc]  init];
                vc.secondColumnModel = columnVC.secondColumnModel;
                [pv.navigationController pushViewController:vc animated:true];
                NSLog(@"筛选");
            }
        }];
        [_topContainerView setShakeBtnClickedBlock:^{
            if (pv.topContainerView.model.topType.intValue == 1) {
                PVShakeViewController* vc = [[PVShakeViewController alloc]  init];
                [pv.navigationController pushViewController:vc animated:true];
                NSLog(@"摇一摇");
            }
        }];
        [_topContainerView setEditBtnClickedBlock:^{
            PVColumnEditViewController* vc = [[PVColumnEditViewController alloc] init];
            vc.dataSource = pv.dataSource;
            [pv.navigationController pushViewController:vc animated:true];
            vc.columnEditViewControllerBlock = ^(NSArray *columnDataSource, NSInteger selectedIndex) {
                NSLog(@" columnDataSource = %@",columnDataSource);
                [pv columnEdit:columnDataSource];
            };
        }];
        [_topContainerView setContinueVideoTapGestureClickedBlock:^(PVHistoryModel *historyModel) {
            PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
            vc.continuePlayVideoSecond = @"0";
           // [NSString stringWithFormat:@"%ld",historyModel.playLength];
            vc.code = historyModel.code;
            vc.url = historyModel.jsonUrl;
            [pv.navigationController pushViewController:vc animated:true];
        }];
    }
    return _topContainerView;
}
-(void)columnEdit:(NSArray*)columnDataSource{
    NSMutableArray* columnTitles = [NSMutableArray arrayWithCapacity:columnDataSource.count];
    NSMutableArray* vcArrs = [NSMutableArray arrayWithCapacity:columnDataSource.count];
    NSUInteger selectedIndex = 0;
    for (PVHomModel* homeModel in columnDataSource) {
        for (int i=0; i<self.dataSource.count; i++) {
            PVHomModel* model = self.dataSource[i];
            if([model.columName isEqualToString:homeModel.columName]){
                [vcArrs addObject:self.childViewControllers[i]];
                break;
            }
        }
        [columnTitles addObject:homeModel.columName];
    }
    NSInteger index = self.dataSource.count - 1;
    for (NSInteger i = index ; i > 0; i--) {
        UIViewController *vc = self.childViewControllers[i];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    PVHomModel* modelIndex = self.dataSource[self.topContainerView.titleView.selectIndex];
    for (int i = 0; i < columnDataSource.count; i++) {
        PVHomModel* tempModel = columnDataSource[i];
        if ([tempModel.columName isEqualToString:modelIndex.columName]) {
            selectedIndex = i;
        }
        UIViewController *vc = vcArrs[i];
        [self addChildViewController:vc];
    }
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:columnDataSource];
    self.contentView.contentSize = CGSizeMake(self.titles.count*ScreenWidth, 0);
    self.topContainerView.titleView.titlesArr = columnTitles;
    [self SCSegmentTitleView:self.topContainerView.titleView startIndex:selectedIndex endIndex:selectedIndex];

}
-(UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.scrollsToTop = false;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.delegate = self;
        _contentView.pagingEnabled = YES;
        _contentView.bounces = NO;
        CGFloat botttom = kiPhoneX ? 73 : 49;
        _contentView.contentInset = UIEdgeInsetsMake(0, 0, botttom, 0);
      ;
//        _contentView.frame = CGRectMake(0, CGRectGetMaxY(self.topContainerView.frame)-1.7, ScreenWidth, ScreenHeight-CGRectGetMaxY(self.topContainerView.frame));
    }
    return _contentView;
}
-(NSMutableArray *)titles{
    if (!_titles) {
        _titles = [NSMutableArray arrayWithCapacity:self.dataSource.count];
        for (PVHomModel* homeModel in self.dataSource) {
            [_titles addObject:homeModel.columName];
        }
    }
    return _titles;
}
-(NSMutableArray*)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



@end
