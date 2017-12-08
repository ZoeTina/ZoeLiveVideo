//
//  PVHistoryDetailModel.h
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVHistoryDetailModel : NSObject

///是否展开
@property(nonatomic, assign)BOOL isOpen;
///是否有用选中状态
@property(nonatomic, assign)BOOL isHelpStatus;
///是否无用选中状态
@property(nonatomic, assign)BOOL isUnlessStatus;

@end
