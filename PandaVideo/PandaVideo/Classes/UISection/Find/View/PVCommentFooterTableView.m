//
//  PVCommentFooterTableView.m
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVCommentFooterTableView.h"


@interface PVCommentFooterTableView()


@property (nonatomic, copy)CommentTableFootViewMoreBlock moreBlock;


@end


@implementation PVCommentFooterTableView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupUI];
    
}

-(void)setupUI{
    UIView* bgView = [[UIView alloc]  init];
    bgView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bgView;
    

    
}


-(void)setCommentModel:(PVFindCommentModel *)commentModel{
    _commentModel = commentModel;
    
    if (commentModel.isShowMoreBtn) {
        self.moreBtn.hidden = false;
    }else{
        self.moreBtn.hidden = true;
    }
    if (commentModel.isShowComment) {
        self.moreBtn.selected = false;
    }else{
        self.moreBtn.selected = true;

    }

}

-(void)setCommentTableFootViewMoreBlock:(CommentTableFootViewMoreBlock)block{
    self.moreBlock = block;
}

- (void)setFrame:(CGRect)frame {
//    frame.size.height -= 1;
    [super setFrame:frame];
}
- (IBAction)moreBtnClicked:(UIButton*)sender {
    if (self.moreBlock) {
        self.moreBlock(sender);
    }
}

@end
