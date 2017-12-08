//
//  PVColumnEditCell.m
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVColumnEditCell.h"

@interface PVColumnEditCell()

@property(nonatomic, strong)UIImageView* columnImageView;

@end

@implementation PVColumnEditCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self.contentView addSubview:self.backView];
        
        UIImageView* columnImageView = [[UIImageView alloc] init];
//        columnImageView.contentMode = UIViewContentModeScaleAspectFill;
        columnImageView.frame = CGRectMake((frame.size.width-50)*0.5, 15, 50, 50);
        self.columnImageView = columnImageView;
        [self.backView addSubview:columnImageView];
        
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.sc_width-20,0, 20, 20)];
        _cellImage.contentMode = UIViewContentModeCenter;
        [self.backView addSubview:_cellImage];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (self.sc_height-20)-5, self.sc_width, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:self.titleLabel];
                
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapGestureClicked:)];
        [self addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]  initWithTarget:self action:@selector(longPressGesture:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

-(void)setModel:(PVHomModel *)model{
    self.cellImage.image = [UIImage imageNamed:model.imgStr];
    self.titleLabel.text = model.columName;
    self.cellImage.hidden = !model.isSelect;
    [self.columnImageView sd_setImageWithURL:[NSURL URLWithString:model.columnIcon] placeholderImage:nil];
}

-(void)tapGestureClicked:(UITapGestureRecognizer*)tapGesture{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressCellWithRecognizer:)]) {
        [self.delegate pressCellWithRecognizer:self];
    }
}

-(void)longPressGesture:(UILongPressGestureRecognizer*)longGesture{
    if (self.delegate && [self.delegate respondsToSelector:@selector(moveCellWithRecognizer:sender:)]) {
        [self.delegate moveCellWithRecognizer:self sender:longGesture];
    }
}

@end
