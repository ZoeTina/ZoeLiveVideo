//
//  PVImageAndTextView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVAlertModel.h"

@protocol PVImageAndTextViewDelegate <NSObject>
- (void)imageAndTextCancelButtonClick;
- (void)imageAndTextSureButtonClick;
@end

@interface PVImageAndTextView : UIView
@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *descript;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) ImagePosition imagePosition;

@property (nonatomic, weak) id<PVImageAndTextViewDelegate>delegate;

- (instancetype)initImageAndTextViewWithFrame:(CGRect)frame;
- (void)initCancelButtonName:(NSString *)cancelName eventButtonName:(NSString *)eventName;

@end
