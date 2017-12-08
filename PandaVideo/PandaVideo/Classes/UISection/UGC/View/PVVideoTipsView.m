//
//  PVVideoTipsView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVVideoTipsView.h"

@implementation PVVideoTipsView

- (instancetype)initUGCTipsViewWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *viewsArray = [[NSBundle mainBundle] loadNibNamed:@"PVVideoTipsView" owner:self options:nil];
        self.frame = frame;
        self = [viewsArray sc_safeObjectAtIndex:0];
    }
    return self;
}

- (void)setTipsText:(NSString *)tipsText {
    _tipsText = tipsText;
    self.tipsLabel.text = _tipsText;
}

@end
