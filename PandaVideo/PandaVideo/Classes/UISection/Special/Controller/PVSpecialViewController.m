//
//  PVSpecialViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/9.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSpecialViewController.h"
#import "PVSerachViewController.h"
#import "SCSegmentTitleView.h"
#import "PVSpecialDetailViewController.h"
#import "PVBaseScrollView.h"
#import "PVTopicModel.h"


@interface PVSpecialViewController () <SCSegmentTitleViewDelegate,UIScrollViewDelegate>

///标题栏
@property(nonatomic, strong)SCSegmentTitleView* titleView;
///view栏
@property(nonatomic, strong)PVBaseScrollView* contentView;
///数据源
@property(nonatomic, strong)NSMutableArray<PVTopicModel*>* dataSource;

@end

@implementation PVSpecialViewController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];


}

-(void)loadData{
    [PVNetTool getDataWithUrl:self.url success:^(id result) {
        if (result && [result isKindOfClass:[NSArray class]]) {
            NSArray* jsonArr = result;
            [self.dataSource removeAllObjects];
            for (NSDictionary* jsonDict in jsonArr) {
                PVTopicModel* topicModel = [[PVTopicModel alloc]  init];
                [topicModel setValuesForKeysWithDictionary:jsonDict];
                [self.dataSource addObject:topicModel];
            }
            [self setupUI];
        }
    } failure:^(NSError *error) {
    }];
    
    
}


-(void)setupNavigationBar{
    self.scNavigationItem.title = @"专题";
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"home2_btn_search"] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(0, 0, 40, 40);
    [searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]  initWithCustomView:searchBtn];
    
    self.scNavigationItem.rightBarButtonItem = rightItem;
}
-(void)searchBtnClicked{
    PVSerachViewController* vc = [[PVSerachViewController alloc]  init];
    vc.nav = self.navigationController;
    [self.navigationController pushViewController:vc animated:true];
}
-(void)setupUI{
    [self.view insertSubview:self.titleView belowSubview:self.scNavigationBar];
    [self.view addSubview:self.contentView];
    [self creatContentView];
}
///创建contentView上面的子view
-(void)creatContentView{
    for (int i=0; i<self.dataSource.count; i++) {
        PVSpecialDetailViewController* vc = [[PVSpecialDetailViewController alloc]  init];
        vc.topicModel = self.dataSource[i];
        [self addChildViewController:vc];
    }
    self.contentView.contentSize = CGSizeMake(self.dataSource.count*ScreenWidth, 0);
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
    self.titleView.selectIndex = index;
    UIViewController* vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index*ScreenWidth, 0, ScreenWidth, self.contentView.sc_height);
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:vc.view];
}
-(SCSegmentTitleView *)titleView{
    if (!_titleView) {
        NSMutableArray* titles = [NSMutableArray arrayWithCapacity:self.dataSource.count];
        for (PVTopicModel* topicModel in self.dataSource) {
            [titles addObject:topicModel.topicColumnName];
        }
        CGRect frame = CGRectMake(0, kNavBarHeight, ScreenWidth, 43);
        _titleView = [[SCSegmentTitleView alloc]  initWithFrame:frame titles:titles delegate:self indicatorType:SCIndicatorTypeEqualTitle];
        [_titleView setTitleSelectFont: [UIFont fontWithName:FontBlod size:15]];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}
-(NSMutableArray<PVTopicModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(PVBaseScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[PVBaseScrollView alloc] init];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.scrollsToTop = false;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.delegate = self;
        _contentView.pagingEnabled = YES;
        _contentView.bounces = NO;
        CGFloat bottom = kiPhoneX ? (CGRectGetMaxY(self.titleView.frame) + 34) : CGRectGetMaxY(self.titleView.frame);
        _contentView.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), ScreenWidth, ScreenHeight-bottom);
    }
    return _contentView;
}
@end
