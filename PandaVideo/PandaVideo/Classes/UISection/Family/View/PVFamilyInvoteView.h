//
//  PVFamilyInvoteView.h
//  PandaVideo
//
//  Created by cara on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVFamilyInvoteModel.h"
typedef void(^PVFamilyInvoteViewBlock)(NSInteger index);


@interface PVFamilyInvoteView : UIView


@property(nonatomic,strong)PVFamilyInvoteListModel * model;
-(void)setPVFamilyInvoteViewBlock:(PVFamilyInvoteViewBlock)block;

@end
