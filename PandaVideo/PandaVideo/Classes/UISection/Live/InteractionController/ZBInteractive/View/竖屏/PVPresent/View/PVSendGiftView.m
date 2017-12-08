//
//  PVSendGiftView.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSendGiftView.h"
#import "PVFlowLayout.h"

#define GifGetY kScreenHeight - 100

@implementation PVSendGiftView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    YYLog(@"self.lzHeight -- %f",self.lzHeight);
//    [self.rechargeView addSubview:self.pageControl];
    [self addSubview:self.giftCollectionView];
    [self addSubview:self.pageControl];
//    [self.rechargeView addSubview:self.rechargeButton];
//    [self.rechargeView addSubview:self.senderButton];
}

/** 弹出礼物 */
- (void)popShow{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

/** 点击上方灰色区域移除视图 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:self];
    if ( point.y < GifGetY) {
        if (self.grayClick) {
            self.grayClick();
        }
        [self removeFromSuperview];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    self.pageControl.currentPage = page;
}

#pragma
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PVGiftViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PVGiftViewCell" forIndexPath:indexPath];
    if (self.dataArr.count > 0) {
        cell.giftImageView.image = [UIImage imageNamed:self.dataArr[indexPath.row]];
        cell.clickBtn.tag = indexPath.row;
//        [cell.clickBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            [self giftBtnOnClick:indexPath.row];
//        }];
        [cell.clickBtn addTarget:self action:@selector(giftBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        YYLog(@"点到了吗？%ld",(long)cell.clickBtn.tag);

        if (_reuse == indexPath.row) {
            cell.hitButton.selected = YES;
        } else {
            cell.hitButton.selected = NO;
        }
         [cell hitButtonBorderIsSelected];
    }
    return cell;
}

- (void) giftBtnOnClick:(UIButton *)sender{
    _reuse = sender.tag;
    YYLog(@"点到了吗？");
    [self lz_make:[NSString stringWithFormat:@"当前选择的ID：%ld",(long)sender.tag]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PVGiftViewCell *cell = (PVGiftViewCell *)[self.giftCollectionView cellForItemAtIndexPath:indexPath];
    if (!cell.hitButton.selected) {
        for (UIView *view in self.giftCollectionView.subviews) {
            //遍历所有cell，重置为未连击状态
            if ([view isKindOfClass:[PVGiftViewCell class]]) {
                PVGiftViewCell *cell = (PVGiftViewCell *)view;
                cell.hitButton.selected = NO;
                [cell hitButtonBorderIsSelected];
            }
        }
        cell.hitButton.selected = YES;
        [cell hitButtonBorderIsSelected];
        // 可以发送礼物
        self.senderButton.backgroundColor = kColorWithRGB(36, 215, 200);
        self.senderButton.enabled = YES;
        _reuse = indexPath.row;
    } else {
        cell.hitButton.selected = NO;
        [cell hitButtonBorderIsSelected];
        // 未有选中，禁用发送按钮
        self.senderButton.backgroundColor = [UIColor grayColor];
        self.senderButton.enabled = NO;
        _reuse = 100;
        return;
    }
}

#pragma 加载
/** 滑动 */
- (UICollectionView *)giftCollectionView{
    if (!_giftCollectionView) {
        PVFlowLayout *flowLay = [[PVFlowLayout alloc] init];
        flowLay.minimumLineSpacing = 0;
        flowLay.minimumInteritemSpacing = 0;
        flowLay.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLay.itemSize = CGSizeMake(kScreenWidth/3, 110);
        flowLay.sectionInset = UIEdgeInsetsMake(25, 12, 25, 12);
        flowLay.minimumInteritemSpacing = 6.f;
        flowLay.minimumLineSpacing      = 6.f;
        flowLay.itemSize = CGSizeMake((YYScreenWidth - 12*2 - 6*2)/3 , 110);
        
        _giftCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, GifGetY, kScreenWidth, 400) collectionViewLayout:flowLay];
        _giftCollectionView.backgroundColor = kColorWithRGBA(242, 242, 242, 1.0);//kColorWithRGBA(0, 0, 0, 0.3);
        _giftCollectionView.bounces = NO;
        _giftCollectionView.delegate = self;
        _giftCollectionView.dataSource = self;
        _giftCollectionView.pagingEnabled = YES;
        _giftCollectionView.showsVerticalScrollIndicator = NO;
        _giftCollectionView.showsHorizontalScrollIndicator = NO;
        [_giftCollectionView registerClass:[PVGiftViewCell class] forCellWithReuseIdentifier:@"PVGiftViewCell"];
    }
    return _giftCollectionView;
}

/** 底部 */
- (UIView *)rechargeView{
    if (!_rechargeView) {
    
        _rechargeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sc_height - 60, kScreenWidth, 60)];
        _rechargeView.backgroundColor = kColorWithRGBA(255, 255, 255, 1.0);//kColorWithRGBA(0, 0, 0, 0.6);
    }
    return _rechargeView;
}

/** 充值(按钮)*/
- (UIButton *)rechargeButton{
    if (!_rechargeButton) {
//        _rechargeButton = [MyControlTool buttonWithText:@"充值" textColor:RGB(249, 179, 61) font:17 tag:0 frame:CGRectMake(0, 0, 100, 60) clickBlock:^(id x) {
//        }];
        
    }
    return _rechargeButton;
}

/** 发送礼物(按钮)*/
- (UIButton *)senderButton{
    if (!_senderButton) {
        _senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _senderButton.frame = CGRectMake(kScreenWidth - 70, 17, 60, 26);
        _senderButton.tag = 0;
        [_senderButton setTitle:@"发送" forState:UIControlStateNormal];
        [_senderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _senderButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _senderButton.layer.cornerRadius = 12;
        _senderButton.layer.masksToBounds = YES;
        [_senderButton setBackgroundColor:kColorWithRGB(36, 215, 200)];
        [_senderButton addTarget:self action:@selector(sendGiftOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _senderButton;
}

- (void) sendGiftOnClick:(UIButton *)sender{
    YYLog(@"送礼物");
    if(self.delegate && [self.delegate respondsToSelector:@selector(sendGiftButtonOnClick:)]){
        [self.delegate sendGiftButtonOnClick:sender];
    }
}

/** 分页 */
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 20, 5, 40, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 3;
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    }
    return _pageControl;
}

/** 礼物图片(数据) */
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 24; i++) {
            NSString *imagePath=[NSString stringWithFormat:@"yipitiezhiNormal.bundle/yipitiezhi0%zd",i + 1];
            [_dataArr addObject:imagePath];
        }
    }
    return _dataArr;
}

@end
