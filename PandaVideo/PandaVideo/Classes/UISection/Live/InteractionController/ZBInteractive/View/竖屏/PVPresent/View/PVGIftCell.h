//
//  PVGIftCell.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPresentViewCell.h"
#import "PVPresentModel.h"

@interface PVGIftCell : PVPresentViewCell

@property (strong, nonatomic) PVPresentModel *presentmodel;

/** 背景圆角 */
@property (nonatomic, strong) UIView        *backView;
/** 背景图片 */
@property (nonatomic, strong) UIImageView   *backImageView;

/** 送礼物者头像 */
@property (nonatomic, strong) UIImageView   *iconImageView;

/** 送礼物者名 */
@property (nonatomic, strong) UILabel       *senderLabel;

/** 礼物名 */
@property (nonatomic, strong) UILabel       *giftLabel;

/** 礼物图片 */
@property (nonatomic, strong) UIImageView   *giftImageView;

@end
