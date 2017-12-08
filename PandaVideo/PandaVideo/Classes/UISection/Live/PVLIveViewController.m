//
//  PVLIveViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLIveViewController.h"
#import "PVTelevisionViewController.h"
#import "PVChoiceColumnController.h"
#import "PVLiveScrollView.h"

@interface PVLIveViewController () <UIScrollViewDelegate>

@property(nonatomic, strong)UIView* titleView;
@property(nonatomic, strong)UIButton* selectedBtn;
@property(nonatomic, strong)UIView* selectedView;
@property(nonatomic, strong)PVLiveScrollView* contentView;
@property(nonatomic, strong)PVTelevisionViewController* televisonVC;
@property(nonatomic, strong)PVChoiceColumnController* interractionVC;
@property(nonatomic, strong)UIButton* televisionBtn;

@end

@implementation PVLIveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}
-(void)reLoadVCData{
    [self loadData];
}

-(void)setupUI{
    self.reminderBtn.frame = CGRectMake(0, (ScreenHeight-20)*0.5, ScreenWidth, 20);
    self.scNavigationItem.titleView = self.titleView;
    [self.view insertSubview:self.contentView belowSubview:self.scNavigationBar];
    [self creatContentView];
}

-(void)loadData{
    if (self.menuModel.tvLiveUrl.length) {
        self.televisonVC.jumpType = self.menuModel.jumpType;
        self.televisonVC.jumpUrl = self.menuModel.jumpUrl;
        self.televisonVC.url = self.menuModel.tvLiveUrl;
    }
    if (self.menuModel.interactiveLiveUrl.length) {
        self.interractionVC.url = self.menuModel.interactiveLiveUrl;
    }
}

///创建contentView上面的子view
-(void)creatContentView{
    ///电视直播
    PVTelevisionViewController* televisonVC = [[PVTelevisionViewController alloc]  init];
    [self addChildViewController:televisonVC];
    self.televisonVC = televisonVC;
    ///互动直播
    PVChoiceColumnController* interractionVC = [[PVChoiceColumnController alloc]  init];
    [self addChildViewController:interractionVC];
    self.interractionVC = interractionVC;
    interractionVC.navType = 2;
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
    NSInteger index = (int) ((self.contentView.contentOffset.x / ScreenWidth)+0.5);
    UIViewController* vc = self.childViewControllers[index];
    if (index == 0 && [self.contentView.subviews containsObject:vc.view]) {
        self.televisonVC.typePage = 0;
    }else if (index == 1){
        self.televisonVC.typePage = 1;
    }
    vc.view.frame = CGRectMake(index*ScreenWidth, 0, ScreenWidth, self.contentView.sc_height);
    [self.contentView addSubview:vc.view];
    [self selectedLiveBtn:self.titleView.subviews[index]];
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]  init];
        _titleView.sc_width  = 160;
        _titleView.sc_height = 40;
        _titleView.backgroundColor = [UIColor clearColor];
        UIButton* televisionBtn = [self creatBtn:@"电视直播" frame:CGRectMake(0, 2, 70, 35)];
        [televisionBtn addTarget:self action:@selector(televisionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.televisionBtn = televisionBtn;
        self.selectedBtn = televisionBtn;
        self.selectedBtn.selected = true;
        self.selectedBtn.titleLabel.font = [UIFont fontWithName:FontBlod size:15];
        [_titleView addSubview:televisionBtn];
        
        UIButton* interractionBtn = [self creatBtn:@"互动直播" frame:CGRectMake(CGRectGetMaxX(televisionBtn.frame)+20, 2, 70, 35)];
        [interractionBtn addTarget:self action:@selector(interractionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:interractionBtn];
        
        CGSize size = [UILabel messageBodyText:@"电视直播" andSyFontofSize:15 andLabelwith:70 andLabelheight:35];
        self.selectedView.frame = CGRectMake(self.selectedBtn.sc_x, 40, size.width, 2);
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
-(void)scrollTelevision{
    [self televisionBtnClicked:self.televisionBtn];
}

-(void)interractionBtnClicked:(UIButton*)interractionBtn{
    [self selectedLiveBtn:interractionBtn];
    [self.contentView setContentOffset:CGPointMake(ScreenWidth, 0) animated:false];
    [self scrollViewDidEndDecelerating:self.contentView];
}
-(void)selectedLiveBtn:(UIButton*)btn{
    if (self.selectedBtn == btn) return;
    self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.selectedBtn.selected = false;
    self.selectedBtn = btn;
    self.selectedBtn.titleLabel.font = [UIFont fontWithName:FontBlod size:15];
    self.selectedBtn.selected = true;
    self.selectedView.sc_width = self.selectedBtn.titleLabel.sc_width;
    self.selectedView.center = CGPointMake(self.selectedBtn.center.x, self.selectedView.center.y);
}
-(UIView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[UIView alloc]  init];
        _selectedView.backgroundColor = [UIColor sc_colorWithHex:0x00B6E9];
    }
    return _selectedView;
}
-(PVLiveScrollView *)contentView{
    if (!_contentView) {
        if (!_contentView) {
            _contentView = [[PVLiveScrollView alloc] init];
            _contentView.showsHorizontalScrollIndicator = NO;
            _contentView.scrollsToTop = false;
            _contentView.backgroundColor = [UIColor whiteColor];
            _contentView.delegate = self;
            _contentView.pagingEnabled = YES;
            _contentView.bounces = NO;
            _contentView.alwaysBounceVertical = false;
            _contentView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
            UIEdgeInsets edges = UIEdgeInsetsMake(0, 0, 49, 0);
            _contentView.contentInset = edges;
        }
    }
    return _contentView;
}

@end
