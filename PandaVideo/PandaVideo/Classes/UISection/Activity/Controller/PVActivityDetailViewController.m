//
//  PVActivityDetailViewController.m
//  PandaVideo
//
//  Created by cara on 17/8/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVActivityDetailViewController.h"
#import "PVRecommandCollectionViewCell.h"
#import "PVRecommandReusableView.h"
#import "PVReCommandFootReusableView.h"
#import "PVHeadRecommandCollectionReusableView.h"
#import "PVInteractionLiveCell.h"
#import "PVDemandViewController.h"
#import "SCButton.h"
#import "TYCyclePagerView.h"
#import "PVHomeBannerCell.h"
#import "PVPictrueTemmpletCell.h"

static NSString* resuPVHomeBannerCell = @"resuPVHomeBannerCell";
static NSString* resuPVRecommandCollectionViewCell = @"resuPVRecommandCollectionViewCell";
static NSString* resuPVHeadRecommandCollectionReusableView = @"PVHeadRecommandCollectionReusableView";
static NSString* resuPVRecommandReusableView = @"resuPVRecommandReusableView";
static NSString* resuPVReCommandFootReusableView = @"resuPVReCommandFootReusableView";
static NSString* resuPVInteractionLiveCell = @"resuPVInteractionLiveCell";
static NSString* resuPVPictrueTemmpletCell = @"resuPVPictrueTemmpletCell";


@interface PVActivityDetailViewController () <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

///广告和快捷入口
@property(nonatomic,strong)UIView* containerView;
///轮播图
@property (nonatomic, strong)TYCyclePagerView *pagerView;
@property(nonatomic, strong)NSMutableArray* advImages;
///展示模版的CollectView
@property(nonatomic, strong)UICollectionView* templetCollectView;
@property(nonatomic, strong)NSMutableArray*   templetDataSource;
///btn模版
@property(nonatomic,strong)UIView* btnView;

@end

@implementation PVActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

}
-(void)setupUI{
    [self.view addSubview:self.templetCollectView];
    self.templetCollectView.frame = self.view.bounds;
}

// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) return 0;
    if (section == 3) return 1;
    return (section == 1) ? 2 : 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        PVRecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVRecommandCollectionViewCell forIndexPath:indexPath];
        cell.type = 1;
        return cell;
    }else if (indexPath.section == 3){
        PVPictrueTemmpletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVPictrueTemmpletCell forIndexPath:indexPath];
        return cell;
    }
    PVInteractionLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVInteractionLiveCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader) {
            PVHeadRecommandCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVHeadRecommandCollectionReusableView forIndexPath:indexPath];
            [headerView addSubview:self.containerView];
            return headerView;
        }else{
            PVReCommandFootReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVReCommandFootReusableView forIndexPath:indexPath];
            footerView.hidden = true;
            return footerView;
        }
    }
    
    if (kind == UICollectionElementKindSectionHeader) {
        PVRecommandReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVRecommandReusableView forIndexPath:indexPath];
        headerView.hidden = false;
        headerView.type = (indexPath.section == 1) ? 8 : 2;
        if (indexPath.section == 1) {
            headerView.titleLabel.text = @"快乐男声30强";
        }else if (indexPath.section == 2){
            headerView.titleLabel.text = @"活动视频";
        }else{
            headerView.hidden = true;
        }
        return headerView;
    }
    PVReCommandFootReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuPVReCommandFootReusableView forIndexPath:indexPath];
    if( indexPath.section == 2){
        footerView.hidden = false;
        footerView.type = 3;
        footerView.moreLaebl.text = @"更多精彩";
    }else{
        footerView.hidden = true;
    }
    return footerView;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat width = ScreenWidth-20;
    CGFloat height = width*9/16;
    CGFloat margin = 60;
    if (indexPath.section == 2) {
        width = (collectionView.sc_width-30)*0.5;
        height = width*9/16 + margin;
    }else if (indexPath.section == 3){
        height = ScreenWidth*70/350;
        width = ScreenWidth;
    }
    return CGSizeMake((int)width,height);
    
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 3) {
        return UIEdgeInsetsMake(0,0,10,0);
    }
    return UIEdgeInsetsMake(0,10,10,10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (!section) {
        return CGSizeMake(ScreenWidth,self.containerView.sc_height);
    }else if (section == 3){
        return CGSizeMake(ScreenWidth,0.01);
    }
    return CGSizeMake(ScreenWidth,40);
}
//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return CGSizeMake(ScreenWidth,50);
    }
    return CGSizeMake(ScreenWidth,0.01);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
    [self.navigationController pushViewController:vc animated:true];
}
// MARK: - ==============懒加载==============
-(UICollectionView *)templetCollectView{
    if (!_templetCollectView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 5;
        _templetCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
        //设置数据源和代理
        _templetCollectView.delegate = self;
        _templetCollectView.dataSource = self;
        _templetCollectView.backgroundColor = [UIColor whiteColor];
        _templetCollectView.scrollsToTop = true;
        CGFloat bottom = kiPhoneX ? (kTabBarHeight+14+61) :  (kTabBarHeight+61);
        _templetCollectView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVInteractionLiveCell" bundle:nil] forCellWithReuseIdentifier:resuPVInteractionLiveCell];
        [_templetCollectView registerClass:[PVHeadRecommandCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resuPVHeadRecommandCollectionReusableView];
        [_templetCollectView registerNib:[UINib nibWithNibName:@"PVRecommandReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:resuPVRecommandReusableView];
        [_templetCollectView registerNib:[UINib nibWithNibName:@"PVReCommandFootReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:resuPVReCommandFootReusableView];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVRecommandCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVRecommandCollectionViewCell];
        [_templetCollectView registerClass:[PVPictrueTemmpletCell class] forCellWithReuseIdentifier:resuPVPictrueTemmpletCell];
    }
    return _templetCollectView;
}
-(NSMutableArray *)templetDataSource{
    if (!_templetDataSource) {
        _templetDataSource = [NSMutableArray array];
    }
    return _templetDataSource;
}
-(UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        [_containerView addSubview:self.pagerView];
        [_containerView addSubview:self.btnView];
        _containerView.frame = CGRectMake(0, 0, ScreenWidth,CGRectGetMaxY(self.btnView.frame)-8);
        [self.pagerView reloadData];
    }
    return _containerView;
}
-(TYCyclePagerView *)pagerView{
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc]  init];
        [_pagerView registerNib:[UINib nibWithNibName:@"PVHomeBannerCell" bundle:nil] forCellWithReuseIdentifier:resuPVHomeBannerCell];
        _pagerView.isInfiniteLoop = true;
        _pagerView.autoScrollInterval = 3;
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        _pagerView.frame = CGRectMake(0, 0, ScreenWidth, (ScreenWidth-40)*9/16);
    }
    return _pagerView;
}
-(NSMutableArray *)advImages{
    if (!_advImages) {
        _advImages = [NSMutableArray array];
        for (int i=0; i<4; i++) {
            [_advImages addObject:[NSString stringWithFormat:@"%d.jpg",i+1]];
        }
    }
    return _advImages;
}
-(UIView *)btnView{
    if (!_btnView) {
        _btnView = [[UIView alloc]  init];
        _btnView.frame = CGRectMake(0, CGRectGetMaxY(self.pagerView.frame), ScreenWidth, 70);
        _btnView.backgroundColor = [UIColor whiteColor];
        NSArray* titles = @[@"报名入口",@"人气榜单",@"活动规则"];
        
        CGFloat leftAndRight = IPHONE6WH(45);
        CGFloat margin = IPHONE6WH(55);
        CGFloat width = (ScreenWidth-2*leftAndRight-margin*(titles.count-1))/titles.count;
        CGFloat height = 60;
        
        for (int i=0; i<titles.count; i++) {
            SCButton* btn = [SCButton customButtonWithTitlt:titles[i] imageNolmalString:@"栏目编辑-icon-少儿" imageSelectedString:@"栏目编辑-icon-少儿"];
            btn.sc_x = leftAndRight + (margin+width)*i;
            btn.sc_y = 8;
            btn.sc_width = width;
            btn.sc_height = height;
            [_btnView addSubview:btn];
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _btnView;
}
-(void)btnClicked:(UIButton*)btn{
    
    
}
 #pragma mark - TYCyclePagerViewDataSource
 
-(NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.advImages.count;
}
-(UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    PVHomeBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:resuPVHomeBannerCell forIndex:index];
    cell.bannerImageView.image = [UIImage imageNamed:self.advImages[index]];
    return cell;
}
- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
}
- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth - 40, (ScreenWidth-40)*9/16);
    layout.itemSpacing = 10;
    layout.itemHorizontalCenter = YES;
    return layout;
}
@end
