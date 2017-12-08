//
//  PVBottomToolsView.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PVShowToolsViewDelegate <NSObject>

- (void) didShowToolsButtonClick:(UIButton *) sender;

@end
@interface PVBottomToolsView : UIView
//加载xib
+ (PVBottomToolsView *)bottomView;
@property (nonatomic, weak) id<PVShowToolsViewDelegate> delegate;  //实现代理

/** 回看情况下 */
@property (weak, nonatomic) IBOutlet UIView *videoBottomView;
/** 直播互动况下 */
@property (weak, nonatomic) IBOutlet UIView *toolsBottomView;
/** 回复消息 */
@property (weak, nonatomic) IBOutlet UIView *toolsMessageView;
//点赞
@property (weak, nonatomic) IBOutlet UIButton *liveBtnLike;

@property (weak, nonatomic) IBOutlet UILabel *textlabel;
@end
