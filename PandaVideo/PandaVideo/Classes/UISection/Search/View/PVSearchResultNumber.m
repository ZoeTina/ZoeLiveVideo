//
//  PVSearchResultNumber.m
//  PandaVideo
//
//  Created by cara on 17/8/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSearchResultNumber.h"
#import "PVAnthologyCollectionViewCell.h"

static NSString* resuPVAnthologyCollectionViewCell = @"resuPVAnthologyCollectionViewCell";

@interface PVSearchResultNumber() <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView* videoTempletCollectView;
@property(nonatomic, strong)NSMutableArray*   videoTempletDataSource;
@property(nonatomic, copy)PVSearchResultNumberBlock resultBlock;

@end

@implementation PVSearchResultNumber


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    [self.contentView addSubview:self.videoTempletCollectView];
    [self.videoTempletCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-2);
    }];
}
-(void)setPVSearchResultNumberBlock:(PVSearchResultNumberBlock)block{
    self.resultBlock = block;
}


-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    if (dataSource.count) {
        [self.videoTempletDataSource removeAllObjects];
        [self.videoTempletDataSource addObjectsFromArray:dataSource];
        [self.videoTempletCollectView reloadData];
    }
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.videoTempletDataSource.count >= 5 ? 6 : (self.videoTempletDataSource.count+1);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PVAnthologyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVAnthologyCollectionViewCell forIndexPath:indexPath];
    if (indexPath.item < self.videoTempletDataSource.count) {
        cell.episodeListModel = self.videoTempletDataSource[indexPath.item];
    }else{
        cell.trailerBtn.hidden = true;
        [cell.countAnthology setTitle:@"更多" forState:UIControlStateNormal];
    }
    
    
    return cell;
}
//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat leftAndRight = 30;
    CGFloat margin = 5;
    CGFloat width = (ScreenWidth-leftAndRight-margin*5)/6;
    CGFloat heigth = width;
    return CGSizeMake(width,heigth);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,15,10,15);
}
//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.resultBlock) {
        if (indexPath.item < self.videoTempletDataSource.count) {
            self.resultBlock(indexPath.item);
        }else{
            self.resultBlock(5);
        }
    }
}
-(UICollectionView *)videoTempletCollectView{
    if (!_videoTempletCollectView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 5;
        _videoTempletCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
        //设置数据源和代理
        _videoTempletCollectView.delegate = self;
        _videoTempletCollectView.dataSource = self;
        _videoTempletCollectView.backgroundColor = [UIColor whiteColor];
        _videoTempletCollectView.showsHorizontalScrollIndicator = false;
        [_videoTempletCollectView  registerNib:[UINib nibWithNibName:@"PVAnthologyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVAnthologyCollectionViewCell];
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
