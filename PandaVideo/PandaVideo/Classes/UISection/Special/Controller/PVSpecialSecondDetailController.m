//
//  PVSpecialSecondDetailController.m
//  PandaVideo
//
//  Created by cara on 17/8/10.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSpecialSecondDetailController.h"
#import "PVStarDetailCollectionViewCell.h"
#import "PVSpecialHeadView.h"
#import "PVDemandViewController.h"
#import "PVSpecialDetailModel.h"

static NSString* resuPVStarDetailCollectionViewCell = @"resuPVStarDetailCollectionViewCell";

@interface PVSpecialSecondDetailController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong)UICollectionView* starCollectView;
@property(nonatomic, strong)NSMutableArray*   dataSource;
@property(nonatomic, strong)UIButton* backBtn;
@property(nonatomic, strong)PVSpecialHeadView* headView;
///哪一种cell类型
@property(nonatomic, assign)NSInteger type;
@property(nonatomic, strong)PVSpecialDetailModel*  specialDetailModel;

@property(nonatomic, assign)CGFloat headViewHeight;

@end

@implementation PVSpecialSecondDetailController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.headViewHeight =  ScreenWidth*211/375+80;
    [self loadData];

}
-(void)loadData{
    if (!self.menuUrl.length)return;
    [PVNetTool getDataWithUrl:self.menuUrl success:^(id result) {
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            PVSpecialDetailModel*  specialDetailModel = [[PVSpecialDetailModel alloc]  init];
            [specialDetailModel setValuesForKeysWithDictionary:result];
            self.specialDetailModel = specialDetailModel;
            self.headViewHeight =  ScreenWidth*211/375+20+specialDetailModel.topicSubTitleHeight;
            [self setupUI];
            self.scNavigationItem.title = specialDetailModel.topicTitle;
            if (self.specialDetailModel.modelType.intValue == 17) {
                self.type = 1;
            }else{
                self.type = 2;
            }
        }
        [self.starCollectView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"--------error---------%@",error);
    }];
}

-(void)setupNavigationBar{
    self.scNavigationItem.title = @"专题";
}
-(void)setupUI{
    self.scNavigationItem.leftBarButtonItem = nil;
    [self.view insertSubview:self.headView belowSubview:self.backBtn];
    [self.view insertSubview:self.starCollectView belowSubview:self.scNavigationBar];
}
// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.specialDetailModel.topicList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PVStarDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVStarDetailCollectionViewCell forIndexPath:indexPath];
    cell.type = self.type;
    cell.videoListModel = self.specialDetailModel.topicList[indexPath.item];
    return cell;
}

//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat leftAndRight = 24;
    CGFloat margin = 3;
    CGFloat fixedValue = 50;
    CGFloat  width = (collectionView.sc_width-margin-leftAndRight)*0.5;
    CGFloat   heigth = width*98/174 + fixedValue;
    
    if (self.type == 2) {
         width = (collectionView.sc_width-2*margin-leftAndRight)/3;
         heigth = width*4/3 + fixedValue;
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
    return CGSizeMake(0,0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
    PVVideoListModel* model = self.specialDetailModel.topicList[indexPath.item];
    vc.url = model.info.jsonUrl;
    [self.navigationController pushViewController:vc animated:true];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    if (offsetY == 0) {
        self.headView.sc_y = 0;
        self.headView.sc_height = self.headViewHeight;
        self.headView.alpha = 1.0;
    }else if (offsetY < 0) {
        self.headView.sc_y = 0;
        self.headView.sc_height = self.headViewHeight-offsetY;
    }else{
        self.headView.sc_height = self.headViewHeight;
        CGFloat min = self.headViewHeight-64;
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
        CGFloat bottom = kiPhoneX ? 34 : 1;
        _starCollectView.sc_height = self.view.sc_height-bottom;
        _starCollectView.delegate = self;
        _starCollectView.dataSource = self;
        _starCollectView.backgroundColor = [UIColor whiteColor];
        _starCollectView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.headView.frame), 0, 0, 0);
        _starCollectView.scrollIndicatorInsets = UIEdgeInsetsMake(CGRectGetMaxY(self.headView.frame), 0, 0, 0);
        [_starCollectView  registerNib:[UINib nibWithNibName:@"PVStarDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVStarDetailCollectionViewCell];
        _starCollectView.scrollsToTop = true;
    }
    return _starCollectView;
}
-(PVSpecialHeadView *)headView{
    if (!_headView) {
        _headView = [[PVSpecialHeadView alloc]  initPVSpecialDetailModel:self.specialDetailModel];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, self.headViewHeight);
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat y = kiPhoneX ? 42 : 20;
        _backBtn.frame = CGRectMake(5, y, 50, 50);
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
