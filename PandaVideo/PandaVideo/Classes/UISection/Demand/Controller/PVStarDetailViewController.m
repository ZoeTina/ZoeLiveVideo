//
//  PVStarDetailViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVStarDetailViewController.h"
#import "PVVideoDetailTempletCell.h"
#import "PVStarDetailCollectionViewCell.h"
#import "PVRecommandReusableView.h"
#import "PVStarDetailHeadView.h"
#import "PVDemandViewController.h"


static NSString* resuPVVideoDetailTempletCell = @"resuPVVideoDetailTempletCell";
static NSString* resuPVStarDetailCollectionViewCell = @"resuPVStarDetailCollectionViewCell";
static NSString* resuPVRecommandReusableView = @"resuPVRecommandReusableView";

@interface PVStarDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView* starCollectView;
@property(nonatomic, strong)NSMutableArray*   dataSource;
@property(nonatomic, strong)PVStarDetailHeadView* headView;
@property(nonatomic, strong)UIButton* backBtn;

@end

@implementation PVStarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"胡歌";
}
-(void)setupUI{
    
    self.scNavigationItem.leftBarButtonItem = nil;
    [self.view insertSubview:self.headView belowSubview:self.backBtn];
    [self.view insertSubview:self.starCollectView belowSubview:self.scNavigationBar];
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count+6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        PVVideoDetailTempletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVVideoDetailTempletCell forIndexPath:indexPath];
        return cell;
        
    }else if (indexPath.section == 2) {
        PVStarDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVStarDetailCollectionViewCell forIndexPath:indexPath];
        
        cell.type = 1;
        
        return cell;
    }
    return [[UICollectionViewCell alloc]  init];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        PVRecommandReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVRecommandReusableView forIndexPath:indexPath];
        headerView.type = 4;
        headerView.sectionOfStar = indexPath.section;
        return headerView;
    }
    return nil;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat leftAndRight = 24;
    CGFloat margin = 3;
    CGFloat fixedValue = 40;
    
    CGFloat width = IPHONE6WH((collectionView.sc_width-2*margin-leftAndRight)/3);
    CGFloat heigth = width*153/115 + fixedValue;
    
    if (indexPath.section == 2) {
        width = IPHONE6WH((collectionView.sc_width-margin-leftAndRight)*0.5);
        heigth = width*98/174 + fixedValue+15;
    }
    return CGSizeMake(width,heigth);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,12,0,12);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth,40);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
    [self.navigationController pushViewController:vc animated:true];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    if (offsetY == 0) {
        self.headView.sc_y = 0;
        self.headView.sc_height = 133;
        self.headView.alpha = 1.0;
    }else if (offsetY < 0) {
        self.headView.sc_y = 0;
        self.headView.sc_height = 133-offsetY;
    }else{
        self.headView.sc_height = 133;
        CGFloat min = 133-64;
        self.headView.sc_y =  -((min <= offsetY) ? min : offsetY);
        CGFloat progress = 1- (offsetY/min);
        self.headView.alpha = progress;
    }
}

-(UICollectionView *)starCollectView{
    if (!_starCollectView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        layOut.minimumLineSpacing = 3;
        layOut.minimumInteritemSpacing = 3;
        CGRect frame = CGRectMake(1, 1, ScreenWidth, self.view.sc_height-1);
        _starCollectView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layOut];
        _starCollectView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.headView.frame), 0, 0, 0);
        _starCollectView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetMaxY(self.headView.frame), 0, 0, 0);
        _starCollectView.delegate = self;
        _starCollectView.dataSource = self;
        _starCollectView.backgroundColor = [UIColor whiteColor];
        [_starCollectView registerNib:[UINib nibWithNibName:@"PVRecommandReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resuPVRecommandReusableView];
        [_starCollectView  registerNib:[UINib nibWithNibName:@"PVVideoDetailTempletCell" bundle:nil] forCellWithReuseIdentifier:resuPVVideoDetailTempletCell];
        [_starCollectView  registerNib:[UINib nibWithNibName:@"PVStarDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVStarDetailCollectionViewCell];
        _starCollectView.scrollsToTop = true;
    }
    return _starCollectView;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(PVStarDetailHeadView *)headView{
    if (!_headView) {
        _headView = [[PVStarDetailHeadView alloc]  init];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 120);
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(5, 20, 40, 40);
        [_backBtn setImage:[UIImage imageNamed:@"all_btn_back_grey"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backBtn];
    }
    return _backBtn;
}
-(void)backBtnClicked{
    [self.navigationController popViewControllerAnimated:true];
}
@end
