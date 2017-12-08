//
//  PVAdScrollView.m
//  PandaVideo
//
//  Created by cara on 2017/10/19.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVAdScrollView.h"


@interface PVAdScrollView() <UIScrollViewDelegate>


@property(nonatomic, strong)UIScrollView* scrollView;


@end

@implementation PVAdScrollView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.kAutoScrollInterval = 5.0f;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


-(void)startAutoScroll{
    if (self.scrollTimer != nil || [self.delegate numbersOfAdScrollViewItems] == 0) {
        return;
    }
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.kAutoScrollInterval target:self selector:@selector(doAutoScroll) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
}

-(void)doAutoScroll{
    CGFloat offSet = self.scrollView.contentOffset.y + self.sc_height;
    if (offSet > [self.delegate numbersOfAdScrollViewItems]*self.sc_height) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:false];
        return;
    }
    [self.scrollView setContentOffset:CGPointMake(0, offSet) animated:true];
}
-(void)reloadData{
    
    if (self.delegate == nil) return;
    NSInteger totalNum = [self.delegate numbersOfAdScrollViewItems];
    if (totalNum == 0) return;
    for (UIView* subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    NSInteger  numOfInfos = totalNum >= 2 ? totalNum + 2 : totalNum;
    
    for (int i=0; i<numOfInfos; i++) {
        ActivityInfoView* infoView = [[ActivityInfoView alloc]  init];
        infoView.frame = CGRectMake(1, self.sc_height*i, self.sc_width, self.sc_height);
        [infoView addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];        
        NSString*  title = @"";
        NSString*  icon = @"";
        if(i == 0){
            title = [self.delegate adScrollViewIitleForIndex:totalNum - 1];
            icon = [self.delegate adScrollViewIconForIndex:totalNum - 1];
            infoView.tag = totalNum-1;
        }else if (i > numOfInfos-1){
            title = [self.delegate adScrollViewIitleForIndex:0];
            icon = [self.delegate adScrollViewIconForIndex:0];
            infoView.tag = 0;
        }else{
            title = [self.delegate adScrollViewIitleForIndex:i-1];
            icon = [self.delegate adScrollViewIconForIndex:i-1];
            infoView.tag = i-1;
        }
        infoView.textLabel.text = title;
        if (icon.length) {
            [infoView.icon sc_setImageWithUrlString:icon placeholderImage:nil isAvatar:false];
        }else{
            infoView.icon.image = [UIImage imageNamed:@""];
        }
        [self.scrollView addSubview:infoView];
    }
    
    if (totalNum >= 2) {
        self.scrollView.contentSize =  CGSizeMake(0, (totalNum + 2) * self.sc_height);
        self.scrollView.contentOffset = CGPointMake( self.scrollView.contentOffset.x, self.sc_height);
    }else{
        self.scrollView.contentSize =  CGSizeMake(0, totalNum * self.sc_height);
        self.scrollView.contentOffset = CGPointMake( self.scrollView.contentOffset.x, 0);
    }
    
    if (totalNum > 1) {
        [self startAutoScroll];
    }
    
}
-(void)onClicked:(ActivityInfoView*)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(adScrollViewOnAdClicked:)]){
        [self.delegate adScrollViewOnAdClicked:sender.tag];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >= [self.delegate numbersOfAdScrollViewItems]*self.sc_height) {
        [scrollView setContentOffset:CGPointMake(0, 0) animated:false];
    }
}

-(void)setDelegate:(id<AdScrollViewDelegate>)delegate{
    _delegate = delegate;
    [self reloadData];
}


-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]  init];
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.alwaysBounceVertical = false;
        _scrollView.alwaysBounceHorizontal = false;
        _scrollView.pagingEnabled = true;
        _scrollView.scrollEnabled = false;
        _scrollView.delegate = self;
        
    }
    return _scrollView;
}


@end



@interface ActivityInfoView()



@end


@implementation ActivityInfoView


-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    
    self.icon = [[UIImageView alloc]  init];
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self).offset(5);
        make.width.height.equalTo(@20);
    }];
    
    self.textLabel = [[UILabel alloc]  init];
    self.textLabel.font = [UIFont systemFontOfSize:13];
    self.textLabel.textColor = [UIColor sc_colorWithHex:0x000000];
    [self addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(11.0);
        make.height.equalTo(self);
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self).offset(5);

    }];
    
    
}
@end

