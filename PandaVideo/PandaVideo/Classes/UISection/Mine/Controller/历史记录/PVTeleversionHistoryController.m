//
//  PVTeleversionHistoryController.m
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTeleversionHistoryController.h"
#import "SCSegmentTitleView.h"
#import "PVBaseScrollView.h"
#import "PVTeleversionDetailController.h"


@interface PVTeleversionHistoryController () <SCSegmentTitleViewDelegate,UIScrollViewDelegate>

///标题栏
@property(nonatomic, strong)SCSegmentTitleView* titleView;
///标题数组
@property(nonatomic, strong)NSMutableArray* titles;
///view栏
@property(nonatomic, strong)PVBaseScrollView* contentView;

@end

@implementation PVTeleversionHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}
-(void)setupNavigationBar{
    self.scNavigationItem.title = @"电视观看记录";
    self.automaticallyAdjustsScrollViewInsets = false;
}
-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.titleView belowSubview:self.scNavigationBar];
    [self.view addSubview:self.contentView];
    [self creatContentView];
}
///创建contentView上面的子view
-(void)creatContentView{
    for (int i=0; i<self.titles.count; i++) {
        PVTeleversionDetailController* vc = [[PVTeleversionDetailController alloc]  init];
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
    self.titleView.selectIndex = index;
    UIViewController* vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index*ScreenWidth, 0, ScreenWidth, self.contentView.sc_height);
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:vc.view];
}
-(SCSegmentTitleView *)titleView{
    if (!_titleView) {
        CGRect frame = CGRectMake(IPHONE6WH(80), CGRectGetMaxY(self.scNavigationBar.frame), ScreenWidth-IPHONE6WH(80)*2, 43);
        _titleView = [[SCSegmentTitleView alloc]  initWithFrame:frame titles:self.titles delegate:self indicatorType:SCIndicatorTypeEqualTitle];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.itemMargin = 0;
        
        UIView* bottomView = [[UIView alloc ]  init];
        bottomView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        bottomView.frame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), ScreenWidth, 1);
        [self.view addSubview:bottomView];
    }
    return _titleView;
}

-(NSMutableArray *)titles{
    if (!_titles) {
        NSArray* titles = @[@"电信",@"联通",@"电信",@"联通"];
        _titles = [NSMutableArray arrayWithArray:titles];
    }
    return _titles;
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
        _contentView.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame)+1, ScreenWidth, ScreenHeight-CGRectGetMaxY(self.titleView.frame)-1);
    }
    return _contentView;
}
@end
