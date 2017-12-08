//
//  PVTelevisionCloudView.h
//  PandaVideo
//
//  Created by cara on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PVTelevisionCloudViewCallBlock)(BOOL isTelevisionCloud);


@interface PVTelevisionCloudView : UIView

/** 电视播放按钮 */
@property (nonatomic, strong)UIButton   *televisionPlayBtn;
/** 添加至电视云看单按钮 */
@property (nonatomic, strong)UIButton   *addTelevisionCloudBtn;


-(void)setPVTelevisionCloudViewCallBlock:(PVTelevisionCloudViewCallBlock)block;

@end
