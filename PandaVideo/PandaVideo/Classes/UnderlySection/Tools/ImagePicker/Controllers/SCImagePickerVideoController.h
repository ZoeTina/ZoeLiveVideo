//
//  SCImagePickerVideoController.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/8/5.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCAssetModel;
@class PVUGCModel;
@interface SCImagePickerVideoController : UIViewController

@property (nonatomic, strong) SCAssetModel *model;
@property (nonatomic, strong) PVUGCModel *ugcModel;

@property (nonatomic, assign) BOOL isImagePickerPreView;

@property (nonatomic, copy) NSString *videoUrlString;

@property(nonatomic,copy)void(^popViewblock)(void);
@end
