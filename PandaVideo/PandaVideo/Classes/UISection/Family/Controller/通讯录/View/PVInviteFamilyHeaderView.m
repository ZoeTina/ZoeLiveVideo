//
//  PVInviteFamilyHeaderView.m
//  PandaVideo
//
//  Created by Ensem on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInviteFamilyHeaderView.h"

@interface PVInviteFamilyHeaderView ()

@end

@implementation PVInviteFamilyHeaderView

- (instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void) initUI{
    
    // 圆角设置
    [self.inviteBtn setBordersWithColor:kColorWithRGB(42, 180, 228)
                           cornerRadius:self.inviteBtn.sc_height/2
                            borderWidth:0.5];
}

+ (PVInviteFamilyHeaderView *)headerView {
    return [[[NSBundle mainBundle] loadNibNamed:@"PVInviteFamilyHeaderView" owner:nil options:nil] lastObject];
}

@end
