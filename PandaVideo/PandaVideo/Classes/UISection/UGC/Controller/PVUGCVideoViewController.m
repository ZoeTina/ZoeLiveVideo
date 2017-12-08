//
//  PVUGCVideoViewController.m
//  PandaVideo
//
//  Created by songxf on 2017/11/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVUGCVideoViewController.h"
#import "PVUGCVideoHeaderView.h"
#import "SCAssetModel.h"
#import "SCImagePickerVideoController.h"
#import <AVFoundation/AVFoundation.h>
#import "SCImageManager.h"
#import "PVUgcEditVideoViewController.h"
#import "SCCompressTools.h"
#import "PVDBManager.h"
#import "PVVideoTipsView.h"
#import "PVNoDataView.h"

static NSString *const PVUGCVideoHeaderId = @"PVUGCVideoHeaderId";
static NSString *const PVUGCVideoSelectedCellId = @"PVUGCVideoSelectedCellId";
@interface PVUGCVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    @private UICollectionView *_colletionView;
}
@property (nonatomic, strong, readonly) UICollectionView *colletionView;
@property (nonatomic, strong) PVVideoTipsView *videoTipsView;
@property (nonatomic, strong) PVNoDataView *noDataView;
@end

@implementation PVUGCVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self setLeftNavBarItemWithImage:@"all_btn_back_grey"];
    self.scNavigationItem.title = @"相册视频";
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    [self.colletionView registerClass:[PVUGCVideoHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PVUGCVideoHeaderId];
    [self.colletionView registerClass:[PVUGCVideoSelectedCell class] forCellWithReuseIdentifier:PVUGCVideoSelectedCellId];
    [self.view addSubview:self.videoTipsView];
    self.videoTipsView.tipsText = [NSString stringWithFormat:@"温馨小贴士：视频不超过%ldM，是极好的哦~",(long)self.videoUgcModel.videoSize];
    [self.videoTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(60);
    }];
    
    [self.view addSubview:self.colletionView];
    [self.colletionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavBarHeight);
        make.left.right.mas_offset(0);
        make.bottom.equalTo(self.videoTipsView.mas_top).mas_offset(-10);
    }];
    
    if (self.videoArray.count == 0) {
        self.noDataView.hidden = NO;
    }else {
        self.noDataView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark colletionViewDelegate  dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MAX(self.videoArray.count, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    SCAssetListModel * model = [self.videoArray sc_safeObjectAtIndex:section];
    return MAX(model.modelArray.count, 0);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     PVUGCVideoSelectedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PVUGCVideoSelectedCellId forIndexPath:indexPath];
    SCAssetListModel * listModel = [self.videoArray sc_safeObjectAtIndex:indexPath.section];
    SCAssetModel *model = [listModel.modelArray sc_safeObjectAtIndex:indexPath.row];
    cell.model = model;
    PV(weakSelf);
    cell.playVideoBlock = ^{
//        SCImagePickerVideoController *vc = [[SCImagePickerVideoController alloc] init];
//        vc.model = model;
//        vc.ugcModel = weakSelf.videoUgcModel;
//        vc.isImagePickerPreView = YES;
////        [weakSelf presentViewController:vc animated:YES completion:nil];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}


// 头部
- ( UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PVUGCVideoHeaderView *videHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PVUGCVideoHeaderId forIndexPath:indexPath];
        SCAssetListModel * listModel = [self.videoArray sc_safeObjectAtIndex:indexPath.section];
        videHeaderView.dateLabel.text = [[NSDate sc_dateFromString:listModel.createDate withFormat:@"yyyyMMdd"] stringFromDate:@"yyyy年MM月dd日"];
        return videHeaderView;
    }
    return nil;
}

//section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//上下行cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
    
}

//同一行的cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){ScreenWidth,40};
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return (CGSize){ScreenWidth/4 - 1,ScreenWidth/4 - 1};
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *assetArray = [[PVDBManager sharedInstance] selectShortVideoModelAllData];
    for (SCAssetModel *assetModel in assetArray) {
        if ([assetModel.videoPublishState isEqualToString:@"0"] || [assetModel.videoPublishState isEqualToString:@"2"]) {
            Toast(@"有视频正在上传，请稍后");
            return;
        }
    }
    
    SCAssetListModel * listModel = [self.videoArray sc_safeObjectAtIndex:indexPath.section];
    SCAssetModel *model = [listModel.modelArray sc_safeObjectAtIndex:indexPath.row];
    
    PVUgcEditVideoViewController *videoCon = [[PVUgcEditVideoViewController alloc] init];
    videoCon.editUgcModel = self.videoUgcModel;
    [[SCImageManager manager] getPhotoWithAsset:model.asset photoWidth:kDistanceWidthRatio(250) completion:^(UIImage *photoImage, NSDictionary *info, BOOL isDegraded) {
        model.corverImage = photoImage;
        videoCon.assetModel = model;
    }];
    
    [[PVProgressHUD shared] showHudInView:self.view];
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;

    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:model.asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;

        NSURL *url = urlAsset.URL;
        NSNumber *fileSizeValue = nil;        
        [url getResourceValue:&fileSizeValue forKey:NSURLFileSizeKey error:nil];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        CGFloat size = data.length / 1024. / 1024.;
        if (size > self.videoUgcModel.videoSize) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [[PVProgressHUD shared] hideHudInView:self.view];
                Toast(@"视频大小超出限制");
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                PV(pv);
                [[PVProgressHUD shared] hideHudInView:self.view];
                [pv.navigationController pushViewController:videoCon animated:YES];
            });
            
        }
    }];
    
    

}
#pragma mark  getter ,setter
- (UICollectionView *)colletionView{
    if (_colletionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //        layout.estimatedItemSize = CGSizeMake(kScreenWidth/2 - 8, 200);
        _colletionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _colletionView.backgroundColor = [UIColor clearColor];
        _colletionView.delegate = self;
        _colletionView.dataSource = self;
    }
    return _colletionView;
}


- (PVVideoTipsView *)videoTipsView {
    if (!_videoTipsView) {
        _videoTipsView = [[PVVideoTipsView alloc] initUGCTipsViewWithFrame:CGRectZero];
    }
    return _videoTipsView;
}


- (PVNoDataView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[PVNoDataView alloc] initWithFrame:CGRectMake(0, 198, kScreenWidth, 200) ImageName:@"novideo" tipsLabelText:@"暂无可选择视频"];
        [self.view insertSubview:_noDataView aboveSubview:self.colletionView];
        [self.noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.height.mas_equalTo(200);
        }];
    }
    return _noDataView;
}


@end
