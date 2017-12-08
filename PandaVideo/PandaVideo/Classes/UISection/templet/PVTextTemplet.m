//
//  PVTextTemplet.m
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTextTemplet.h"
#import "PVAdScrollView.h"

@interface PVTextTemplet() <AdScrollViewDelegate>

@property(nonatomic, strong)PVAdScrollView* adScrollView;
@property(nonatomic, copy)PVTextTempletCallBlock callBlock;

@end

@implementation PVTextTemplet


-(instancetype)initWithScrollTexts:(NSMutableArray *)scrollTexts{
    self = [super init];
    [self.scrollTexts removeAllObjects];
    [self.scrollTexts addObjectsFromArray:scrollTexts];
    if(self){
        [self setupUI];
    }
    return self;
}

-(void)setPVTextTempletCallBlock:(PVTextTempletCallBlock)block{
    self.callBlock = block;
}

-(void)setupUI{
    UIView* topView = [[UIView alloc]  init];
    topView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    topView.frame = CGRectMake(0, 0, ScreenWidth, 3);
    [self addSubview:topView];
    self.adScrollView = [[PVAdScrollView alloc]  initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 40)];
    [self addSubview:self.adScrollView];
    self.adScrollView.delegate = self;
    
}
-(NSMutableArray *)scrollTexts{
    if (!_scrollTexts) {
        _scrollTexts = [NSMutableArray array];
    }
    return _scrollTexts;
}

-(NSInteger)numbersOfAdScrollViewItems{
    return self.scrollTexts.count;
}
-(NSString *)adScrollViewIitleForIndex:(NSInteger)index{
    if (index >= self.scrollTexts.count) {
        return @"";
    }
    PVBannerModel* model = self.scrollTexts[index];
    return model.bannerTxt;
}
-(NSString *)adScrollViewIconForIndex:(NSInteger)index{
    if (index >= self.scrollTexts.count) {
        return @"";
    }
    PVBannerModel* model = self.scrollTexts[index];
    return model.bannerImage;
}
-(void)adScrollViewOnAdClicked:(NSInteger)index{
    if (self.callBlock) {
        self.callBlock(self.scrollTexts[index]);
    }
}

@end
