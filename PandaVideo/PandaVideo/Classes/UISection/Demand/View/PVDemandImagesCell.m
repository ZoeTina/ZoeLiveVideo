//
//  PVDemandImagesCell.m
//  PandaVideo
//
//  Created by cara on 2017/10/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDemandImagesCell.h"
#import "BHInfiniteScrollView.h"


@interface PVDemandImagesCell() <BHInfiniteScrollViewDelegate>

@property (nonatomic, strong) BHInfiniteScrollView* infinitePageView;
@property (nonatomic, copy)PVDemandImagesCellCallBlock callBlock;


@end

@implementation PVDemandImagesCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupUI];
    }
    
    return self;
}

-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)setPVDemandImagesCellCallBlock:(PVDemandImagesCellCallBlock)block{
    self.callBlock = block;
}

-(void)setUrlsArray:(NSArray *)urlsArray{
    
    [self.infinitePageView removeFromSuperview];
    self.infinitePageView = nil;
    
    BHInfiniteScrollView* infinitePageView = [BHInfiniteScrollView
                                               infiniteScrollViewWithFrame:CGRectMake(15, 13, ScreenWidth-30, (CrossScreenWidth-30)*70/350) Delegate:self ImagesArray:urlsArray];
    infinitePageView.pageControl.dotSize = 10;
    infinitePageView.pageControlAlignmentOffset = CGSizeMake(10,0);
    infinitePageView.scrollTimeInterval = 5;
    infinitePageView.autoScrollToNextPage = false;
    infinitePageView.scrollDirection = BHInfiniteScrollViewScrollDirectionVertical;
    infinitePageView.pageControlAlignmentH = BHInfiniteScrollViewPageControlAlignHorizontalRight;
    infinitePageView.pageControlAlignmentV = BHInfiniteScrollViewPageControlAlignVerticalButtom;
    infinitePageView.reverseDirection = NO;
    [self addSubview:infinitePageView];
    self.infinitePageView = infinitePageView;
    
    UIView* bottomView = [[UIView alloc]  init];
    bottomView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(1));
    }];
}

- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger)index {
  //  NSLog(@"did scroll to index %ld", index);
}
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.callBlock) {
        self.callBlock(index);
    }
}

@end
