//
//  PVHomeTopContainerView.m
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHomeTopContainerView.h"
#import "PVDBManager.h"

@interface PVHomeTopContainerView()

@property(nonatomic, copy)SearchBarBlock searchBarBlock;
@property(nonatomic, copy)TimeBtnClickedBlock timeBtnBlock;
@property(nonatomic, copy)ShakeBtnClickedBlock shakeBtnBlock;
@property(nonatomic, copy)EditColumnBlock editColumnClickedBlock;
@property(nonatomic, copy)ContinueVideoTapGestureClicked  continueVideoTapGestureClicked;
@property(nonatomic, strong)UIView* searchbarContainerView;
@property(nonatomic, strong)UIButton* editButton;
@property(nonatomic, strong)UIView* bottomView;
@property(nonatomic, strong)UIImageView* logoImageView;
@property(nonatomic, strong)PVHistoryModel* historyModel;

@end

@implementation PVHomeTopContainerView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr delegate:(id<SCSegmentTitleViewDelegate>)delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUIWithTitles:titlesArr delegate:delegate];
    }
    return self;
}

-(void)setupUIWithTitles:(NSArray *)titles delegate:(id<SCSegmentTitleViewDelegate>)delegate{
    
    UIImageView* logoImageView = [[UIImageView alloc]  init];
    logoImageView.image = [UIImage imageNamed:@"熊猫视频"];
    logoImageView.contentMode = UIViewContentModeCenter;
    logoImageView.frame = CGRectMake(20, 27, 70, 36);
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    UIView* searchbarContainerView = [[UIView alloc]   init];
    searchbarContainerView.frame = CGRectMake(CGRectGetMaxX(logoImageView.frame)+15, 30, ScreenWidth-130, 30);
    [self addSubview:searchbarContainerView];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClicked)];
    [searchbarContainerView addGestureRecognizer:tapGesture];
    self.searchbarContainerView = searchbarContainerView;
    
    PVSearchBar *searchbar = [[PVSearchBar alloc]  init];
    searchbar.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    searchbar.layer.borderWidth = 1.0;
    searchbar.layer.cornerRadius = 15;
    searchbar.layer.borderColor = [UIColor whiteColor].CGColor;
    searchbar.placeholder = @"袁味时光";
    searchbar.leftImageView.image = [UIImage imageNamed:@"搜索栏"];
    searchbar.frame = searchbarContainerView.bounds;
    [searchbarContainerView addSubview:searchbar];
    self.searchBar = searchbar;
    
    CGFloat margin = 10;
    CGFloat width = (70 - margin*3)*0.5;
    
    UIButton* timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timeBtn.frame = CGRectMake(CGRectGetMaxX(searchbarContainerView.frame)+margin, 35, 20, 20);
    [timeBtn setImage:[UIImage imageNamed:@"home_btn_history"] forState:UIControlStateNormal];
    [timeBtn addTarget:self action:@selector(timeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:timeBtn];
    self.timeBtn = timeBtn;
    
    UIButton* shakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shakeBtn.frame = CGRectMake(CGRectGetMaxX(timeBtn.frame)+margin, 35, 20, 20);
    [shakeBtn setImage:[UIImage imageNamed:@"摇一摇"] forState:UIControlStateNormal];
    [shakeBtn addTarget:self action:@selector(shakeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shakeBtn];
    self.shakeBtn = shakeBtn;
    shakeBtn.hidden = true;
    
    CGFloat titleWidth = 0.0;
    
    for (NSString *title in titles) {
        CGFloat itemBtnWidth = [self getWidthWithString:title font:[UIFont systemFontOfSize:15]] + 20;
        titleWidth += itemBtnWidth;
    }
    
    titleWidth = ScreenWidth-50;
//    if (titleWidth > ScreenWidth) {
//        titleWidth = ScreenWidth-50;
//    }else{
//        titleWidth = ScreenWidth;
//    }
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(searchbarContainerView.frame)+6, titleWidth, 43);
    SCSegmentTitleView* view = [[SCSegmentTitleView alloc]  initWithFrame:frame titles:titles delegate:delegate indicatorType:SCIndicatorTypeEqualTitle];
    [view setTitleSelectFont: [UIFont fontWithName:FontBlod size:15]];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    self.titleView = view;
    
    UIButton* editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(CGRectGetMaxX(view.frame) , CGRectGetMaxY(searchbarContainerView.frame)+5, ScreenWidth - view.sc_width, view.sc_height);
    [editButton setImage:[UIImage imageNamed:@"编辑栏"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editColumn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editButton];
    self.editButton = editButton;
    
    UIView* bottomView = [[UIView alloc]  init];;
//    bottomView.frame = CGRectMake(0, self.sc_height-1, ScreenWidth, 1);
    bottomView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self addSubview:bottomView];
    self.bottomView = bottomView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.height.equalTo(@(1));
        make.top.equalTo(self.titleView.mas_bottom).offset(0);
    }];
    NSArray* historyModelArr = [[PVDBManager sharedInstance] selectVisitVideoAllData];
    if (historyModelArr.count) {
        UIView* continueVideoView = [[UIView alloc]  init];
        continueVideoView.backgroundColor = [UIColor whiteColor];
        continueVideoView.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame)+1, ScreenWidth, 40);
        [self addSubview:continueVideoView];
        self.continueVideoView = continueVideoView;
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer  alloc]  initWithTarget:self action:@selector(tapGestureContinueVideoViewClicked)];
        [self.continueVideoView addGestureRecognizer:tapGesture];
        
        
        PVHistoryModel* historyModel = historyModelArr.firstObject;
        self.historyModel = historyModel;
        UILabel* titleLabel = [[UILabel alloc]  init];
        titleLabel.textColor = [UIColor sc_colorWithHex:0x2AB4E4];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [continueVideoView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(20, 13, ScreenWidth-60, 14);
        titleLabel.text = [NSString stringWithFormat:@"上次观看到%@",historyModel.title];
        
        UIButton* titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [titleBtn setTitleColor:[UIColor sc_colorWithHex:0x2AB4E4] forState:UIControlStateNormal];
        [continueVideoView addSubview:titleBtn];
        titleBtn.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), 13, 30, 14);
        titleBtn.userInteractionEnabled = false;
        [titleBtn setTitle:@"续看" forState:UIControlStateNormal];
    }
}

-(void)tapGestureContinueVideoViewClicked{
    if (self.continueVideoTapGestureClicked) {
        self.continueVideoTapGestureClicked(self.historyModel);
    }
}

-(void)setModel:(PVHomModel *)model{
    _model = model;
    self.searchBar.placeholder = model.searchKey;
    self.type = model.topType.integerValue;
}


-(void)setIsHiddenTitleView:(BOOL)isHiddenTitleView{
    _isHiddenTitleView = isHiddenTitleView;
    self.titleView.hidden = self.editButton.hidden = isHiddenTitleView;
}

-(void)setType:(NSInteger)type{
    _type = type;
    CGFloat searchBarWidth = ScreenWidth-190; //默认是第一种方式
    if (type == 1) {
        searchBarWidth = ScreenWidth-140;
        self.timeBtn.hidden = false;
        [self.timeBtn setImage:[UIImage imageNamed:@"home_btn_history"] forState:UIControlStateNormal];
    }else if (type == 2) {
        searchBarWidth = ScreenWidth-140;
        self.timeBtn.hidden = false;
        [self.timeBtn setImage:[UIImage imageNamed:@"ic_action_filter"] forState:UIControlStateNormal];
    }else if (type == 3 || type == 0){
        searchBarWidth = ScreenWidth-105;
        self.timeBtn.hidden = true;
    }
    self.searchbarContainerView.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame)+15, 30, searchBarWidth-5, 30);
    self.searchBar.frame = self.searchbarContainerView.bounds;
    CGFloat margin = 10;
//    CGFloat width = (70 - margin*3)*0.5;
    self.timeBtn.frame = CGRectMake(CGRectGetMaxX(self.searchbarContainerView.frame)+margin, 35, 20, 20);
    [self layoutSubviews];
}

-(void)setSearchBarClickedBlock:(SearchBarBlock)block{
    self.searchBarBlock = block;
}
-(void)setTimeBtnClickedBlock:(TimeBtnClickedBlock)block{
    self.timeBtnBlock = block;
}
-(void)setShakeBtnClickedBlock:(ShakeBtnClickedBlock)block{
    self.shakeBtnBlock = block;
}
-(void)setEditBtnClickedBlock:(EditColumnBlock)block{
    self.editColumnClickedBlock = block;
}
-(void)setContinueVideoTapGestureClickedBlock:(ContinueVideoTapGestureClicked)block{
    self.continueVideoTapGestureClicked = block;
}
-(void)tapGestureClicked{
    if (self.searchBarBlock) {
        self.searchBarBlock();
    }
}
-(void)timeBtnClicked{
    if (self.timeBtnBlock) {
        self.timeBtnBlock();
    }
}
-(void)shakeBtnClicked{
    if (self.shakeBtnBlock) {
        self.shakeBtnBlock();
    }
}
-(void)editColumn{
    if (self.editColumnClickedBlock) {
        self.editColumnClickedBlock();
    }    
}
#pragma mark Private
/**
 计算字符串长度
 
 @param string string
 @param font font
 @return 字符串长度
 */
- (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}
@end
