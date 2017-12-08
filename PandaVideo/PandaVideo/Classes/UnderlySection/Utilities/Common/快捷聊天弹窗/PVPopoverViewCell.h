//
//  PVPopoverViewCell.h
//  PandaVideo
//
//  Created by Ensem on 2017/11/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVPopoverAction.h"

UIKIT_EXTERN float const PopoverViewCellHorizontalMargin; ///< 水平间距边距
UIKIT_EXTERN float const PopoverViewCellVerticalMargin; ///< 垂直边距
UIKIT_EXTERN float const PopoverViewCellTitleLeftEdge; ///< 标题左边边距

@interface PVPopoverViewCell : UITableViewCell

@property (nonatomic, assign) PopoverViewStyle style;

/*! @brief 标题字体
 */
+ (UIFont *)titleFont;

/*! @brief 底部线条颜色
 */
+ (UIColor *)bottomLineColorForStyle:(PopoverViewStyle)style;

- (void)setAction:(PVPopoverAction *)action;

- (void)showBottomLine:(BOOL)show;

@end

