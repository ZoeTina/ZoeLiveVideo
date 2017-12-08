//
//  PVVideoDemandAnthologyController.m
//  PandaVideo
//
//  Created by cara on 17/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoDemandAnthologyController.h"
#import "PVAnthologyCollectionViewCell.h"
#import "PVVideoTextCollectionViewCell.h"
#import "PVVideoAnthologyTextAndImageCell.h"

static NSString* resuPVAnthologyCollectionViewCell = @"resuPVAnthologyCollectionViewCell";
static NSString* resuPVVideoTextCollectionViewCell = @"resuPVVideoTextCollectionViewCell";
static NSString* resuPVVideoAnthologyTextAndImageCell = @"resuPVVideoAnthologyTextAndImageCell";

@interface PVVideoDemandAnthologyController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic, strong)UICollectionView* templetCollectView;
@property(nonatomic, copy)PVVideoDemandAnthologyControllerBlock callBlock;

@end

@implementation PVVideoDemandAnthologyController


- (void)viewDidLoad {
    [super viewDidLoad];    

    [self setupUI];
    
}
-(void)setupUI{
    [self.view addSubview:self.templetCollectView];
    [self.templetCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}


-(void)setPVVideoDemandAnthologyControllerBlock:(PVVideoDemandAnthologyControllerBlock)block{
    self.callBlock = block;
}

-(void)setAnthologyDataSource:(NSArray *)anthologyDataSource{
    if (anthologyDataSource == 0)return;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:anthologyDataSource];
    [self.templetCollectView reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
    [self.templetCollectView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:true];
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
        cell.isCross = true;
        cell.anthologyModel = self.dataSource[indexPath.item];
        return cell;
    }else if (self.type == 2){
        PVVideoTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVVideoTextCollectionViewCell forIndexPath:indexPath];
        cell.anthologyModel = self.dataSource[indexPath.item];
        return cell;
    }else if (self.type == 3){
        PVVideoAnthologyTextAndImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVVideoAnthologyTextAndImageCell forIndexPath:indexPath];
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
    CGFloat width = (self.view.sc_width-40)/5;
    CGFloat heigth = width;
    
    if (self.type == 3) {
        width = self.view.sc_width - 15;
        heigth = scanle(75);
    }else if (self.type == 2){
        width = self.view.sc_width - 15;
        heigth = scanle(70);
    }
    return CGSizeMake(width,heigth);
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

-(UICollectionView *)templetCollectView{
    if (!_templetCollectView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        layOut.minimumLineSpacing = 5.0;
        layOut.minimumInteritemSpacing = 5.0;
        _templetCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVAnthologyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVAnthologyCollectionViewCell];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVVideoTextCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVVideoTextCollectionViewCell];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVVideoAnthologyTextAndImageCell" bundle:nil] forCellWithReuseIdentifier:resuPVVideoAnthologyTextAndImageCell];
        //设置数据源和代理
        _templetCollectView.delegate = self;
        _templetCollectView.dataSource = self;
        _templetCollectView.showsVerticalScrollIndicator = false;
        _templetCollectView.showsVerticalScrollIndicator = false;
        _templetCollectView.backgroundColor = [UIColor blackColor];
    }
    return _templetCollectView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
