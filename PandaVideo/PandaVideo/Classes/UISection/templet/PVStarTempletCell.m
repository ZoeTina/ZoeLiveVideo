//
//  PVStarTempletCell.m
//  PandaVideo
//
//  Created by cara on 17/7/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVStarTempletCell.h"
#import "PVStarCollectionCell.h"

static NSString* resuPVStarCollectionCell = @"resuPVStarCollectionCell";

@interface PVStarTempletCell() <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView* videoTempletCollectView;
@property(nonatomic, strong)NSMutableArray*   videoTempletDataSource;

@end

@implementation PVStarTempletCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self.contentView addSubview:self.videoTempletCollectView];
}
// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.videoTempletDataSource.count+10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PVStarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVStarCollectionCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat width = 60;
    CGFloat heigth = width + 30;
    return CGSizeMake(width,heigth);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,0,10,0);
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
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
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
        [_videoTempletCollectView  registerNib:[UINib nibWithNibName:@"PVStarCollectionCell" bundle:nil] forCellWithReuseIdentifier:resuPVStarCollectionCell];
    }
    return _videoTempletCollectView;
}
-(NSMutableArray *)videoTempletDataSource{
    if (!_videoTempletDataSource) {
        _videoTempletDataSource = [NSMutableArray array];
    }
    return _videoTempletDataSource;
}


@end
