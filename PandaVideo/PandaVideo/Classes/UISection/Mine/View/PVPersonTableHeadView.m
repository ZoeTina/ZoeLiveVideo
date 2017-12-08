//
//  PVPersonTableHeadView.m
//  PandaVideo
//
//  Created by cara on 17/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVPersonTableHeadView.h"
#import "UIButton+YYWebImage.h"

@interface PVPersonTableHeadView()


@property (weak, nonatomic) IBOutlet UIButton *headImageBtn;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (nonatomic, copy) PVPersonTableHeadViewBlock headViewBlock;

@end


@implementation PVPersonTableHeadView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.headImageBtn.layer.cornerRadius = 25;
    self.headImageBtn.clipsToBounds = true;
    
    [[PVUserModel shared] load];
    
    if ([PVUserModel shared].userId.length == 0) {
        self.nickNameLabel.text = @"点击登陆";
        [self.headImageBtn setImage:[UIImage imageNamed:@"mine_icon_avatar"] forState:UIControlStateNormal];
    }else {
        if ([PVUserModel shared].baseInfo.avatar.length > 0) {
            [self.headImageBtn yy_setImageWithURL:[NSURL URLWithString:[PVUserModel shared].baseInfo.avatar] forState:UIControlStateNormal options:YYWebImageOptionIgnoreDiskCache];
        }else {
            [self.headImageBtn setImage:[UIImage imageNamed:@"mine_icon_avatar"] forState:UIControlStateNormal];
        }
        
        self.nickNameLabel.text = [PVUserModel shared].baseInfo.nickName;
    }
    
}
- (void)setFrame:(CGRect)frame {
    frame.size.height -= 2;
    [super setFrame:frame];
}

-(void)setPersonTableHeadViewBlock:(PVPersonTableHeadViewBlock)block{
    self.headViewBlock = block;
}

- (IBAction)headImageBtnClicked:(id)sender {
    if (self.headViewBlock) {
        self.headViewBlock();
    }
}

@end
