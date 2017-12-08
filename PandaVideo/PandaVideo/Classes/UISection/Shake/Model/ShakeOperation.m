//
//  ShakeOperation.m
//  BuyBuyAllChangeToNewVersion
//
//  Created by buybuyall on 16/4/20.
//  Copyright © 2016年 cara. All rights reserved.
//

#import "ShakeOperation.h"

@implementation ShakeOperation

-(void)main
{
    self.time = self.time?self.time:0.2;
[NSThread sleepForTimeInterval:self.time];
   
    if (self.cancelSelf) {
        return;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(startShakeAnimate)]){
        
        [self.delegate startShakeAnimate];
    }

}

@end
