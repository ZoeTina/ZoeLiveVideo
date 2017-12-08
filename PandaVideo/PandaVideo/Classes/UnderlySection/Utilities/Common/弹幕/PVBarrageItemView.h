//
//  PVBarrageItemView.h
//  PandaVideo
//
//  Created by Ensem on 2017/11/9.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVBarrageProtocol.h"
#import "UIView+FrameChange.h"

@interface PVBarrageItemView : UIView<PVBarrageItemProtocol>

/** default = 360 */
@property (nonatomic, assign) NSInteger maxWidth;
/** 文字内容 */
@property (nonatomic, strong) NSString  *detail;
/** 文字颜色 */
@property (nonatomic, strong) UIColor   *detailColor;
/** 是否为自己发送的弹幕 */
@property (nonatomic, assign) BOOL      isSelfDanmu;

@end
