//
//  PVVideoDefinitionView.h
//  VideoDemo
//
//  Created by cara on 17/8/16.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVLiveTelevisionChanelListModel.h"
#import "PVIntroduceModel.h"


typedef void(^PVVideoDefinitionViewBlock)(PVLiveTelevisionChanelListModel* chanelListModel);
typedef void(^PVIntroduceDefinitionViewBlock)(PVIntroduceModel *introduceModel);

@interface PVVideoDefinitionView : UIView

@property(nonatomic, strong)PVLiveTelevisionChanelListModel* chanelListModel;
@property(nonatomic, strong)PVIntroduceModel* introduceModel;

-(void)setPVVideoDefinitionViewBlock:(PVVideoDefinitionViewBlock)block;
-(void)setPVIntroduceViewBlock:(PVIntroduceDefinitionViewBlock)block;



@end
