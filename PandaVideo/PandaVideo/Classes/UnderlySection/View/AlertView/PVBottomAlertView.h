//
//  PVBottomAlertView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PVBottomAlertViewDelegate <NSObject>
- (void)PVBottomAlertViewCancleButtonClick;
@end

@interface PVBottomAlertView : UIView
@property (nonatomic, weak) id<PVBottomAlertViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame ImagesArray:(NSArray *)imagesArray textsArray:(NSArray *)imagesNameArray;
@end
