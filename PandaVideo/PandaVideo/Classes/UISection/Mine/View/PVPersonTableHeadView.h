//
//  PVPersonTableHeadView.h
//  PandaVideo
//
//  Created by cara on 17/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PVPersonTableHeadViewBlock) ();

@interface PVPersonTableHeadView : UIView

-(void)setPersonTableHeadViewBlock:(PVPersonTableHeadViewBlock)block;

@end
