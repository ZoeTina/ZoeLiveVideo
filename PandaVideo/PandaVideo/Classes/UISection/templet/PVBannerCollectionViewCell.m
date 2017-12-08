//
//  PVBannerCollectionViewCell.m
//  PandaVideo
//
//  Created by cara on 2017/10/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBannerCollectionViewCell.h"
#import "TYCyclePagerView.h"
#import "PVHomeBannerCell.h"
#import "SCButton.h"
#import "UIButton+WebCache.h"

static NSString* resuPVHomeBannerCell = @"resuPVHomeBannerCell";

@interface PVBannerCollectionViewCell() <TYCyclePagerViewDataSource, TYCyclePagerViewDelegate>

///广告模板
@property (nonatomic, strong)TYCyclePagerView *pagerView;
@property(nonatomic, strong)NSMutableArray* advImages;
@property(nonatomic,strong)NSMutableArray* btnDataSource;
@property(nonatomic,strong)NSMutableArray* imageBtnsDataSource;
@property(nonatomic,strong)UIView* btnView;
@property(nonatomic,strong)UIView* imageView;
///用来区别是图片模板还是文字加图片模板
@property(nonatomic, assign)BOOL  isImageBtn;

@property(nonatomic, copy)PVBannerCollectionViewCellCallBlock callBlock;

@end

@implementation PVBannerCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.pagerView];
//    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
}

-(void)setPVBannerCollectionViewCellCallBlock:(PVBannerCollectionViewCellCallBlock)block{
    self.callBlock = block;
}


-(void)setType:(NSInteger)type{
    _type = type;
    if (type == 1) {
        self.pagerView.hidden = false;
        self.imageView.hidden = true;
        self.btnView.hidden = true;
    }else if (type == 2){
        self.pagerView.hidden = true;
        self.imageView.hidden = true;
        self.btnView.hidden = false;
    }else if (type == 3){
        self.imageView.hidden = false;
        self.pagerView.hidden = true;
        self.btnView.hidden = true;
    }
}

-(void)listDataSource:(NSArray*)dataSource{
    if (self.type == 1) {
        [self.advImages removeAllObjects];
        [self.advImages addObjectsFromArray:dataSource];
        [self.pagerView removeFromSuperview];
        self.pagerView = nil;
        [self addSubview:self.pagerView];
        [self.pagerView reloadData];
    }else if (self.type == 2){
        [self.btnDataSource removeAllObjects];
        [self.btnDataSource addObjectsFromArray:dataSource];
        [self.btnView removeFromSuperview];
        self.btnView = nil;
        [self addSubview:self.btnView];
        [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }else if (self.type == 3){
        [self.imageBtnsDataSource removeAllObjects];
        [self.imageBtnsDataSource addObjectsFromArray:dataSource];
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }

}


-(TYCyclePagerView *)pagerView{
    if (!_pagerView) {
        _pagerView = [[TYCyclePagerView alloc]  init];
        [_pagerView registerNib:[UINib nibWithNibName:@"PVHomeBannerCell" bundle:nil] forCellWithReuseIdentifier:resuPVHomeBannerCell];
        _pagerView.dataSource = self;
        _pagerView.delegate = self;
        CGFloat x = 0;
        CGFloat height = (ScreenWidth-40)*9/16;
        if (self.advImages.count == 1) {
            height = ScreenWidth*9/16;
            _pagerView.isInfiniteLoop = false;
            _pagerView.autoScrollInterval = 0;
        }else{
            _pagerView.isInfiniteLoop = true;
            _pagerView.autoScrollInterval = 5;
        }
        _pagerView.frame = CGRectMake(x, 0, ScreenWidth, height);
    }
    return _pagerView;
}
#pragma mark - TYCyclePagerViewDataSource

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return self.advImages.count;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    
    PVHomeBannerCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:resuPVHomeBannerCell forIndex:index];
    cell.bannerModel = self.advImages[index];
    cell.countLabel.text = [NSString stringWithFormat:@"%ld/%ld",index+1,(unsigned long)self.advImages.count];
    if (self.advImages.count == 1) {
        cell.countLabel.hidden = true;
    }
    return cell;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    if (self.callBlock) {
        self.callBlock(self.advImages[index]);
    }
}
- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc] init];
    CGFloat width = ScreenWidth - 20;
    CGFloat height =  (ScreenWidth-20)*9/16;
    if (self.advImages.count == 1) {
        layout.itemSpacing = 0;
        width = ScreenWidth;
        height = ScreenWidth*9/16;
    }else{
        layout.itemSpacing = 3;
    }
    layout.itemHorizontalCenter = YES;
    layout.itemSize = CGSizeMake(width,height);
    return layout;
}
-(NSMutableArray *)advImages{
    if (!_advImages) {
        _advImages = [NSMutableArray array];
    }
    return _advImages;
}


-(UIView *)btnView{
    if (!_btnView) {
        _btnView = [[UIView alloc]  init];
        _btnView.frame = CGRectMake(0, 0, ScreenWidth, 80);
        _btnView.backgroundColor = [UIColor whiteColor];
        [self creatBtn];
    }
    return _btnView;
}

-(UIView *)imageView{
    if (!_imageView) {
        _imageView = [[UIView alloc]  init];
        _imageView.frame = CGRectMake(0, 0, ScreenWidth, 60);
        _imageView.backgroundColor = [UIColor whiteColor];
        UIView* topView = [[UIView alloc]  init];
        topView.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
        topView.frame = CGRectMake(0, 0, ScreenWidth, 3);
        [_imageView addSubview:topView];
        [self creatImageBtn];
    }
    return _imageView;
}


-(void)creatBtn{
    //    CGFloat leftAndRight = IPHONE6WH(15);
    //    CGFloat margin = IPHONE6WH(10);
    CGFloat width = 61;
    CGFloat margin = (ScreenWidth-width*self.btnDataSource.count)/(self.btnDataSource.count+1);
    CGFloat height = 60;
    CGFloat  leftAndRight = margin;
    for (int i=0; i<self.btnDataSource.count; i++) {
        PVBannerModel* bannerModel = self.btnDataSource[i];
        SCButton* btn = [SCButton customButtonWithTitlt:bannerModel.bannerTxt imageNolmalString:bannerModel.bannerImage imageSelectedString:bannerModel.bannerImage];
        btn.sc_x = leftAndRight + (margin+width)*i;
        btn.sc_y = 10;
        btn.sc_width = width;
        btn.sc_height = height;
        btn.tag = 100 + i;
        [_btnView addSubview:btn];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)btnClicked:(UIButton*)btn{
    NSInteger index = btn.tag - 100;
    if (self.callBlock) {
        self.callBlock(self.btnDataSource[index]);
    }
}
-(void)creatImageBtn{
    CGFloat  height = IPHONE6WH(30);
    CGFloat  width = IPHONE6WH(78);
    CGFloat margin = (ScreenWidth-width*self.imageBtnsDataSource.count)/(self.imageBtnsDataSource.count+1);
    CGFloat  leftAndRight = margin;
    
    for (int i=0; i<self.imageBtnsDataSource.count; i++) {
        PVBannerModel* bannerModel = self.imageBtnsDataSource[i];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn sd_setImageWithURL:[NSURL URLWithString:bannerModel.bannerImage] forState:UIControlStateNormal];
        btn.sc_x = leftAndRight + (margin+width)*i;
        btn.sc_y = (60-height)*0.5+4;
        btn.sc_width = width;
        btn.sc_height = height;
//        btn.layer.borderWidth = 1.0f;
//        btn.layer.borderColor = [UIColor sc_colorWithHex:0x000000].CGColor;
//        btn.clipsToBounds = true;
//        btn.layer.cornerRadius = height*0.5;
        btn.tag = 200 + i;
        [_imageView addSubview:btn];
        [btn addTarget:self action:@selector(imageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)imageBtnClicked:(UIButton*)btn{
    NSInteger index = btn.tag - 200;
    if (self.callBlock) {
        self.callBlock(self.imageBtnsDataSource[index]);
    }
}
-(NSMutableArray *)btnDataSource{
    if (!_btnDataSource) {
        _btnDataSource  = [NSMutableArray array];
    }
    return _btnDataSource;
}
-(NSMutableArray *)imageBtnsDataSource{
    if (!_imageBtnsDataSource) {
        _imageBtnsDataSource = [NSMutableArray array];
    }
    return _imageBtnsDataSource;
}


@end
