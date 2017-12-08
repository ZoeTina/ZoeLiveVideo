//
//  PVTeleplayChildViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTeleplayChildViewController.h"
#import "PVTeleplayCollectionViewCell.h"
#import "PVTeleplayCollectionViewCell.h"
#import "PVTeleplaylistModel.h"
#import "PVScreeningBoxView.h"
#import "PVVideoListModel.h"
#import "PVDemandViewController.h"

#define collectionViewCellId @"categoryCollectionCellId"

@interface PVTeleplayChildViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray     *dataSource;

@property (nonatomic) BOOL isRefreshing;

/***********  筛选后的布局  ***********/
/** 分割线视图 */
@property (nonatomic, strong) UIView *lineView;
/** 筛选后的View */
@property (nonatomic, strong) UIView *afterView;
/** 筛选后的文字显示 */
@property (nonatomic, strong) UILabel *titlelabel;


/***********  筛选前的布局  ***********/

@property (nonatomic, strong) PVScreeningBoxView *beforeView; // 筛选前的View

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,assign) NSInteger currentSreenIndex;

@property (nonatomic,assign) NSInteger pageAllIndex;
@property (nonatomic,copy) NSString *moreDataURL;
///哪一种cell类型
@property(nonatomic, assign)NSInteger cellType;
///一级栏目全部还是二级栏目
@property(nonatomic, assign)NSInteger columnType;
///类型标题
@property(nonatomic, copy)NSString* typeTitle;

@property(nonatomic,copy)NSArray *screenArray;//筛选数组

@end

@implementation PVTeleplayChildViewController

-(instancetype)initWithModels:(PVChoiceSecondColumnModel *) secondColumnModel{
    
    if ( self = [super init] )
    {
        self.secondColumnModel = secondColumnModel;
        self.teleplayUrl = self.secondColumnModel.listModel[0].url;
        self.typeTitle = @"全部";
    }
    return self;
}

- (void) setupNavigationBar{
   // self.scNavigationItem.title = self.title;
}

- (void)viewWillAppear:(BOOL)animated
{
   // [self.collectionView.mj_header beginRefreshing];
    
    [super viewWillAppear:animated];
//    self.scNavigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],
//                                               NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSString *)composeRequestUrl {
    return self.teleplayUrl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWithRGB(0, 0, 0);
    // Do any additional setup after loading the view.

    [kNotificationCenter addObserver:self
                            selector:@selector(updateCollectionData:)
                                name:@"updateCollectionData"
                              object:nil];
    
    if (self.type==3) {
        [self createCollectionView];
        [self createRefreshView];
        [self fetchData];
    }else{
        // 根据数组的值匹配，取出对应标题URL
        for (int i=0; i<self.secondColumnModel.listModel.count; i++) {
            if ([self.title isEqualToString:self.secondColumnModel.listModel[i].name]) {
                self.teleplayUrl = self.secondColumnModel.listModel[i].url;
                self.columnType = 1;
            }else if ([self.title isEqualToString:@"全部"]){
                // 标题为全部的情况
                self.columnType = 2;
                self.teleplayUrl = self.secondColumnModel.listModel[i].url;
            }
        }
        [self createCollectionView];
        [self createRefreshView];
        [self.collectionView.mj_header beginRefreshing];
       // [self fetchData];
        [self createBeforeView];
        if ([self.title isEqualToString:@"全部"]) {
            _beforeView.hidden = NO;
            _afterView.hidden = NO;
        }else{
            _beforeView.hidden = YES;
            _afterView.hidden = YES;
        }
    }
}

- (void)updateCollectionData:(NSNotification *)notif{
    
    NSString *keys = notif.userInfo[@"keys"];
    NSString *filterKey = notif.userInfo[@"filterKey"];
    NSString *kid = notif.userInfo[@"kId"];
    //    columnId  一级栏目ID      string
    //    index     当前分页开始数量  number
    //    keys      请求参数数组     array<object>
    //    key       过滤请求参数     string
    //    value     过滤请求参数值   string
    //    pageSize  每页返回值
    [self.dataSource removeAllObjects];
    NSMutableArray *mbKeysArray = [[NSMutableArray alloc] init];
    NSString* title = @"";
    for (Filter *filter in self.secondColumnModel.filterList) {
        if ([filter.filterKey isEqualToString:filterKey]) {
            for (KeyModel *keyModel in filter.keys) {
                if ((keyModel.kId.integerValue != kid.integerValue) || (kid.integerValue == 100)){
                    continue;
                }
                NSDictionary* dict = @{@"key":filterKey,@"value":kid};
                title = [NSString stringWithFormat:@"%@.%@",title,keyModel.name];
                [mbKeysArray addObject:dict];
                break;
            }
        }else{
            for (KeyModel *keyModel in filter.keys) {
                if (keyModel.isSelect){
                    if (keyModel.kId.integerValue == 100) {
                        continue;
                    }else{
                        NSDictionary* dict = @{@"key":filter.filterKey,@"value":keyModel.kId};
                        title = (title.length < 1) ? keyModel.name : [NSString stringWithFormat:@"%@.%@",title,keyModel.name];
                        [mbKeysArray addObject:dict];
                    }
                    break;
                }
            }
        }
    }
   
    if (title.length) {
        self.typeTitle = title;
    }else{
        self.typeTitle = @"全部";
    }
    self.screenArray = [NSArray arrayWithArray:mbKeysArray];
    [self loadAllData:mbKeysArray];
    
}
-(void)loadAllData:(NSArray*)jsonArr{
    NSDictionary *params = @{@"columnId":self.secondColumnModel.baseInfo.parentId,
                             @"index":[NSString stringWithFormat:@"%ld",self.currentSreenIndex] ,
                             @"keys":(jsonArr ? jsonArr : @""),
                             @"pageSize":@"20"
                             };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *tempString = @"";
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        tempString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSString* textUrl = [NSString stringWithFormat:@"%@?params=%@",@"getFilterResultList",tempString];
    PV(weakSelf);
    [PVNetTool postDataWithParams:nil url:textUrl success:^(id result) {
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        if (result) {
            PVVideoSiftingModel * model = [PVVideoSiftingModel yy_modelWithJSON:result[@"data"]];
            weakSelf.pageAllIndex = model.pageAllIndex;
            [weakSelf.collectionView reloadData];
            if (weakSelf.currentSreenIndex == 1) {
                 [weakSelf.dataSource removeAllObjects];
            }
            [weakSelf.dataSource addObjectsFromArray:model.videoList];
            [weakSelf.collectionView reloadData];
            if (weakSelf.currentSreenIndex >= weakSelf.pageAllIndex) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } failure:^(NSError *errors) {
        if (weakSelf.currentSreenIndex != 0) {
            weakSelf.currentSreenIndex--;
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        YYLog(@"---errors--- = %@",errors);
    }];
    
    [self.collectionView reloadData];
    
    
}


/** 创建筛选之后的画板 */
- (void) afterViewCreate{
    
    _afterView = [[UIView alloc] init];
    _afterView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    _afterView.frame = CGRectMake(0, 0, YYScreenWidth, 40);
    
    _titlelabel = [[UILabel alloc] initWithFrame:_afterView.bounds];
    _titlelabel.font = [UIFont systemFontOfSize:15.0];
    _titlelabel.textAlignment = NSTextAlignmentCenter;
    _titlelabel.textColor = kColorWithRGB(42, 180, 228);
    _titlelabel.text = self.typeTitle;
    self.lineView.frame = CGRectMake(0, _afterView.sc_height-1,YYScreenWidth, 0.5);
    [_afterView addSubview:_titlelabel];
    [_afterView addSubview:_lineView];
    
    [self.view insertSubview:_afterView atIndex:10];
    _afterView.userInteractionEnabled = YES;
    _titlelabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
    [_titlelabel addGestureRecognizer:labelTapGestureRecognizer];
}

/** 点击筛选后的窗口显示筛选前的窗口 */
- (void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    UILabel *label=(UILabel*)recognizer.view;
    [self lz_make:label.text];
    
    [_afterView removeFromSuperview];
    [_beforeView removeFromSuperview];
    [self createBeforeView];
    _afterView.hidden = YES;
    _beforeView.hidden = NO;

    
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor  = lineColor;
    }
    return _lineView;
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 3;//设置列与列之间的间距最小距离
    flowLayout.minimumLineSpacing      = 3;//设置行与行之间的间距最小距离
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    if (self.type==3){
        CGRect frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        if (kiPhoneX) {
            self.collectionView.sc_height = kScreenHeight-34*2;
        }
    }else{
        CGRect frame;
        if ([self.title isEqualToString:@"全部"]) {
            frame = CGRectMake(0, 41, kScreenWidth, kScreenHeight-64-41*2);
        }else{
            frame = CGRectMake(0, 0, kScreenWidth, YYScreenHeight-64-41);
        }
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        if (kiPhoneX) {
            if ([self.title isEqualToString:@"全部"]) {
                self.collectionView.sc_height = kScreenHeight-54-41*2-34*2;
            }else{
                self.collectionView.sc_height = kScreenHeight-54-41-34*2;
            }
        }
    }
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    self.collectionView.scrollsToTop = true;

    UINib *nib = [UINib nibWithNibName:@"PVTeleplayCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:collectionViewCellId];
    
    [self.view addSubview:self.collectionView];
}

/** 创建筛选分类画板 */
- (void) createBeforeView{
    
    _beforeView = [[PVScreeningBoxView alloc] initWithModels:self.secondColumnModel];
    _beforeView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    //    _beforeView.frame = CGRectMake(0, 0, YYScreenWidth, 350);
    [self.view insertSubview:_beforeView atIndex:10];
    [_beforeView addSubview:self.lineView];
    self.lineView.frame = CGRectMake(0, _beforeView.sc_height-1,YYScreenWidth, 0.5);
    if ([self.title isEqualToString:@"全部"]) {
        self.collectionView.sc_y = CGRectGetMaxY(self.lineView.frame);
        self.collectionView.sc_height = kScreenHeight-CGRectGetMaxY(self.lineView.frame);
    }
}

#pragma mark -
#pragma mark 添加刷新

- (void)createRefreshView {
    
    PV(LZ);
    self.collectionView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        
        if (LZ.columnType == 1) {//静态接口
            [LZ fetchData];
        }else if (self.columnType == 2){//全部动态接口
            LZ.currentSreenIndex = 1;
            [LZ loadAllData:nil];
        }
    }];

    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    
        YYLog(@"_pageAllIndex -- %ld \n _currentIndex -- %ld \n self.teleplayUrl --%@ ",
              (long)_pageAllIndex,(long)_currentIndex,LZ.teleplayUrl);
        if (_currentIndex<_pageAllIndex) {
            if (LZ.columnType == 1) {
                _currentIndex++;// 页码+1
                NSArray *videoMakeArr = [LZ.moreDataURL componentsSeparatedByString:@".json"];
                NSString *URLString = [NSString stringWithFormat:@"%@_%ld.json",videoMakeArr[0],(long)_currentIndex];
                YYLog(@"URLString -- %@",URLString);
                [LZ fetchTeleplayMoreData:URLString];
            }else if (LZ.columnType == 2){//全部动态接口
                _currentSreenIndex++;// 页码+1
                [LZ loadAllData:LZ.screenArray];
            }
            
        }else{
            [LZ.collectionView.mj_footer endRefreshing];
        }
    }];

}

#pragma mark-
#pragma mark 网络请求
//获取数据
- (void)fetchData {
    [PVNetTool getDataWithUrl:self.teleplayUrl success:^(id result) {
        if (result != nil) {
            _currentIndex = 0;
            
            PVChoiceSecondColumnModels *models = [[PVChoiceSecondColumnModels alloc] init];
            [models setValuesForKeysWithDictionary:result[@"models"][0]];
            if ([result[@"models"] isKindOfClass:[NSArray class]]) {
                NSArray* tempModels = result[@"models"];
                if ([tempModels count] > 0) {
                    self.cellType = [models.modelType integerValue];
                    [self fetchTeleplayData:models.modelUrl];
                    self.moreDataURL = models.modelUrl;
                }else{
                    YYLog(@"Models没数据--");
                }
            }
        }
    } failure:^(NSError *errors) {
        [self.collectionView.mj_header endRefreshing];
        YYLog(@"---errors--- = %@",errors);
    }];
    
    [self.collectionView reloadData];
}

// 获取节目数据（CollectionView）
- (void) fetchTeleplayData:(NSString *) URLString{
    [PVNetTool getDataWithUrl:URLString success:^(id result) {
        
        [self.collectionView.mj_header endRefreshing];
        
        if (result) {
            PVVideoTemletModel *templetModel = [[PVVideoTemletModel alloc] init];
            [templetModel setValuesForKeysWithDictionary:result];
            self.templetModel = templetModel;
        }
    
        if (result != nil && [self.templetModel.videoListModel isKindOfClass:[NSArray class]]) {
            [self.collectionView.mj_header endRefreshing];
            [self.dataSource removeAllObjects];
            _currentIndex = 0;
            _pageAllIndex = (long)[result[@"pageAllIndex"] integerValue];
            _currentIndex = (long)[result[@"currentIndex"] integerValue];
            for (int i=0; i<[self.templetModel.videoListModel count]; i++) {
                [self.dataSource addObject:self.templetModel.videoListModel[i]];
            }
            
            [self.collectionView reloadData];
        }
    } failure:^(NSError *errors) {
        if (self.currentIndex != 0) {
            self.currentIndex--;
        }
        [self.collectionView.mj_header endRefreshing];
        YYLog(@"---errors--- = %@",errors);
    }];
}

// 获取节目数据（CollectionView）上拉加载更多
- (void) fetchTeleplayMoreData:(NSString *) URLString{
    [PVNetTool getDataWithUrl:URLString success:^(id result) {

        if (result) {
            PVVideoTemletModel *templetModel = [[PVVideoTemletModel alloc] init];
            [templetModel setValuesForKeysWithDictionary:result];
            self.templetModel = templetModel;
        }
        
        if (result != nil && [self.templetModel.videoListModel isKindOfClass:[NSArray class]]) {
            [self.collectionView.mj_footer endRefreshing];
            for (int i=0; i<[self.templetModel.videoListModel count]; i++) {
                [self.dataSource addObject:self.templetModel.videoListModel[i]];
            }
            [self.collectionView reloadData];
//            self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    } failure:^(NSError *errors) {
        [self.collectionView.mj_header endRefreshing];
        YYLog(@"---errors--- = %@",errors);
    }];
}

#pragma mark -
#pragma mark UICollectionView代理
//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat leftAndRight = 24;
    CGFloat margin = 3;
    CGFloat fixedValue = 50;
    CGFloat itemWidth = (collectionView.sc_width-margin-leftAndRight)*0.5;
    CGFloat itemHeight = itemWidth*98/174 + fixedValue;    
    id model = [self.dataSource sc_safeObjectAtIndex:0];
    if ([model isKindOfClass:[PVVideoListModel  class]]) {
        // 显示模板类型(17.横图，18.竖图)
        if (self.cellType == 18) {
            itemWidth = (collectionView.sc_width-2*margin-leftAndRight)/3;
            itemHeight = itemWidth*4/3 + fixedValue;
        }
    }
    return CGSizeMake(itemWidth,itemHeight);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,12,0,12);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PVTeleplayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
    id model = [self.dataSource sc_safeObjectAtIndex:0];
    if ([model isKindOfClass:[PVVideoListModel  class]]) {
        cell.modelType = self.cellType;
        cell.videoListModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    }else if([model isKindOfClass:[PVVideoSiftingListModel class]]){
        cell.modelType = 17;
        cell.model = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * urlString = @"";
    id model = [self.dataSource sc_safeObjectAtIndex:0];
    if ([model isKindOfClass:[PVVideoListModel  class]]) {
        PVVideoListModel * videoModel = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
        urlString = videoModel.info.jsonUrl;
    }else if([model isKindOfClass:[PVVideoSiftingListModel class]]){
        PVVideoSiftingListModel *model = [self.dataSource sc_safeObjectAtIndex:indexPath.row];
        urlString = model.videoUrl;
    }
    // 跳转电视播放
    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
    vc.url = urlString;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = 75; //这里的高度是设置的sectionView的高度
    if (scrollView.contentOffset.y < sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        
//        YYLog(@"显示默认界面");
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        if ([self.title isEqualToString:@"全部"]) {
            
            [_afterView removeFromSuperview];
            [_beforeView removeFromSuperview];
//            YYLog(@"显示已经滑动的界面");
            [self afterViewCreate];
            _afterView.hidden = NO;
            _beforeView.hidden = YES;
            self.collectionView.sc_y = 41;
            self.collectionView.sc_height = kScreenHeight-41*2-64;
            if (kiPhoneX) {
                self.collectionView.sc_height = kScreenHeight-54-41*2-34*2;
            }
        }
    }
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumLineSpacing = 3;
        flowLayout.minimumInteritemSpacing = 3;
        CGFloat y = 1+CGRectGetMaxY(self.afterView.frame);
        CGRect frame = CGRectMake(0, y, kScreenWidth, self.view.sc_height-y);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        CGFloat bottom = kiPhoneX ? 34 : 1;
        _collectionView.sc_height = self.view.sc_height-bottom-y;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        UINib *nib = [UINib nibWithNibName:@"PVTeleplayCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:collectionViewCellId];
        _collectionView.scrollsToTop = true;
    }
    return _collectionView;
}

-(void)dealloc{
    [kNotificationCenter removeObserver:self];
}

@end
