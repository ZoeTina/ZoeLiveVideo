//
//  PVGiftViewCell.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiParamButton.h"

@interface PVGiftViewCell : UICollectionViewCell

/** 礼物图片 */
@property (nonatomic, strong) UIImageView *giftImageView;
/** 连击(选中按钮) */
@property (nonatomic, strong) UIButton *hitButton;
/** 礼物金额 */
@property (nonatomic, strong) UILabel *moneyLabel;
/** 礼物名称 */
@property (nonatomic, strong) UILabel *giftNameLabel;
/** 钱币图标 */
@property (nonatomic, strong) UIImageView *iconImage;


/** 是否为横竖屏 */
@property (nonatomic, assign) BOOL isFullScreen;

/** 连击(选中按钮) */
@property (nonatomic, strong) MultiParamButton *clickBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)hitButtonBorderIsSelected;
@end


@interface MultiParamButtons : UIButton

@property (nonatomic, strong) NSDictionary *multiParamDic;

@end
