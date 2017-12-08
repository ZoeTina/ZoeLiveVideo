//
//  PVDetailHelpsTextFootView.m
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDetailHelpsTextFootView.h"

@interface  PVDetailHelpsTextFootView()

@property (weak, nonatomic) IBOutlet UIButton *userfulBtn;
@property (weak, nonatomic) IBOutlet UIButton *unlessUserfulBtn;
@property (nonatomic, copy)PVDetailHelpsTextFootViewBlock footerBlock;

@end


@implementation PVDetailHelpsTextFootView


-(void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
}


-(void)setDetailModel:(PVHistoryDetailModel *)detailModel{
    self.userfulBtn.selected = detailModel.isHelpStatus;
    self.unlessUserfulBtn.selected = detailModel.isUnlessStatus;
}

-(void)setPVDetailHelpsTextFootViewBlock:(PVDetailHelpsTextFootViewBlock)block{
    self.footerBlock = block;
}


- (IBAction)userfulBtnClicked {
    
    if (self.footerBlock) {
        self.footerBlock(self.userfulBtn,nil);
    }
    NSLog(@"有用");
    
}

- (IBAction)unlessUserfulBtnClicked {
    if (self.footerBlock) {
        self.footerBlock(nil,self.unlessUserfulBtn);
    }
    NSLog(@"无用");
}
@end
