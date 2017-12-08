//
//  PVSearchResultMoreViewController.m
//  PandaVideo
//
//  Created by songxf on 2017/11/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSearchResultMoreViewController.h"
#import "PVAnthologyCollectionViewCell.h"
#import "PVAnthologyTextCell.h"
#import "PVDemandVideoAnthologyModel.h"
#import "PVDemandViewController.h"

static NSString* resuPVAnthologyCollectionViewCell = @"resuPVAnthologyCollectionViewCell";
static NSString* resuPVAnthologyTextCell = @"resuPVAnthologyTextCell";

@interface PVSearchResultMoreViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic, strong)UICollectionView* templetCollectView;

@end

@implementation PVSearchResultMoreViewController


-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
}


-(void)loadData{
    [PVNetTool getDataWithUrl:self.url success:^(id result) {
        if (result[@"modelList"] && [result[@"modelList"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary* jsonDict = result[@"modelList"];
            if (jsonDict[@"episodeModel"] && [jsonDict[@"episodeModel"] isKindOfClass:[NSDictionary class]]) {
                NSString* jsonUrl = jsonDict[@"episodeModel"][@"epospdeUrl"];
                [self loadEpospde:jsonUrl];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"------error = %@-------",error);
    }];
}

-(void)loadEpospde:(NSString*)jsonUrl{
    [PVNetTool getDataWithUrl:jsonUrl success:^(id result) {
        if (result[@"episodeList"] && [result[@"episodeList"] isKindOfClass:[NSArray class]]) {
            NSArray* jsonArr = result[@"episodeList"];
            [self.dataSource removeAllObjects];
            for (NSDictionary* jsonDict in jsonArr) {
                PVDemandVideoAnthologyModel* model = [[PVDemandVideoAnthologyModel alloc]  init];
                [model setValuesForKeysWithDictionary:jsonDict];
                [self.dataSource addObject:model];
            }
            [self.templetCollectView reloadData];
        }
        NSLog(@"result = %@",result);
    } failure:^(NSError *error) {
        NSLog(@"------error = %@-------",error);
    }];
}


-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    if(self.videoTitle.length){
        self.scNavigationItem.title = self.videoTitle;
    }
    [self.view insertSubview:self.templetCollectView aboveSubview:self.scNavigationBar];
    [self.templetCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(self.scNavigationBar.mas_bottom).offset(0);
        make.bottom.equalTo(@(0));
    }];
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
    if (self.showType == 1) {//数字
        PVAnthologyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVAnthologyCollectionViewCell forIndexPath:indexPath];
        cell.anthologyModel = self.dataSource[indexPath.item];
        cell.backgroundColor = [UIColor redColor];
        return cell;
    }else if (self.showType == 2){//文字
        PVAnthologyTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVAnthologyTextCell forIndexPath:indexPath];
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
    CGFloat width = (collectionView.sc_width-45)/6;
    CGFloat heigth = width-5;
    if (self.showType == 2){
        width = collectionView.sc_width - 15;
        heigth = scanle(44);
    }
    return CGSizeMake(width,heigth);
}
//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,10,10,10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PVDemandVideoAnthologyModel* anthologyModel = self.dataSource[indexPath.item];
    PVDemandViewController* vc = [[PVDemandViewController alloc]  init];
    vc.url = anthologyModel.videoUrl;
    vc.code = anthologyModel.code;
    vc.isScroll = true;
    [self.navigationController pushViewController:vc animated:true];
}
-(UICollectionView *)templetCollectView{
    if (!_templetCollectView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumLineSpacing = 5;
        layOut.minimumInteritemSpacing = 5;
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        _templetCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layOut];
        //设置数据源和代理
        _templetCollectView.delegate = self;
        _templetCollectView.dataSource = self;
        _templetCollectView.backgroundColor = [UIColor whiteColor];
        [_templetCollectView  registerNib:[UINib nibWithNibName:@"PVAnthologyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVAnthologyCollectionViewCell];
        [_templetCollectView registerClass:[PVAnthologyTextCell class] forCellWithReuseIdentifier:resuPVAnthologyTextCell];
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
