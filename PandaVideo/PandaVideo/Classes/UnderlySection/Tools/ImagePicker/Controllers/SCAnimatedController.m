//
//  SCAnimatedController.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/8/17.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "SCAnimatedController.h"

@interface SCAnimatedController () <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) ModalOperation type;

@end

@implementation SCAnimatedController

- (instancetype)initWithType:(ModalOperation)type {
    self.type = type;
    return [self init];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    CGFloat translation = containerView.frame.size.width;
    CGAffineTransform fromTransform = CGAffineTransformIdentity;
    CGAffineTransform toTransform = CGAffineTransformIdentity;

    translation = containerView.frame.size.height;
    CGFloat fromTy = self.type == ModalOperationPresentation ? 0 : translation;
    CGFloat toTy = self.type == ModalOperationPresentation ? translation : 0;
    
    fromTransform = CGAffineTransformMakeTranslation(0, fromTy);
    toTransform = CGAffineTransformMakeTranslation(0, toTy);
    
    switch (self.type) {
        case ModalOperationPresentation: {
            [containerView addSubview:toView];
        }
            break;
        default:
            break;
    }
    
    toView.transform = toTransform;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.transform = fromTransform;
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformIdentity;
        
        BOOL isCancelled = transitionContext.transitionWasCancelled;
        [transitionContext completeTransition:!isCancelled];
    }];
}

@end
