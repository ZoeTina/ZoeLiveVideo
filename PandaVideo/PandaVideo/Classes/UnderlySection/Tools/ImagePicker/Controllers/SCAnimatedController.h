//
//  SCAnimatedController.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/8/17.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ModalOperation) {
    ModalOperationPresentation,
    ModalOperationDismissal,
};

@interface SCAnimatedController : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithType:(ModalOperation)type;

@end
