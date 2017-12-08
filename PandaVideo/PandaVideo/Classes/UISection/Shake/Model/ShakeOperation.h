//
//  ShakeOperation.h
//  BuyBuyAllChangeToNewVersion
//
//  Created by buybuyall on 16/4/20.
//  Copyright © 2016年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ShakeOperationDegate <NSObject>

-(void)startShakeAnimate;

@end

@interface ShakeOperation : NSOperation

@property(nonatomic,assign)CGFloat time;
@property(nonatomic,assign)BOOL cancelSelf;
@property(nonatomic,weak)id<ShakeOperationDegate> delegate;

@end
