//
//  PVHistoryAndHotSearchController.m
//  PandaVideo
//
//  Created by cara on 17/7/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHistoryAndHotSearchController.h"
#import "PVHistorySearchCell.h"
#import "PVHotCollectionCell.h"
#import "PVHistoryAndHotHeadView.h"
#import "PVDBManager.h"
#import "PVHotWord.h"

static NSString * const resuPVHistoryAndHotHeadView = @"resuPVHistoryAndHotHeadView";
static NSString * const resuPVHistorySearchCell = @"resuPVHistorySearchCell";
static NSString * const resuPVHotCollectionCell = @"resuPVHotCollectionCell";

@interface PVHistoryAndHotSearchController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView* searchCollectView;
@property(nonatomic, strong)NSMutableArray* searchDataSource;
@property(nonatomic, strong)NSMutableArray* hotSearchDataSource;
@property(nonatomic, copy)HistoryAndHotSearchControllerBlock searchControllerBlock;


@end

@implementation PVHistoryAndHotSearchController

-(void)dealloc{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self loadData];
    
}

-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchCollectView];
    [self.searchCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)loadData{
    NSString* url = @"http://pandafile.sctv.com:42086/System/SearchManage/SearchManage.json";
    [PVNetTool getDataWithUrl:url success:^(id result) {
        if (result && [result isKindOfClass:[NSArray class]]) {
            NSArray* jsonArr = result;
            [self.hotSearchDataSource removeAllObjects];
            for (NSDictionary* jsonDict in jsonArr) {
                PVHotWord* hotWordModel = [[PVHotWord alloc]  init];
                [hotWordModel setValuesForKeysWithDictionary:jsonDict];
                [self.hotSearchDataSource addObject:hotWordModel];
            }
        }
        [self.searchCollectView reloadData];
    } failure:^(NSError *error) {
    }];
}
-(void)setHistoryDataSource:(NSArray *)historyDataSource{
    [self.searchDataSource removeAllObjects];
    [self.searchDataSource addObjectsFromArray:historyDataSource];
//    [self.searchCollectView reloadData];
}


-(void)setHistoryAndHotSearchControllerBlock:(HistoryAndHotSearchControllerBlock)block{
    self.searchControllerBlock = block;
}

/// MARK:- ======= UICollectionViewDataSource,UICollectionViewDelegate =========
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * string = @"";
    if (indexPath.section == 0) {
        string = [self.searchDataSource sc_safeObjectAtIndex:indexPath.item];
    }
    if (indexPath.section == 1) {
        PVHotWord * model = [self.hotSearchDataSource sc_safeObjectAtIndex:indexPath.item];
        string = model.hotword;
    }
    
    if (self.searchControllerBlock) {
        self.searchControllerBlock(string);
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  section == 0 ? self.searchDataSource.count : self.hotSearchDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        PVHistorySearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVHistorySearchCell forIndexPath:indexPath];
        cell.nameLabel.text = self.searchDataSource[indexPath.item];
        return cell;
    }else{
        PVHotCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVHotCollectionCell forIndexPath:indexPath];
        cell.section = indexPath.item;
        cell.hotWordModel = self.hotSearchDataSource[indexPath.item];

        return cell;
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    PVHistoryAndHotHeadView* headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resuPVHistoryAndHotHeadView forIndexPath:indexPath];
    
    headView.item = indexPath.section;
    
    PV(pv);
    [headView setClearClickedCallBlock:^{
        [pv clearClicked];
    }];
    
    headView.hidden = false;
    if (indexPath.section == 0 && self.searchDataSource.count == 0) {
        headView.hidden = true;
    }else if (indexPath.section == 1 && self.hotSearchDataSource.count == 0){
        headView.hidden = true;
    }
    
    return headView;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat width = (collectionView.sc_width-45)*0.5;
    CGFloat heigth = 33;
    if(indexPath.section == 1){
        width = ScreenWidth-30;
        heigth = 38;
    }
    
    return CGSizeMake(width,heigth);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,15,10,15);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0 && self.searchDataSource.count == 0) {
        return CGSizeMake(ScreenWidth,0.01);
    }else if (section == 1 && self.hotSearchDataSource.count == 0){
        return CGSizeMake(ScreenWidth,0.01);
    }
    return CGSizeMake(ScreenWidth,40);
}
-(void)clearClicked{
    [[PVDBManager sharedInstance]  deleteAllData];
    [self.searchDataSource removeAllObjects];
    [self.searchCollectView reloadData];
}

-(UICollectionView *)searchCollectView{
    if (!_searchCollectView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 5;
        _searchCollectView = [[UICollectionView alloc]  initWithFrame:CGRectZero collectionViewLayout:layOut];
        _searchCollectView.backgroundColor = [UIColor whiteColor];
        //设置数据源和代理
        _searchCollectView.delegate = self;
        _searchCollectView.dataSource = self;
        _searchCollectView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_searchCollectView registerClass:[PVHistoryAndHotHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resuPVHistoryAndHotHeadView];
        [_searchCollectView registerClass:[PVHistorySearchCell class] forCellWithReuseIdentifier:resuPVHistorySearchCell];
        [_searchCollectView registerNib:[UINib nibWithNibName:@"PVHotCollectionCell" bundle:nil] forCellWithReuseIdentifier:resuPVHotCollectionCell];
        _searchCollectView.showsVerticalScrollIndicator = false;
        _searchCollectView.showsHorizontalScrollIndicator = false;
    }
    return _searchCollectView;
}
-(NSMutableArray *)searchDataSource{
    if (!_searchDataSource) {
        _searchDataSource = [NSMutableArray array];
    }
    return _searchDataSource;
}
-(NSMutableArray *)hotSearchDataSource{
    if (!_hotSearchDataSource) {
        _hotSearchDataSource = [NSMutableArray array];
    }
    return _hotSearchDataSource;
}



//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView* superView = self.view.superview;
//    [superView endEditing:true];
//    return self.searchCollectView;
//}

@end
