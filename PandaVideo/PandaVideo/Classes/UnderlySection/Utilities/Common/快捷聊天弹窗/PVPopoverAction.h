//
//  PVPopoverAction.h
//  PandaVideo
//
//  Created by Ensem on 2017/11/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PopoverViewStyle) {
    PopoverViewStyleDefault = 0, // 默认风格, 白色
    PopoverViewStyleDark, // 黑色风格
};

@interface PVPopoverAction : NSObject

/** 图标 (建议使用 60pix*60pix 的图片) */
@property (nonatomic, strong, readonly) UIImage *image;
/** 标题 */
@property (nonatomic, copy, readonly) NSString *title;
/** < 选择回调, 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.>*/
@property (nonatomic, copy, readonly) void(^handler)(PVPopoverAction *popoverAction);

/** 只有文字模式 */
+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(PVPopoverAction *popoverAction))handler;
/** 带有图标模式 */
+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(PVPopoverAction *action))handler;

@end

