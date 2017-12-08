//
//  PVConsumptionViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVConsumptionViewController.h"
#import "PVConsumptionRecordController.h"
#import "PVRechargeRecordController.h"
#import "PVBaseScrollView.h"

@interface PVConsumptionViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong)UIView       *titleView;
@property(nonatomic, strong)UIButton     *selectedBtn;
@property(nonatomic, strong)UIView       *selectedView;
@property(nonatomic, strong)PVBaseScrollView *contentView;

@end

@implementation PVConsumptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
}

-(void) initView{
    self.scNavigationItem.titleView = self.titleView;
    [self.view insertSubview:self.contentView belowSubview:self.scNavigationBar];
    [self creatContentView];
}

/** 创建contentView上面的子view */
-(void)creatContentView{
    ///充值记录
    PVRechargeRecordController *interractionVC = [[PVRechargeRecordController alloc] init];
    [self addChildViewController:interractionVC];
    ///消费记录
    PVConsumptionRecordController *televisonVC = [[PVConsumptionRecordController alloc] init];
    [self addChildViewController:televisonVC];
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count*YYScreenWidth, 0);
    [self scrollViewDidEndDecelerating:self.contentView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self setContentChildView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setContentChildView];
}

-(void)setContentChildView{
    NSInteger index = (int) (self.contentView.contentOffset.x / YYScreenWidth);
    UIViewController* vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index*YYScreenWidth, 0, YYScreenWidth, self.contentView.sc_height);
    [self.contentView addSubview:vc.view];
    [self selectedPageBtn:self.titleView.subviews[index]];
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]  init];
        _titleView.sc_width  = 160;
        _titleView.sc_height = kNavBarHeight - kOriginY;
        _titleView.backgroundColor = [UIColor clearColor];
        UIButton *consumptionBtn = [self createButtonWith:@"充值记录" frame:CGRectMake(0, 2, 70, 35)];
        [consumptionBtn addTarget:self action:@selector(ConsumptionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.selectedBtn = consumptionBtn;
        self.selectedBtn.selected = true;
        [_titleView addSubview:consumptionBtn];
        
        UIButton *rechargeBtn = [self createButtonWith:@"消费记录" frame:CGRectMake(CGRectGetMaxX(consumptionBtn.frame)+20, 2, 70, 35)];
        [rechargeBtn addTarget:self action:@selector(RechargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:rechargeBtn];
        
        self.selectedView.frame = CGRectMake(self.selectedBtn.sc_x, _titleView.sc_height - 2, self.selectedBtn.sc_width-10, 2);
        self.selectedView.center = CGPointMake(self.selectedBtn.center.x, self.selectedView.center.y);
        [_titleView addSubview:self.selectedView];
        
    }
    return _titleView;
}

-(UIButton*)createButtonWith:(NSString*)title frame:(CGRect)frame{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor sc_colorWithHex:0x000000] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor sc_colorWithHex:0x00B6E9] forState:UIControlStateSelected];
    btn.frame = frame;
    return btn;
}

-(void)ConsumptionBtnClicked:(UIButton*)button{
    [self selectedPageBtn:button];
    [self.contentView setContentOffset:CGPointMake(0, 0) animated:false];
    [self scrollViewDidEndDecelerating:self.contentView];
}

-(void)RechargeBtnClicked:(UIButton*)button{
    [self selectedPageBtn:button];
    [self.contentView setContentOffset:CGPointMake(YYScreenWidth, 0) animated:false];
    [self scrollViewDidEndDecelerating:self.contentView];
}
-(void)selectedPageBtn:(UIButton*)btn{
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
//        _selectedView.backgroundColor = [UIColor yellowColor];
        _selectedView.backgroundColor = [UIColor sc_colorWithHex:0x00B6E9];
    }
    return _selectedView;
}
-(PVBaseScrollView *)contentView{
    if (!_contentView) {
        if (!_contentView) {
            _contentView = [[PVBaseScrollView alloc] init];
            _contentView.showsHorizontalScrollIndicator = NO;
            _contentView.scrollsToTop = false;
            _contentView.backgroundColor = [UIColor whiteColor];
            _contentView.delegate = self;
            _contentView.pagingEnabled = YES;
            _contentView.bounces = NO;
            _contentView.frame = CGRectMake(0, 0, YYScreenWidth, YYScreenHeight);
            _contentView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        }
    }
    return _contentView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
