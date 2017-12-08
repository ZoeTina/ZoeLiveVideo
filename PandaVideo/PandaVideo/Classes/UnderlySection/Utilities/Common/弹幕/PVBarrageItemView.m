//
//  PVBarrageItemView.m
//  PandaVideo
//
//  Created by Ensem on 2017/11/9.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBarrageItemView.h"

@interface PVBarrageItemView () {
    CGFloat lzSpeed;
    CGFloat lzCurDistance;
}

@property (nonatomic, strong) UILabel *detailLabel;

@end


@implementation PVBarrageItemView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.maxWidth = 360;
        [self addSubview:self.detailLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _detailLabel.frame = self.bounds;
}

- (void)dealloc {
    
}

#pragma mark - setter and getter

- (void)setIsSelfDanmu:(BOOL)isSelfDanmu{
    _isSelfDanmu = isSelfDanmu;
}

- (void)setDetail:(NSString *)detail {
    if ([_detail isEqualToString:detail] == NO) {
        _detail = detail;
        if (self.isSelfDanmu) {
            // 下划线
            NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
            NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:detail attributes:attribtDic];
            _detailLabel.attributedText = attribtStr;
        }else{
            _detailLabel.text = detail;
        }
        CGSize size = [_detailLabel sizeThatFits:CGSizeMake(_maxWidth, 20)];
        self.bounds = CGRectMake(0, 0, size.width, size.height);
    }
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = kColorWithRGB(255, 255, 255);
        textLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel = textLabel;
    }
    return _detailLabel;
}

- (void)setDetailColor:(UIColor *)detailColor {
    _detailColor = detailColor;
    _detailLabel.textColor = detailColor;
}

- (void)setSpeed:(CGFloat)speed {
    lzSpeed = speed;
}

- (CGFloat)speed {
    return lzSpeed;
}

- (void)setCurDistance:(CGFloat)curDistance {
    lzCurDistance = curDistance;
}

- (CGFloat)curDistance {
    return lzCurDistance;
}

@end
