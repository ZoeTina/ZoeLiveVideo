//
//  PVSendGiftView.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVGiftViewCell.h"
#import "PVGiftGivingViewController.h"

@protocol LZSendGiftDelegate <NSObject>

/** 代理 */
-(void)sendGiftButtonOnClick:(UIButton *)sender;

@end

@interface PVSendGiftView : UIView<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    UIPageControl *_pageControl;
    //礼物标记
    NSInteger _reuse;
}

/** 礼物栏 */
@property (nonatomic, strong) UICollectionView *giftCollectionView;

/** 底部充值  发送 */
@property (nonatomic, strong) UIView *rechargeView;

/** 充值按钮 */
@property (nonatomic, strong) UIButton *rechargeButton;

/** 发送礼物按钮 */
@property (nonatomic, strong) UIButton *senderButton;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, copy) void (^giftClick)(NSInteger tag);

@property (nonatomic, copy) void (^grayClick)();

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) CGFloat lzHeight;

- (void)popShow;


/**
 *  设置代理
 */
@property(nonatomic,assign)id<LZSendGiftDelegate>delegate;

@end
