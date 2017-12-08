//
//  PVNoLoginFamilyView.m
//  PandaVideo
//
//  Created by cara on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVNoLoginFamilyView.h"

@interface PVNoLoginFamilyView()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;


@end



@implementation PVNoLoginFamilyView

-(void)awakeFromNib{
    [super awakeFromNib];
    UIImage *image = [UIImage imageNamed:@"duihuakuang"];
    self.bgImageView.image = [image stretchableImageWithLeftCapWidth:16 topCapHeight:20];
    if(1){
        NSString* str = @"先登录看看, 可能有家人已经邀请你了哟";
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor sc_colorWithHex:0xFF8C46] range:NSMakeRange(1, 2)];
        self.reminderLabel.attributedText = noteStr;
    }
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapGestureClicked)];
    [self addGestureRecognizer:tapGesture];
}

-(void)tapGestureClicked{
    if (self.comeOnLoginBlock) {
        self.comeOnLoginBlock();
    }
}

- (void)setIsLogin:(BOOL)isLogin{
    _isLogin = isLogin;
    if (isLogin) {
        NSString* str = @"暂时没有邀请，没关系你可以邀请他们呀";
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
//        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor sc_colorWithHex:0xFF8C46] range:NSMakeRange(1, 2)];
        self.reminderLabel.attributedText = noteStr;
        self.iconImageView.image = [UIImage imageNamed:@"biaoqing"];
    }else{
        NSString* str = @"先登录看看, 可能有家人已经邀请你了哟";
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor sc_colorWithHex:0xFF8C46] range:NSMakeRange(1, 2)];
        self.reminderLabel.attributedText = noteStr;
        self.iconImageView.image = [UIImage imageNamed:@"biaoqing2"];
    }
}
@end
