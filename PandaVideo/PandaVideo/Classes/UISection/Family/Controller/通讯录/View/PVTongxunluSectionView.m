//
//  PVTongxunluSectionView.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTongxunluSectionView.h"

@implementation PVTongxunluSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = kColorWithRGB(252, 252, 252);
        self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth-24, 27)];
        self.labelTitle.font = [UIFont systemFontOfSize:15];
        self.labelTitle.textColor = kColorWithRGB(0, 0, 0);
        self.labelTitle.textAlignment = NSTextAlignmentLeft;
        self.labelTitle.text = @"#";
        [self addSubview:self.labelTitle];
    }
    return self;
}

@end
