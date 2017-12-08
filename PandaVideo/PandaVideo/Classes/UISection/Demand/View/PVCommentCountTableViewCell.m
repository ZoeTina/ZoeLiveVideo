//
//  PVCommentCountTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/2.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVCommentCountTableViewCell.h"

@implementation PVCommentCountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y  += 3;
    frame.size.height -= 4;
    [super setFrame:frame];
}
@end
