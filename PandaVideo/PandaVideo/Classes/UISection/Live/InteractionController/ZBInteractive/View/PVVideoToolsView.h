//
//  PVVideoToolsView.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/6.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    
    LivingRoomBottomViewButtonClickTypeKnown,   // 未知
    LivingRoomBottomViewButtonClickTypeChat,    // 群聊
    LivingRoomBottomViewButtonClickTypeMessage, // 快捷消息
    LivingRoomBottomViewButtonClickTypeGift,    // 礼物
    LivingRoomBottomViewButtonClickTypeShare,   // 分享
    LivingRoomBottomViewButtonClickTypeThumb,   // 点赞
    LivingRoomBottomViewButtonClickTypeWheat,   // 连麦
    LivingRoomBottomViewButtonClickTypeBack     // 返回
    
}LivingRoomBottomViewButtonClickType;

@protocol PVShowLiveBottomToolsViewDelegate <NSObject>

- (void) didShowLiveBottomToolsButtonClick:(UIButton *) sender;

@end

@interface PVVideoToolsView : UIView
//HorizontallyScreen
//VerticalScreen



// 加载xib(直播的UI)
/** 横屏底部工具栏 */
+ (PVVideoToolsView *)bottomViewHorizontallyScreen;

/** 横屏顶部工具栏 */
+ (PVVideoToolsView *)topViewHorizontallyScreen;


/** 竖屏底部工具栏 */
+ (PVVideoToolsView *)bottomViewVerticalScreen;

/** 竖屏顶部工具栏 */
+ (PVVideoToolsView *)topViewVerticalScreen;


/**
 *  加载xib中的view工具栏
 *
 *  @param index 加载第几个View
 *  @return 返回View
 */
+ (PVVideoToolsView *)loadLiveXibView:(NSInteger)index;

@property (nonatomic, weak) id<PVShowLiveBottomToolsViewDelegate> delegate;  //实现代理

@property (nonatomic, copy) void (^buttonClick)(NSInteger tag);

@end
