//
//  PVKeyBoardInputView.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PVKeyBoardInputViewDelegate <NSObject>
@required
/** 发送消息 */ 
- (void)keyBoardSendMessage:(NSString*)message withDanmu:(BOOL)danmu;
@optional
/** 键盘打开弹幕 */
- (void)keyBoardDanmuOpen;
/** 键盘关闭弹幕 */
- (void)keyBoardDanmuClose;


@end
typedef NS_ENUM(NSInteger,KeyBoardInputViewType){
    KeyBoardInputViewTypeNomal,
    KeyBoardInputViewTypeNoDanMu,
};

@interface PVKeyBoardInputView : UIView

- (id)initWityStyle:(KeyBoardInputViewType)type;

/** 编辑开始 */
- (void)editBeginTextField;
/** 编辑开始 */
- (void)editEndTextField;

@property (nonatomic,weak)id<PVKeyBoardInputViewDelegate>delegate;

@property (nonatomic, assign) BOOL isEdit;

@end
