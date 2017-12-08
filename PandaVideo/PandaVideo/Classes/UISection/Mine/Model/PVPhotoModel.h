//
//  PVPhotoModel.h
//  PandaVideo
//
//  Created by cara on 17/8/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVPhotoModel : NSObject

@property(nonatomic, strong)UIImage* image;
@property (nonatomic, copy) NSString *imageUrl;
@property(nonatomic, assign)BOOL isLast;

@end
