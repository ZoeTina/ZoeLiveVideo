//
//  PVBarrageCell.m
//  PandaVideo
//
//  Created by cara on 17/8/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBarrageCell.h"
#import "BarrageModel.h"
#import "BarrageView.h"


@interface PVBarrageCell()

@property(nonatomic, strong)UILabel*  message;

@end

@implementation PVBarrageCell


- (instancetype)initWithIdentifier:(NSString *)identifier
{
    if (self = [super init]) {
        
        self.message = [[UILabel alloc]  init];
        self.message.textColor = [UIColor whiteColor];
        self.message.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.message];
        
        [self.message  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self);
        }];
        
    }
    return self;
}

+ (instancetype)cellWithBarrageView:(BarrageView *)barrageView
{
    static NSString *reuseIdentifier = @"CustomCell";
    PVBarrageCell *cell = [barrageView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[PVBarrageCell alloc] initWithIdentifier:reuseIdentifier];
    }
    return cell;
}

- (void)setModel:(BarrageModel *)model{
    _model = model;
    self.message.text = model.message;
}


@end
