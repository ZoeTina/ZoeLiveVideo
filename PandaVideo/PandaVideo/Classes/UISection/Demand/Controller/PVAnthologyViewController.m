//
//  PVAnthologyViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVAnthologyViewController.h"
#import "PVAnthologyCollectionViewCell.h"
#import "PVAnthologyTextCell.h"
#import "PVAnthologyNumberAndTextCell.h"
#import "PVAnthologyTextAndImageCell.h"

static NSString* resuPVAnthologyCollectionViewCell = @"resuPVAnthologyCollectionViewCell";
static NSString* resuPVAnthologyTextCell = @"resuPVAnthologyTextCell";
static NSString* resuPVAnthologyTextAndImageCell = @"resuPVAnthologyTextAndImageCell";

@interface PVAnthologyViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;

@property (nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic, copy)PVAnthologyViewControllerCallBlock callBlock;

@end

@implementation PVAnthologyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoTitleLabel.font = [UIFont fontWithName:FontBlod size:15]; 
    [self registerVideoCollectionViewCell];
    
}


-(void)setPVAnthologyViewControllerCallBlock:(PVAnthologyViewControllerCallBlock)block{
    self.callBlock = block;
}

-(void)setAnthologyDatasource:(NSArray *)anthologyDatasource{
    if (anthologyDatasource.count == 0)return;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:anthologyDatasource];
    [self.videoCollectionView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    [self.videoCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:true];
}

-(void)registerVideoCollectionViewCell{
    
    [self.videoCollectionView  registerNib:[UINib nibWithNibName:@"PVAnthologyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVAnthologyCollectionViewCell];
    [self.videoCollectionView registerClass:[PVAnthologyTextCell class] forCellWithReuseIdentifier:resuPVAnthologyTextCell];
    [self.videoCollectionView  registerNib:[UINib nibWithNibName:@"PVAnthologyTextAndImageCell" bundle:nil] forCellWithReuseIdentifier:resuPVAnthologyTextAndImageCell];
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        PVAnthologyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVAnthologyCollectionViewCell forIndexPath:indexPath];
        cell.anthologyModel = self.dataSource[indexPath.item];
        return cell;
    }else if (self.type == 2){
        PVAnthologyTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVAnthologyTextCell forIndexPath:indexPath];
        cell.anthologyModel = self.dataSource[indexPath.item];
        return cell;
    }else if (self.type == 3){
        PVAnthologyTextAndImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVAnthologyTextAndImageCell forIndexPath:indexPath];
        cell.anthologyModel = self.dataSource[indexPath.item];
        return cell;
    }
    return [[UICollectionViewCell alloc]  init];
}
//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat width = (CrossScreenWidth-40)/6;
    CGFloat heigth = width;
    
    if (self.type == 3) {
        width = CrossScreenWidth - 15;
        heigth = scanle(84)+15;
    }else if (self.type == 2){
        width = CrossScreenWidth - 15;
        heigth = scanle(44);
    }
    return CGSizeMake((int)width,(int)heigth);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,10,10,10);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (PVDemandVideoAnthologyModel* anthologyModel in self.dataSource) {
        if (anthologyModel.isPlaying) {
            anthologyModel.isPlaying = false;
            break;
        }
    }
    PVDemandVideoAnthologyModel* anthologyModel = self.dataSource[indexPath.item];
    anthologyModel.isPlaying = true;
    [collectionView reloadData];
    
    if (self.callBlock) {
        self.callBlock(indexPath.item);
    }
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (IBAction)backBtnClicked {
    [UIView animateWithDuration:0.25f animations:^{
        self.view.sc_y = ScreenHeight;
    } completion:^(BOOL finished) {
        self.view.hidden = true;
    }];
}
@end
