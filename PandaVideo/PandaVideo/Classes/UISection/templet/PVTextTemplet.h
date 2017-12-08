//
//  PVTextTemplet.h
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVBannerModel.h"


typedef void(^PVTextTempletCallBlock)(PVBannerModel* bannerModel);

@interface PVTextTemplet : UIView


@property(nonatomic, strong)NSMutableArray* scrollTexts;

-(instancetype)initWithScrollTexts:(NSMutableArray*)scrollTexts;

-(void)setPVTextTempletCallBlock:(PVTextTempletCallBlock)block;

@end
