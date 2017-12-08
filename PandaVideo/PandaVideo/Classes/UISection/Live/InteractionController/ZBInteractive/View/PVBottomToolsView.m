//
//  PVBottomToolsView.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBottomToolsView.h"
@interface PVBottomToolsView()
@property (weak, nonatomic) IBOutlet UIButton *liveBtnComment;
@property (weak, nonatomic) IBOutlet UIButton *liveBtnQuickcomment;
@property (weak, nonatomic) IBOutlet UIButton *liveBtnConnect;
@property (weak, nonatomic) IBOutlet UIButton *liveBtnGift;

@end

@implementation PVBottomToolsView

+ (PVBottomToolsView *)bottomView {
    return [[[NSBundle mainBundle] loadNibNamed:@"PVBottomToolsView" owner:nil options:nil] lastObject];
}

- (IBAction) didShowToolsButtonClick:(UIButton *) sender{

    if(self.delegate && [self.delegate respondsToSelector:@selector(didShowToolsButtonClick:)]){
        [self.delegate didShowToolsButtonClick:sender];
    }
}

@end
