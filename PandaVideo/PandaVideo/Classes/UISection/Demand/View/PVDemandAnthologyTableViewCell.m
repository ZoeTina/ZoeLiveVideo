//
//  PVDemandAnthologyTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDemandAnthologyTableViewCell.h"
#import "PVAnthologyCollectionViewCell.h"
#import "PVAnthologyTextCollectionViewCell.h"
#import "PVAnthologyNumberAndTextCell.h"

static NSString* resuPVAnthologyCollectionViewCell = @"resuPVAnthologyCollectionViewCell";
static NSString* resuPVAnthologyTextCollectionViewCell = @"resuPVAnthologyTextCollectionViewCell";
static NSString* resuPVAnthologyNumberAndTextCell = @"resuPVAnthologyNumberAndTextCell";


@interface PVDemandAnthologyTableViewCell() <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong)NSMutableArray*   videoTempletDataSource;
@property(nonatomic, copy)PVDemandAnthologyTableViewCellCallBlock callBlock;

@end

@implementation PVDemandAnthologyTableViewCell


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


-(void)setPVDemandAnthologyTableViewCellCallBlock:(PVDemandAnthologyTableViewCellCallBlock)block{
    self.callBlock = block;
}

-(void)setAnthologyDataSource:(NSArray *)anthologyDataSource{
    if (anthologyDataSource.count == 0)return;
    [self.videoTempletDataSource removeAllObjects];
    [self.videoTempletDataSource addObjectsFromArray:anthologyDataSource];
    [self.videoTempletCollectView reloadData];
}


// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.videoTempletDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isScroll) {
        self.isScroll = false;
        for (PVDemandVideoAnthologyModel* model in self.videoTempletDataSource) {
            if (model.isPlaying) {
                NSInteger index = [self.videoTempletDataSource indexOfObject:model];
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
                [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
                break;
            }
        }
    }
    if (self.type == 1) {//数字
        PVAnthologyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVAnthologyCollectionViewCell forIndexPath:indexPath];
        cell.anthologyModel = self.videoTempletDataSource[indexPath.item];
        return cell;
    }else if (self.type == 2){
        PVAnthologyTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVAnthologyTextCollectionViewCell forIndexPath:indexPath];
        cell.anthologyModel = self.videoTempletDataSource[indexPath.item];
        return cell;
    }else if (self.type == 3){
        PVAnthologyNumberAndTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVAnthologyNumberAndTextCell forIndexPath:indexPath];
        cell.anthologyModel = self.videoTempletDataSource[indexPath.item];
        return cell;
    }
    return [[UICollectionViewCell alloc]  init];
}
//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat width = 60;
    CGFloat heigth = width;
    if (self.type == 2) {
        width = 150;
    }else if (self.type == 3){
        width = scanle(135);
        heigth = width*75/135+38;
    }
    return CGSizeMake(width,heigth);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(2,15,0,0);
}
//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.callBlock(indexPath.item);
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
        [_videoTempletCollectView registerClass:[PVAnthologyTextCollectionViewCell class] forCellWithReuseIdentifier:resuPVAnthologyTextCollectionViewCell];
        [_videoTempletCollectView  registerNib:[UINib nibWithNibName:@"PVAnthologyNumberAndTextCell" bundle:nil] forCellWithReuseIdentifier:resuPVAnthologyNumberAndTextCell];
    }
    return _videoTempletCollectView;
}
-(NSMutableArray *)videoTempletDataSource{
    if (!_videoTempletDataSource) {
        _videoTempletDataSource = [NSMutableArray array];
    }
    return _videoTempletDataSource;
}
- (void)setFrame:(CGRect)frame {
    frame.size.height -= 2;
    [super setFrame:frame];
}
@end
