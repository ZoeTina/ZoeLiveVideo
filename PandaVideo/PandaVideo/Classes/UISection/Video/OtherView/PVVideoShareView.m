//
//  PVVideoShareView.m
//  VideoDemo
//
//  Created by cara on 17/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoShareView.h"
#import "PVVideoShareCollectionViewCell.h"
#import "ShareModel.h"

static NSString* resuPVVideoShareCollectionViewCell = @"resuPVVideoShareCollectionViewCell";

@interface PVVideoShareView() <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *shareCollectionView;
@property(nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic, copy)PVVideoShareViewCallBlock callBlock;


@end


@implementation PVVideoShareView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.shareCollectionView.dataSource = self;
    self.shareCollectionView.delegate = self;
    [self.shareCollectionView registerNib:[UINib nibWithNibName:@"PVVideoShareCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:resuPVVideoShareCollectionViewCell];
}


// MARK:- ====UICollectionViewDataSource,UICollectionViewDelegate=====
//每个分区有多少个数据
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PVVideoShareCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVVideoShareCollectionViewCell forIndexPath:indexPath];
    
    ShareModel* shareModel = self.dataSource[indexPath.item];

    cell.shareModel = shareModel;
    
    return cell;
}
//布局协议对应的方法实现
#pragma mark - UICollectionViewDelegateFlowLayout
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = (self.sc_width-10)*0.5;
    CGFloat heigth = IPHONE6WH(85);
    
    return CGSizeMake(width,heigth);
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
    ShareModel* shareModel = self.dataSource[indexPath.item];
    if (self.callBlock) {
        self.callBlock(shareModel.title);
    }
}

-(void)setPVVideoShareViewCallBlock:(PVVideoShareViewCallBlock)block{
    self.callBlock = block;
}
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSMutableArray* titles = [NSMutableArray arrayWithCapacity:6];
        NSMutableArray* imageNames = [NSMutableArray arrayWithCapacity:6];
        //判断微信是否安装
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
            [titles addObject:@"微信"];
            [titles addObject:@"朋友圈"];
            [imageNames addObject:@"live_btn_wechat"];
            [imageNames addObject:@"live_btn_pyquan"];
        }
        if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
            [titles addObject:@"QQ好友"];
            [titles addObject:@"QQ空间"];
            [imageNames addObject:@"live_btn_qq"];
            [imageNames addObject:@"live_btn_qqzone"];
        }
        [titles addObject:@"微博"];
        [titles addObject:@"复制链接"];
        [imageNames addObject:@"live_btn_weibo"];
        [imageNames addObject:@"live_btn_link"];
        for (int i=0; i<titles.count; i++) {
            ShareModel* shareModel = [[ShareModel alloc]  init];
            shareModel.title = titles[i];
            shareModel.imageName = imageNames[i];
            [_dataSource addObject:shareModel];
        }
    }
    return _dataSource;
}
@end
