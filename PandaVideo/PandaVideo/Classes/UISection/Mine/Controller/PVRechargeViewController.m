//
//  PVRechargeViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRechargeViewController.h"
#import "PVRechargeDetailViewController.h"

@interface PVRechargeViewController () <UIScrollViewDelegate>

@property(nonatomic, strong)UIView* titleView;
@property(nonatomic, strong)UIButton* selectedBtn;
@property(nonatomic, strong)UIView* selectedView;
@property(nonatomic, strong)UIScrollView* contentView;

@end

@implementation PVRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

-(void)setupUI{
    self.scNavigationItem.titleView = self.titleView;
    [self.view insertSubview:self.contentView belowSubview:self.scNavigationBar];
    [self creatContentView];
    
}

///创建contentView上面的子view
-(void)creatContentView{
    ///充值记录
    PVRechargeDetailViewController* rechargeVC = [[PVRechargeDetailViewController alloc]  init];
    rechargeVC.type = 1;
    [self addChildViewController:rechargeVC];

    ///消费记录
    PVRechargeDetailViewController* consumptionVC = [[PVRechargeDetailViewController alloc]  init];
    consumptionVC.type = 2;
    [self addChildViewController:consumptionVC];
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count*ScreenWidth, 0);
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
    UIViewController* vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index*ScreenWidth, 0, ScreenWidth, self.contentView.sc_height);
    [self.contentView addSubview:vc.view];
    [self selectedLiveBtn:self.titleView.subviews[index]];
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]  init];
        _titleView.sc_width  = 200;
        _titleView.sc_height = 40;
        _titleView.backgroundColor = [UIColor clearColor];
        UIButton* televisionBtn = [self creatBtn:@"充值记录" frame:CGRectMake(0, 2, 90, 35)];
        [televisionBtn addTarget:self action:@selector(televisionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.selectedBtn = televisionBtn;
        self.selectedBtn.selected = true;
        [_titleView addSubview:televisionBtn];
        
        UIButton* interractionBtn = [self creatBtn:@"消费记录" frame:CGRectMake(CGRectGetMaxX(televisionBtn.frame)+20, 2, 90, 35)];
        [interractionBtn addTarget:self action:@selector(interractionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:interractionBtn];
        
        self.selectedView.frame = CGRectMake(self.selectedBtn.sc_x, 39, self.selectedBtn.sc_width-40, 2);
        self.selectedView.center = CGPointMake(self.selectedBtn.center.x, self.selectedView.center.y);
        [_titleView addSubview:self.selectedView];
        
    }
    return _titleView;
}
-(UIButton*)creatBtn:(NSString*)title  frame:(CGRect)frame{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor sc_colorWithHex:0x000000] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor sc_colorWithHex:0x00B6E9] forState:UIControlStateSelected];
    btn.frame = frame;
    return btn;
}
-(void)televisionBtnClicked:(UIButton*)televisionBtn{
    [self selectedLiveBtn:televisionBtn];
    [self.contentView setContentOffset:CGPointMake(0, 0) animated:false];
    [self scrollViewDidEndDecelerating:self.contentView];
}
-(void)interractionBtnClicked:(UIButton*)interractionBtn{
    [self selectedLiveBtn:interractionBtn];
    [self.contentView setContentOffset:CGPointMake(ScreenWidth, 0) animated:false];
    [self scrollViewDidEndDecelerating:self.contentView];
}
-(void)selectedLiveBtn:(UIButton*)btn{
    if (self.selectedBtn == btn) return;
    self.selectedBtn.selected = false;
    self.selectedBtn = btn;
    self.selectedBtn.selected = true;
    [UIView animateWithDuration:0.25f animations:^{
        self.selectedView.center = CGPointMake(self.selectedBtn.center.x, self.selectedView.center.y);
    }];
}
-(UIView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[UIView alloc]  init];
        _selectedView.backgroundColor = [UIColor sc_colorWithHex:0x00B6E9];
    }
    return _selectedView;
}
-(UIScrollView *)contentView{
    if (!_contentView) {
        if (!_contentView) {
            _contentView = [[UIScrollView alloc] init];
            _contentView.showsHorizontalScrollIndicator = NO;
            _contentView.scrollsToTop = false;
            _contentView.backgroundColor = [UIColor whiteColor];
            _contentView.delegate = self;
            _contentView.pagingEnabled = YES;
            _contentView.bounces = NO;
            _contentView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            _contentView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        }
    }
    return _contentView;
}
@end
