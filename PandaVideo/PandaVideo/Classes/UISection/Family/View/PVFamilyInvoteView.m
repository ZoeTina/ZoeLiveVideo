//
//  PVFamilyInvoteView.m
//  PandaVideo
//
//  Created by cara on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyInvoteView.h"

@interface PVFamilyInvoteView ()

@property (weak, nonatomic) IBOutlet UIImageView *familyImageView; //群头像

@property (weak, nonatomic) IBOutlet UILabel *familyHoneLabel; //群名称

@property (weak, nonatomic) IBOutlet UILabel *familyNameLabel; //验证信息
@property (weak, nonatomic) IBOutlet UILabel *familyNickNameLabel; //邀请人

@property(nonatomic, copy)PVFamilyInvoteViewBlock callBlock;

@end


@implementation PVFamilyInvoteView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.clipsToBounds = true;
    self.layer.cornerRadius = 40;
    
}

- (void)setModel:(PVFamilyInvoteListModel *)model{
    _model  = model;
//    [self.familyImageView sc_setImageWithUrlString:@"" placeholderImage:[UIImage imageNamed:@"invite1"] isAvatar:NO];
    self.familyHoneLabel.text = model.familyName;
    self.familyNameLabel.text = model.verifyMsg;
    self.familyNickNameLabel.text = [NSString stringWithFormat:@"来自：%@",model.inviteUserName] ;
}

-(void)setPVFamilyInvoteViewBlock:(PVFamilyInvoteViewBlock)block{
    self.callBlock = block;
}


- (IBAction)acceptBtn {
    if (self.callBlock) {
        self.callBlock(1);
    }
    
}


@end
