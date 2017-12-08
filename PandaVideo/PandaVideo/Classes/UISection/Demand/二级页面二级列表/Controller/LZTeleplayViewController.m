//
//  LZTeleplayViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "LZTeleplayViewController.h"
#import "PVTeleplayCollectionViewCell.h"
#import "PVTeleplaylistModel.h"
#import "PVScreeningBoxView.h"
#import "PVVideoTemletModel.h"

#define collectionViewCellId @"categoryCollectionCellId"

@interface LZTeleplayViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

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

@property (nonatomic, strong) UIView *boxViewContent;// 全局View

@end

@implementation LZTeleplayViewController
- (id)init {
    if (self = [super init]) {

    }
    return self;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    YYLog(@"22222");
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 打开侧滑返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self createCollectionView];
    [self createRefreshView];
    [self fetchData];
    [self createBeforeView];
    if ([self.title isEqualToString:@"全部"]) {
        _beforeView.hidden = NO;
        _afterView.hidden = NO;
    }else{
        _beforeView.hidden = YES;
        _afterView.hidden = YES;
    }
    
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
    _titlelabel.text = @"爱情.内地.最新";
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
    CGFloat itemWidth  = (YYScreenWidth-13*2)/2.0;
//    CGFloat itemHeight = itemWidth/3.0*2;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(14, 11, 14, 11);
    flowLayout.minimumInteritemSpacing = 1;//设置列与列之间的间距最小距离
    flowLayout.minimumLineSpacing      = 14;//设置行与行之间的间距最小距离
    flowLayout.itemSize = CGSizeMake( itemWidth, 144);//设置每个item的大小
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YYScreenWidth, YYScreenHeight-64-41) collectionViewLayout:flowLayout];
    if (kiPhoneX) {
        self.collectionView.sc_height = YYScreenHeight-54-41-34*2;
    }
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    
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

    // 更新外层约束
    [_boxViewContent mas_updateConstraints:^(MASConstraintMaker *make) {

    }];
}

/** 创建筛选画板外层BoxView */
- (void) createTopView{
    
    _boxViewContent = [[UIView alloc] init];
    _boxViewContent.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    
    _lineView.frame = CGRectMake(0, _boxViewContent.sc_height-1, YYScreenWidth, 0.5);
    [_boxViewContent addSubview:_lineView];
    [self.view insertSubview:_boxViewContent atIndex:10];
}

#pragma mark -
#pragma mark 添加刷新

- (void)createRefreshView {
    
    PV(LZ);
    self.collectionView.mj_header = [PVAnimHeaderRefresh headerWithRefreshingBlock:^{
        if (LZ.isRefreshing) {
            return ;
        }
        LZ.isRefreshing = YES;
        [LZ fetchData];
    }];
}

#pragma mark-
#pragma mark 网络请求
//获取数据
- (void)fetchData {

//    self.teleplayUrl = self.secondColumnModel.listModel[2].url;
    [PVNetTool getDataWithUrl:self.teleplayUrl success:^(id result) {
        if (result != nil) {
            YYLog(@"result -- %@",result);
            
            [self fetchTeleplayData:result[@"models"][0][@"modelUrl"]];
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
        if (result != nil && [result[@"videoList"] isKindOfClass:[NSArray class]]) {
            [self.collectionView.mj_header endRefreshing];
            [self.dataSource removeAllObjects];
            NSMutableArray *jsonDict = [result[@"videoList"] mutableCopy];
            
            for (int i=0; i<[jsonDict count]; i++) {
                [self.dataSource addObject:jsonDict[0][@"info"]];
            }
            //                    PVVideoTemletModel *videoTemletModel = [[PVVideoTemletModel alloc] init];
            //                    [videoTemletModel setValuesForKeysWithDictionary:jsonDict];
            
            [self.collectionView reloadData];
        }
    } failure:^(NSError *errors) {
        [self.collectionView.mj_header endRefreshing];
        YYLog(@"---errors--- = %@",errors);
    }];
}

#pragma mark -
#pragma mark UICollectionView代理

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PVTeleplayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellId forIndexPath:indexPath];
//    RoomlistModel *model = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    YYLog(@" 点击的电视剧是 -- %ld",(long)indexPath.row);
    // 跳转电视播放
//    RoomlistModel *roomlistModel = self.dataSource[indexPath.row];
//    PlayerViewController *playerVC = [[PlayerViewController alloc] init];
//    playerVC.roomId = roomlistModel.room_id;
//    [self.navigationController pushViewController:playerVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = 75; //这里的高度是设置的sectionView的高度
    if (scrollView.contentOffset.y < sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        
        YYLog(@"显示默认界面");
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        if ([self.title isEqualToString:@"全部"]) {
            
            [_afterView removeFromSuperview];
            [_beforeView removeFromSuperview];
            YYLog(@"显示已经滑动的界面");
            [self afterViewCreate];
            _afterView.hidden = NO;
            _beforeView.hidden = YES;
        }
    }
}

@end
