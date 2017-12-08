//
//  PVScreeningBoxViewCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVScreeningBoxViewCell.h"
#import "PVScreeningBoxCollectionViewCell.h"
static NSString* resuPVScreeningBoxCollectionViewCell = @"resuPVScreeningBoxCollectionViewCell";

@interface PVScreeningBoxViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)NSMutableArray<KeyModel*> *dataSource;

@end

@implementation PVScreeningBoxViewCell


-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setFilter:(Filter *)filter{
    _filter = filter;
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:filter.keys];
    [self.collectionView reloadData];
}


-(void)setupUI{
    [self.contentView addSubview:self.collectionView];
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
    PVScreeningBoxCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVScreeningBoxCollectionViewCell forIndexPath:indexPath];
    cell.keyModel = self.dataSource[indexPath.row];
    cell.textBtn.tag = indexPath.row;
    return cell;
}
//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat width = 86;
    return CGSizeMake(width,self.contentView.sc_height);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0,0);
}
//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    

    for (KeyModel *model in self.dataSource) {
        model.isSelect = NO;
    }
    KeyModel *keyModel = self.dataSource[indexPath.row];
    keyModel.isSelect = YES;
    
    NSDictionary *dict = @{@"filterKey":self.filter.filterKey,
                           @"kId":keyModel.kId,};
    [kNotificationCenter postNotificationName:@"updateCollectionData" object:nil userInfo:dict];

    
    [collectionView reloadData];
}




-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layOut.minimumLineSpacing = 0;
        layOut.minimumInteritemSpacing = 0;
        CGRect frame = CGRectMake(0, 0, kScreenWidth, self.contentView.sc_height);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layOut];
        //设置数据源和代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = false;
        [_collectionView  registerNib:[UINib nibWithNibName:@"PVScreeningBoxCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVScreeningBoxCollectionViewCell];
    }
    return _collectionView;
}


-(NSMutableArray<KeyModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
