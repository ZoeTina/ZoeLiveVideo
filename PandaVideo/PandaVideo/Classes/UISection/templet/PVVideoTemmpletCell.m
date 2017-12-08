//
//  PVVideoTemmpletCell.m
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoTemmpletCell.h"
//#import "BBAFlowLayout.h"

static NSString* resuPVVideoDetailTempletCell = @"resuPVVideoDetailTempletCell";

@interface PVVideoTemmpletCell() <TYCyclePagerViewDataSource,TYCyclePagerViewDelegate>

@property(nonatomic, copy)PVVideoTemmpletCellCallBlock callBlock;

@end

@implementation PVVideoTemmpletCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setPVVideoTemmpletCellCallBlock:(PVVideoTemmpletCellCallBlock)block{
    self.callBlock = block;
}

-(void)setVideoDataSource:(NSArray<PVVideoListModel *> *)videoDataSource{
    _videoDataSource = videoDataSource;
    if (videoDataSource.count == 0) return;
    [self.videoTempletDataSource removeAllObjects];
    [self.videoTempletDataSource addObjectsFromArray:videoDataSource];
    [self.pagerView.collectionView setContentOffset:CGPointMake(0, 0) animated:false];
    [self.pagerView reloadData];
}

-(void)setupUI{
    [self addPagerView];
}

- (void)addPagerView {
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
    pagerView.isInfiniteLoop = YES;
    pagerView.backgroundColor = [UIColor whiteColor];
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [pagerView registerNib:[UINib nibWithNibName:@"PVVideoDetailTempletCell" bundle:nil] forCellWithReuseIdentifier:resuPVVideoDetailTempletCell];
    [self addSubview:pagerView];
    _pagerView = pagerView;
    [pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
}
#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.videoTempletDataSource.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    
    PVVideoDetailTempletCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:resuPVVideoDetailTempletCell forIndex:index];
    
    if (pagerView.curIndex == index) {
        cell.videoTitleLabel.hidden = cell.videoSubTitleLabel.hidden = cell.leftTopImageView.hidden = cell.rightTopLabel.hidden = cell.rightBottomView.hidden = false;
        cell.rightTopLabelTopConstaint.constant = 5;
    } else {
        cell.rightTopLabelTopConstaint.constant = 0;
        cell.videoTitleLabel.hidden = cell.videoSubTitleLabel.hidden = cell.leftTopImageView.hidden = cell.rightTopLabel.hidden = cell.rightBottomView.hidden = true;
    }
    cell.videoListModel = self.videoTempletDataSource[index];
    
    return cell;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (self.callBlock) {
        self.callBlock(self.videoTempletDataSource[index]);
    }
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
    if (self.videoTempletDataSource.count == 1) {
        layout.itemSize = CGSizeMake(ScreenWidth-20, (ScreenWidth-20) * 9 / 16);
        layout.layoutType  = TYCyclePagerTransformLayoutNormal;
    }else{
        layout.itemSize = CGSizeMake((ScreenWidth-20)/3, (ScreenWidth-20) * 4 / 3/3+60);
        layout.maximumAngle = 0.7;
        layout.layoutType  = TYCyclePagerTransformLayoutLinear;
    }
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSpacing = 0.0;
    layout.itemVerticalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    for (PVVideoDetailTempletCell *cell in pageView.visibleCells) {
        cell.rightTopLabelTopConstaint.constant = 0;
        cell.videoTitleLabel.hidden = cell.videoSubTitleLabel.hidden  = cell.leftTopImageView.hidden = cell.rightTopLabel.hidden = cell.rightBottomView.hidden  = true;
    }
    PVVideoDetailTempletCell *cell = pageView.curIndexCell;
    cell.rightTopLabelTopConstaint.constant = 5;
    cell.videoTitleLabel.hidden = cell.videoSubTitleLabel.hidden = false;
    PVVideoListModel* videoListModel = self.videoTempletDataSource[pageView.curIndex];
    if (videoListModel.info.expand.topLeftCornerModel.tagImage.length) {
        cell.leftTopImageView.hidden = false;
    }else{
        cell.leftTopImageView.hidden = true;
    }
    if (videoListModel.info.expand.topRightCornerModel.tagName.length) {
        cell.rightTopLabel.hidden = false;
    }else{
        cell.rightTopLabel.hidden = true;
    }
    if (videoListModel.info.expand.bottomRightCornerModel.tagName.length) {
        cell.rightBottomView.hidden = false;
    }else{
        cell.rightBottomView.hidden = true;
    }
}

/*
// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.videoTempletDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PVVideoDetailTempletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVVideoDetailTempletCell forIndexPath:indexPath];
    
    cell.videoListModel = self.videoTempletDataSource[indexPath.item];
    
    return cell;
}
//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat margin = 30;
    CGFloat width = 120;
    CGFloat heigth = width*4/3 + margin;
    return CGSizeMake(width,heigth);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20,0,10,0);
}
//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}
-(UICollectionView *)videoTempletCollectView{
    if (!_videoTempletCollectView) {
        BBAFlowLayout *layOut = [[BBAFlowLayout alloc] init];
//        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layOut.minimumLineSpacing = 10;
        layOut.minimumInteritemSpacing = 10;
        CGRect frame = CGRectMake(0, 0, self.sc_width, self.sc_height);
        _videoTempletCollectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layOut];
        //设置数据源和代理
        _videoTempletCollectView.delegate = self;
        _videoTempletCollectView.dataSource = self;
        _videoTempletCollectView.backgroundColor = [UIColor whiteColor];
        _videoTempletCollectView.showsHorizontalScrollIndicator = false;
        [_videoTempletCollectView  registerNib:[UINib nibWithNibName:@"PVVideoDetailTempletCell" bundle:nil] forCellWithReuseIdentifier:resuPVVideoDetailTempletCell];
    }
    return _videoTempletCollectView;
}
 */
-(NSMutableArray *)videoTempletDataSource{
    if (!_videoTempletDataSource) {
        _videoTempletDataSource = [NSMutableArray array];
    }
    return _videoTempletDataSource;
}
@end
