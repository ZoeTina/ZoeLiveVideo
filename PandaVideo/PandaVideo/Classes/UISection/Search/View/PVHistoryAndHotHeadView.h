//
//  PVHistoryAndHotHeadView.h
//  PandaVideo
//
//  Created by cara on 17/7/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClearClickedBlock)();


@interface PVHistoryAndHotHeadView : UICollectionReusableView

@property(nonatomic, assign)NSInteger item;


-(void)setClearClickedCallBlock:(ClearClickedBlock)clearClickedBlock;

@end