//
//  SCPhotoModels.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/9/3.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface SCPhotoModels : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) UIImage *image;

@end
