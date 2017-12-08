//
//  LZPlayerView.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "LZPlayControllerView.h"

typedef NS_ENUM(NSUInteger, LZDirection) {
    LZDirectionLeftOrRight,
    LZDirectionUpOrDown,
    LZDirectionNone
};


typedef NS_ENUM(NSInteger,LZDScreenDirection) {
    LZDScreenDirectionHorizontal,//横屏
    LZDScreenDirectionVertical,  //竖屏
};


@interface LZPlayerView : UIView

@property (atomic, strong) NSURL *url;

@property (nonatomic, strong) LZPlayControllerView *playControllerView;

@property (atomic, retain) id <IJKMediaPlayback> player;

/** 版权问题 */
@property(nonatomic, assign)BOOL isCopyRight;

-(instancetype)initWithDelegate:(id<LZVideoPlayerViewDelegate>)delegate Url:(NSURL*)url Type:(NSInteger)type;
/** 切换当前播放的内容 */
- (void)changeCurrentplayerItemWithVideoModel:(NSString *) URLString;

@end
