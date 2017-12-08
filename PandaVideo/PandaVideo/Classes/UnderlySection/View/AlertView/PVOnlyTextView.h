//
//  PVOnlyTextView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PVOnlyTextViewDelegate <NSObject>

@optional
- (void)onlyTextViewCancelButtonClick;
- (void)onlyTextViewSureButtonClick;

@end

@interface PVOnlyTextView : UIView
@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *descript;

@property (nonatomic, weak) id<PVOnlyTextViewDelegate>delegate;

- (instancetype)initOnlyTextViewWithFrame:(CGRect)frame;
- (void)initCancelButtonName:(NSString *)cancelName eventButtonName:(NSString *)eventName;


@end
