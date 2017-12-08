//
//  PVCommentHeadTable.h
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVFindHomeModel.h"

typedef void (^ImageViewClickedBlock) (NSInteger index);

@interface PVCommentHeadTable : UIView

@property(nonatomic, strong)PVFindHomeModel* findHomeModel;

@property (weak, nonatomic) IBOutlet UIView *commentContainerView;
-(void) setImageViewClickedBlock:(ImageViewClickedBlock)block;

@end
