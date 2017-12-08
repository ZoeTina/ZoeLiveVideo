//
//  PVDemandTableFootView.m
//  PandaVideo
//
//  Created by cara on 17/8/2.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDemandTableFootView.h"


@interface PVDemandTableFootView()

@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;

@property (nonatomic, copy)PVDemandTableFootViewBlock footViewBlock;


@end


@implementation PVDemandTableFootView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupUI];
    
}
-(void)setupUI{
    
    UIView* bgView = [[UIView alloc]  init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self insertSubview:bgView atIndex:0];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapGestureClicked)];
    [self addGestureRecognizer:tapGesture];
}

-(void)tapGestureClicked{
    if (self.footViewBlock) {
        self.footViewBlock();
    }
}

-(void)setType:(NSInteger)type{
    
    _type = type;
    
    if (type == 1) {
        self.moreLabel.text = @"查看更多";
        self.moreImageView.image = [UIImage imageNamed:@"home2_btn_enter_blue"] ;
    }else if (type == 2){
        self.moreLabel.text = @"更多精彩  ";
        self.moreImageView.image = [UIImage imageNamed:@"search_btn_more"] ;
    }
}


-(void)setPVDemandTableFootViewBlock:(PVDemandTableFootViewBlock)block{
    self.footViewBlock = block;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 3;
    [super setFrame:frame];
}
@end
