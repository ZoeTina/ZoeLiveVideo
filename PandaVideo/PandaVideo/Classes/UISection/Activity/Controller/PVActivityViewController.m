//
//  PVActivityViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVActivityViewController.h"
#import "SCSegmentTitleView.h"
#import "PVChoiceColumnController.h"
#import "PVTopicModel.h"

@interface PVActivityViewController () <SCSegmentTitleViewDelegate,UIScrollViewDelegate>

///标题栏
@property(nonatomic, strong)SCSegmentTitleView* titleView;
///view栏
@property(nonatomic, strong)UIScrollView* contentView;
///数据源
@property(nonatomic, strong)NSMutableArray<PVTopicModel*>* dataSource;

@end

@implementation PVActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scNavigationBar.hidden = true;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.scNavigationBar.hidden = false;
}

-(void)loadData{
    if (!self.menuUrl.length)return;
    [PVNetTool getDataWithUrl:self.menuUrl success:^(id result) {
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
        NSLog(@"-------result--------%@",result);
    } failure:^(NSError *error) {
        NSLog(@"-------error--------%@",error);
    }];
}


-(void)setupUI{
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.contentView];
    [self creatContentView];
}
///创建contentView上面的子view
-(void)creatContentView{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(self.titleView.mas_bottom).offset(0);
        make.bottom.equalTo(@(0));
    }];
    for (int i=0; i<self.dataSource.count; i++) {
        PVChoiceColumnController* vc = [[PVChoiceColumnController alloc]  init];
        vc.navType = 3;
        vc.url = self.dataSource[i].topicColumnUrl;
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
    [self.contentView addSubview:vc.view];
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
        _contentView.contentInset = UIEdgeInsetsMake(0, 0, kTabBarHeight, 0);
        ;
    }
    return _contentView;
}
-(SCSegmentTitleView *)titleView{
    if (!_titleView) {
        CGFloat y = kiPhoneX ? 34 : 20;
        CGRect frame = CGRectMake(0, y, ScreenWidth, 43);
        NSMutableArray* titles = [NSMutableArray arrayWithCapacity:self.dataSource.count];
        for (PVTopicModel* topicModel in self.dataSource) {
            [titles addObject:topicModel.topicColumnName];
        }
        if (titles.count == 1) {
            CGSize size = [UILabel messageBodyText:titles.firstObject andSyFontofSize:15 andLabelwith:ScreenWidth andLabelheight:15];
            frame = CGRectMake((ScreenWidth-size.width-30)*0.5, y, size.width+30, 43);
        }
        _titleView = [[SCSegmentTitleView alloc]  initWithFrame:frame titles:titles delegate:self indicatorType:SCIndicatorTypeEqualTitle];
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

@end
