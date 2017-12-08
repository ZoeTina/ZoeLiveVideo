//
//  PVCommentFooterTableView.h
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVFindCommentModel.h"

typedef void(^CommentTableFootViewMoreBlock)(UIButton*);



@interface PVCommentFooterTableView : UITableViewHeaderFooterView


-(void)setCommentTableFootViewMoreBlock:(CommentTableFootViewMoreBlock)block;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property(nonatomic, strong)PVFindCommentModel* commentModel;

@end
