//
//  PVColumnEditViewController.m
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVColumnEditViewController.h"
#import "PVColumnEditCell.h"
#import "PVHomModel.h"
#import "PVDBManager.h"
#import "AppDelegate+UserGuide.h"
static NSString* const resuPVColumnEditCell = @"resuPVColumnEditCell";

@interface PVColumnEditViewController () <UICollectionViewDataSource,UICollectionViewDelegate,PVColumnEditCellDelegate>

@property(nonatomic, strong)UICollectionView* columnCollectView;
@property(nonatomic, strong)NSMutableArray<PVHomModel*>* columnDataSource;
@property (nonatomic, strong) NSMutableArray *cellAttributesArray;
@property (nonatomic, assign) CGPoint lastPressPoint;

@end

@implementation PVColumnEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    if(![kUserDefaults boolForKey:@"guide_img_guide4"]){
        [kUserDefaults setBool:YES forKey:@"guide_img_guide4"];
        [kUserDefaults synchronize];
        AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate createUserGuide:3 withFrame:CGRectZero];
    }
}

-(void)dealloc{
    //把数组存入本地
    self.columnEditViewControllerBlock(self.columnDataSource, -1);
//    BOOL resultFlag = [[PVDBManager sharedInstance] deleteAllPVHomModelData];
//    if (resultFlag) {
//        for (PVHomModel* homeModel in self.columnDataSource) {
//            [[PVDBManager sharedInstance] insertPVHomModel:homeModel];
//        }
//    }
}


-(void)setupNavigationBar{
    self.scNavigationItem.title = @"栏目编辑";
}

-(void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.columnCollectView belowSubview:self.scNavigationBar];
    _lastPressPoint = CGPointZero;
    for (int i = 0; i < self.dataSource.count; i++) {
        PVHomModel* homeModel = self.dataSource[i];
//        homeModel.imgStr = @"搜索";
//        if (i < 4) {
//            homeModel.isSelect = true;
//        }else{
//            homeModel.isSelect = false;
//        }
        homeModel.indexRowStr = [NSString stringWithFormat:@"%d",i];
        [self.columnDataSource addObject:homeModel];
    }
}

/// MARK:- ===== UICollectionViewDataSource,UICollectionViewDelegate =====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.columnDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PVColumnEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVColumnEditCell forIndexPath:indexPath];

    cell.model = self.columnDataSource[indexPath.item];
    
    cell.delegate = self;
    
    return cell;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat width = (ScreenWidth-20-IPHONE6WH(40))/3;
    return CGSizeMake(width,width);
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
    
}


-(UICollectionView *)columnCollectView{
    if (!_columnCollectView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        layOut.minimumLineSpacing = 20;
        layOut.minimumInteritemSpacing = 0;
        _columnCollectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layOut];
        //设置数据源和代理
        _columnCollectView.delegate = self;
        _columnCollectView.dataSource = self;
        _columnCollectView.backgroundColor = [UIColor whiteColor];
        [_columnCollectView registerClass:[PVColumnEditCell class] forCellWithReuseIdentifier:resuPVColumnEditCell];
        _columnCollectView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    return _columnCollectView;
}
-(NSMutableArray<PVHomModel*> *)columnDataSource{
    if (!_columnDataSource) {
        _columnDataSource = [NSMutableArray array];
    }
    return _columnDataSource;
}
- (NSMutableArray *)cellAttributesArray{
    if (!_cellAttributesArray) {
        _cellAttributesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellAttributesArray;
}

/// MARK :- ============PVColumnEditCellDelegate===============

-(void)pressCellWithRecognizer:(PVColumnEditCell *)editCell{
    
    NSIndexPath* indexPath = [self.columnCollectView indexPathForCell:editCell];
    NSLog(@"-------%ld",indexPath.item);
}

-(void)moveCellWithRecognizer:(PVColumnEditCell *)editCell sender:(UILongPressGestureRecognizer *)sender{
    PVColumnEditCell *cell = editCell;
    NSIndexPath *cellIndexPath = [self.columnCollectView indexPathForCell:cell];
    
    BOOL isChanged = NO;
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        [cell.backView removeFromSuperview];
        
        cell.backView.center = cell.center;
        [self.columnCollectView addSubview:cell.backView];
        [self.columnCollectView bringSubviewToFront:cell.backView];
        [self.cellAttributesArray removeAllObjects];
        for (int i = 0;i< self.columnDataSource.count; i++) {
            [self.cellAttributesArray addObject:[self.columnCollectView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
        }
        self.lastPressPoint = [sender locationInView:self.columnCollectView];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        
        PVHomModel *cellModel = self.columnDataSource[cellIndexPath.row];
        
        if (cellModel.isSelect) {
            
            /* for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
             if (CGRectContainsPoint(attributes.frame, cell.backView.center) && cellIndexPath != attributes.indexPath) {
             
             isChanged = YES;
             
             
             ImgModel *ttempModel1 = self.imagesArray[cellIndexPath.row];
             [self.imagesArray removeObjectAtIndex:cellIndexPath.row];
             [self.imagesArray insertObject:ttempModel1 atIndex:attributes.indexPath.row];
             [self.mineCollection moveItemAtIndexPath:cellIndexPath toIndexPath:attributes.indexPath];
             }
             
             }*/
            
        }else{
            
            cell.backView.center = [sender locationInView:self.columnCollectView];
            
            for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
                if (CGRectContainsPoint(attributes.frame, cell.backView.center) && cellIndexPath != attributes.indexPath) {
                    
                    PVHomModel *imageModel = self.columnDataSource[attributes.indexPath.row];
                    if (imageModel.isSelect) {
                        return;
                    }
                    isChanged = YES;
                    BOOL isAdd = attributes.indexPath.row < cellIndexPath.row;
                    if (isAdd) {
                        
                        for (NSInteger j=(cellIndexPath.row-1); j >=attributes.indexPath.row ; j--) {
                            
                            PVHomModel *tempModel = self.columnDataSource[j];
                            if (!tempModel.isSelect) {
                                
                                NSInteger tempJ = j;
                                while (1) {
                                    tempJ++;
                                    if (!self.columnDataSource[tempJ].isSelect || tempJ == cellIndexPath.row) {
                                        break;
                                    }
                                }
                                
                                if (tempJ != j) {
                                    PVHomModel *ttempModel1 = self.columnDataSource[j];
                                    [self.columnDataSource removeObjectAtIndex:j];
                                    [self.columnDataSource insertObject:ttempModel1 atIndex:tempJ];
                                    [self.columnCollectView moveItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:0] toIndexPath:[NSIndexPath indexPathForItem:tempJ inSection:0]];
                                    
                                    PVHomModel *ttempModel2 = self.columnDataSource[tempJ-1];
                                    [self.columnDataSource removeObjectAtIndex:(tempJ-1)];
                                    [self.columnDataSource insertObject:ttempModel2 atIndex:j];
                                    [self.columnCollectView moveItemAtIndexPath:[NSIndexPath indexPathForItem:(tempJ-1) inSection:0] toIndexPath:[NSIndexPath indexPathForItem:j inSection:0]];
                                }
                            }
                        }
                        
                    }else{
                        
                        
                        for (NSInteger j= (cellIndexPath.row+1); j <=  attributes.indexPath.row; j++) {
                            
                            PVHomModel *tempModel = self.columnDataSource[j];
                            if (!tempModel.isSelect) {
                                
                                NSInteger tempJ = j;
                                while (1) {
                                    tempJ--;
                                    if (!self.columnDataSource[tempJ].isSelect || tempJ == cellIndexPath.row) {
                                        break;
                                    }
                                }
                                
                                if (tempJ != j) {
                                    PVHomModel *ttempModel1 = self.columnDataSource[tempJ];
                                    [self.columnDataSource removeObjectAtIndex:tempJ];
                                    [self.columnDataSource insertObject:ttempModel1 atIndex:j];
                                    [self.columnCollectView moveItemAtIndexPath:[NSIndexPath indexPathForItem:tempJ inSection:0] toIndexPath:[NSIndexPath indexPathForItem:j inSection:0]];
                                    
                                    PVHomModel *ttempModel2 = self.columnDataSource[j-1];
                                    [self.columnDataSource removeObjectAtIndex:(j-1)];
                                    [self.columnDataSource insertObject:ttempModel2 atIndex:tempJ];
                                    [self.columnCollectView moveItemAtIndexPath:[NSIndexPath indexPathForItem:(j-1) inSection:0] toIndexPath:[NSIndexPath indexPathForItem:tempJ inSection:0]];
                                }
                            }
                        }
                        
                    }
                    break;
                }
            }
        }
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        if (!isChanged) {
            cell.center = [self.columnCollectView layoutAttributesForItemAtIndexPath:cellIndexPath].center;
        }
        cell.backView.center = CGPointMake(CGRectGetWidth(cell.frame)*0.5, CGRectGetHeight(cell.frame)*0.5);
        [cell addSubview:cell.backView];
        [cell bringSubviewToFront:cell.backView];
        
    }
}
@end
