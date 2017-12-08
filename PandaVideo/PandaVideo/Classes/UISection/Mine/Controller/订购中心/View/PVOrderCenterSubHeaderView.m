//
//  PVOrderCenterSubHeaderView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVOrderCenterSubHeaderView.h"

@interface PVOrderCenterSubHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


@end

@implementation PVOrderCenterSubHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PVOrderCenterSubHeaderView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
    
    if ([_title rangeOfString:@"特权"].location != NSNotFound) {
        self.protocolLabel.hidden = YES;
        self.iconImageView.hidden = YES;
    }else {
        self.protocolLabel.hidden = NO;
        self.iconImageView.hidden = NO;
    }
}

@end
