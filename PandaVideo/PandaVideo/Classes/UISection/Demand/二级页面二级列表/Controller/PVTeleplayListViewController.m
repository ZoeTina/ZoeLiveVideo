//
//  PVTeleplayListViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTeleplayListViewController.h"
#import "LZScrollContentView.h"
#import "PVTeleplayChildViewController.h"
#import "PVSerachViewController.h"
#import "SCSegmentTitleView.h"
#import "PVBaseScrollView.h"
#import "UIScrollView+PVExtension.h"

@interface PVTeleplayListViewController ()<LZPageContentViewDelegate,SCSegmentTitleViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) LZPageContentView *pageContentView;
//@property (nonatomic, strong) LZSegmentTitleView *titleView;...
@property(nonatomic, strong)SCSegmentTitleView* titleView;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *sortArray;

@end

@implementation PVTeleplayListViewController

-(instancetype)initWithModels:(PVChoiceSecondColumnModel *) secondColumnModel{
    
    if ( self = [super init] )
    {
//        YYLog(@"PVTeleplayListViewController --- %@",secondColumnModel.filter.area_detail);
//        self.secondColumnModel = secondColumnModel;
    }
    return self;
}

-(NSMutableArray *)titleArray{
    
    if (_titleArray == nil) {
//        _titleArray = @[@"全部",@"最新热播",@"同步热播",@"同步热报",@"同步热播",@"同步追剧",@"直播购物",@"其他"];
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

-(NSMutableArray *)sortArray{
    
    if (_sortArray == nil) {
        _sortArray = [[NSMutableArray alloc] init];
    }
    return _sortArray;
}

- (void) setupNavigationBar{
    self.scNavigationItem.title = self.secondColumnModel.baseInfo.name;
}

-(void)setSecondColumnModel:(PVChoiceSecondColumnModel *)secondColumnModel{
    _secondColumnModel = secondColumnModel;
    // 设置Code
    [self.sortArray addObject:@"lz_000000000000"];
    // 循环取出title
    [self.titleArray addObject:@"全部"];
    for (int i=0; i<self.secondColumnModel.listModel.count; i++) {
        [self.titleArray addObject:self.secondColumnModel.listModel[i].name];
        [self.sortArray addObject:self.secondColumnModel.listModel[i].code];
    }
    YYLog(@"tiA -- %@ -- code - %@",self.titleArray,self.sortArray);
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorWithRGB(242, 242, 242);
    BOOL isEqual = false;
    if (self.secondColumnModel) {
        for (int i=0; i<self.secondColumnModel.listModel.count; i++) {
            if ([self.secondColumnModel.baseInfo.code isEqualToString:self.secondColumnModel.listModel[i].code]) {
                self.url = self.secondColumnModel.listModel[i].url;
                [self setupUI:i];
                break;
            }else{
                isEqual = true;
            }
        }
        if (isEqual) {
            [self setupUI:0];
        }
    }else{
        [self loadData];
    }
}

-(void)loadData{
    [PVNetTool getDataWithUrl:self.url success:^(id result) {
        if (result) {
            PVChoiceSecondColumnModel *secondColumnModel = [[PVChoiceSecondColumnModel alloc]  init];
            [secondColumnModel setValuesForKeysWithDictionary:result];
            self.secondColumnModel = secondColumnModel;
            // 匹配数组得到下标
            for (int i = 0; i < self.sortArray.count; i++) {
                if ([self.secondColumnModel.baseInfo.code isEqualToString:self.sortArray[i]]) {
                    [self setupUI:i];
                }
            }
        }
    } failure:^(NSError *error) {
        YYLog(@"------error----%@-",error);
    }];
}
-(void)setupUI:(NSInteger) selectIndex{
    
    if (selectIndex==0) {
        self.scNavigationItem.title = @"全部";
    }else{
        self.scNavigationItem.title = self.secondColumnModel.baseInfo.name;
    }
    
    CGFloat lz_y;
    if (kiPhoneX) {
        lz_y = lz_kiPhoneX(54);
    }else{
        lz_y = lz_kiPhoneX(64);
    }
    
    self.titleView = [[SCSegmentTitleView alloc]initWithFrame:CGRectMake(0, lz_y, YYScreenWidth, 41) titles:self.titleArray delegate:self indicatorType:SCIndicatorTypeEqualTitle];
    [self.titleView setTitleSelectFont: [UIFont fontWithName:FontBlod size:15]];
    self.titleView.backgroundColor = kColorWithRGB(255, 255, 255);
    self.titleView.selectIndex = selectIndex;
    [self.view addSubview:_titleView];
    
    // 标题下的分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40.5, YYScreenWidth, 0.5)];
    lineView.backgroundColor = lineColor;
    [_titleView addSubview:lineView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in self.titleArray) {
        PVTeleplayChildViewController *vc = [[PVTeleplayChildViewController alloc] initWithModels:self.secondColumnModel];
        vc.title = title;
        [childVCs addObject:vc];
    }
    self.pageContentView = [[LZPageContentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), YYScreenWidth, YYScreenHeight-CGRectGetMaxY(self.titleView.frame)) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = selectIndex;
    self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
    [self.view addSubview:_pageContentView];
    
    UIImage *rightImg = [UIImage imageNamed:@"home2_btn_search"];
    rightImg = [rightImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.scNavigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImg style:UIBarButtonItemStylePlain target:self action:@selector(enterSearchClick)];
}


/** 搜索 */
- (void)enterSearchClick{
    PVSerachViewController* vc = [[PVSerachViewController alloc]  init];
    vc.nav = self.navigationController;
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark --
- (void)SCSegmentTitleView:(SCSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    self.pageContentView.contentViewCurrentIndex = endIndex;
    self.title = _titleArray[endIndex];
    self.scNavigationItem.title = self.title;
}

- (void)LZSegmentTitleView:(LZSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
    self.title = _titleArray[endIndex];
    self.scNavigationItem.title = self.title;
}

- (void)LZContenViewDidEndDecelerating:(LZPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    self.title = _titleArray[endIndex];
    self.scNavigationItem.title = self.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
