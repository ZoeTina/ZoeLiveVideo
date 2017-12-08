//
//  PVNoDataView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVNoDataView.h"

@interface PVNoDataView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *tips;
@end

@implementation PVNoDataView

- (instancetype)initWithFrame:(CGRect)frame ImageName:(NSString *)imagename tipsLabelText:(NSString *)tips {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PVNoDataView" owner:self options:nil] lastObject];
//        self.bounds = frame;
//        self.sc_width = kScreenWidth;
//        self.sc_height = kScreenHeight;
        self.frame = frame;
        self.iconImageView.image = [UIImage imageNamed:imagename];
        self.tipsLabel.text = tips;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
    
}


@end
