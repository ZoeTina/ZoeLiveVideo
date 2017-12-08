//
//  PVUploadCellSmallView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVUploadCellSmallView : UIView

- (instancetype)initUploadStateViewWithUploading;

- (instancetype)initUploadStateViewWithProcessing;

- (instancetype)initUploadStateViewWithRePublish;

- (instancetype)initUploadStateViewWithFailure;

@end
