//
//  PVPhotoSelectedViewController.h
//  PandaVideo
//
//  Created by cara on 17/8/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PVPhotoSelectedViewControllerBlock)(UIImage* image);

@interface PVPhotoSelectedViewController : UIViewController

-(void)setPVPhotoSelectedViewControllerBlock:(PVPhotoSelectedViewControllerBlock)block;

@end
