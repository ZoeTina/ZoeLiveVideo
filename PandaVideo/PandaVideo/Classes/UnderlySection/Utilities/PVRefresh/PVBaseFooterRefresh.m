//
//  PVBaseFooterRefresh.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseFooterRefresh.h"

@implementation PVBaseFooterRefresh

- (instancetype)init
{
    if (self = [super init]) {
        self.stateLabel.hidden = YES;
//        self.state = MJRefreshStateNoMoreData;
    }
    return self;
}

@end
