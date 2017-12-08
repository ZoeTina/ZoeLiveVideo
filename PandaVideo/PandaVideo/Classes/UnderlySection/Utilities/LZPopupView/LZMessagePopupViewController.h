//
//  LZMessagePopupViewController.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LZViewTypeLocation = 0, // 位置授权
    LZViewTypeUpdate,       // 版本更新
    LZViewTypeNotice,       // 开启通知
} LZViewType;

@protocol LZPopupViewDelegate;

@interface LZMessagePopupViewController : UIViewController

@property (assign, nonatomic) id <LZPopupViewDelegate>delegate;

@property (copy, nonatomic) NSString *titleStr;     // 标题文字
@property (copy, nonatomic) NSString *messageStr;   // 消息内容
@property (copy, nonatomic) NSString *btnTxtStr;    // 按钮文字
@property (assign, nonatomic) LZViewType  lzViewType; // 视图类型

@property (copy, nonatomic) UIImage  *imageBtn;     // 视图类型

@end


@protocol LZPopupViewDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(LZMessagePopupViewController *)secondDetailViewController;
- (void)dismissedButtonClicked:(LZMessagePopupViewController *)secondDetailViewController;
@end
