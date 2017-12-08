//
//  PVInfomationViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInfomationViewController.h"
#import "PVNoticeViewController.h"
#import "PVInfoCommentViewController.h"
#import "SCSegmentTitleView.h"
#import "PVBaseScrollView.h"
#import "SCSegmentTitleView.h"

@interface PVInfomationViewController ()<UIScrollViewDelegate,SCSegmentTitleViewDelegate>
///标题栏
@property(nonatomic, strong)SCSegmentTitleView* titleView;
///标题数组
@property(nonatomic, strong)NSMutableArray* titles;
///view栏
@property(nonatomic, strong)PVBaseScrollView* contentView;
@property (nonatomic, strong) UILabel *noticeNumlabel;
@end

@implementation PVInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self addObverser];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObverser {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNoticeNum:) name:@"changeNoticeNum" object:nil];
}

- (void)changeNoticeNum:(NSNotification *)notification {
    NSInteger num = [[notification.userInfo pv_objectForKey:@"noticeNum"] integerValue];
    if (num == 0) {
        self.noticeNumlabel.hidden = YES;
    }else {
        self.noticeNumlabel.hidden = NO;
        self.noticeNumlabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    }
    
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"消息记录";
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
    
    PVNoticeViewController *noticeVC = [[PVNoticeViewController alloc] init];
    [self addChildViewController:noticeVC];
    
    PVInfoCommentViewController *commentVC = [[PVInfoCommentViewController alloc] init];
    [self addChildViewController:commentVC];
    
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
    [self.contentView addSubview:vc.view];
}


-(SCSegmentTitleView *)titleView{
    if (!_titleView) {
        CGRect frame = CGRectMake((ScreenWidth - kDistanceWidthRatio(160))*0.5, CGRectGetMaxY(self.scNavigationBar.frame), kDistanceWidthRatio(160), 43);
        _titleView = [[SCSegmentTitleView alloc] initWithFrame:frame titles:self.titles delegate:self indicatorType:SCIndicatorTypeEqualTitle];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.itemMargin = kDistanceWidthRatio(50);
        
        for (UIView *subView in _titleView.subviews) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *subScrollView in subView.subviews) {
                    if ([subScrollView isKindOfClass:[UIButton class]]) {
                        UIButton *firstBtn = (UIButton *)subScrollView;
                        if ([firstBtn.currentTitle isEqualToString:@"通知"]) {
                            [firstBtn addSubview:self.noticeNumlabel];
                            [self.noticeNumlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo(firstBtn.mas_right).mas_offset( - kDistanceWidthRatio(30));
                                make.top.equalTo(firstBtn.mas_top).mas_offset(10);
                                make.width.height.mas_equalTo(15);
                            }];
                        }
                    }
                    
                }
                
            }
        }
        
        UIView* bottomView = [[UIView alloc ]  init];
        bottomView.backgroundColor = [UIColor sc_colorWithHex:0xD7D7D7];
        bottomView.frame = CGRectMake(0, CGRectGetMaxY(_titleView.frame), ScreenWidth, 1);
        [self.view addSubview:bottomView];
    }
    return _titleView;
}
-(NSMutableArray *)titles{
    if (!_titles) {
        NSArray* titles = @[@"通知",@"评论"];
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

- (UILabel *)noticeNumlabel {
    if (!_noticeNumlabel) {
        _noticeNumlabel = [UILabel sc_labelWithText:@"0" fontSize:13 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
        _noticeNumlabel.backgroundColor = UIColorHexString(0xEE5454);
        _noticeNumlabel.layer.masksToBounds = YES;
        _noticeNumlabel.layer.cornerRadius = 15/2.;
    }
    return _noticeNumlabel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
