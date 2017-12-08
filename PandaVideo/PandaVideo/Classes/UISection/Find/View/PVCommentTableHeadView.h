//
//  PVCommentTableHeadView.h
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVFindCommentModel.h"


typedef void(^PraiseBtnClickedBlock)(UIButton*);
typedef void(^CommentTableHeadViewTextBlock)(UIButton*);
typedef void(^CommentTableHeadViewTapGestureBlock)(PVFindCommentModel* commentModel);

@interface PVCommentTableHeadView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullBtn;

@property (nonatomic, strong)PVFindCommentModel* commentModel;

-(void)setPraiseBtnClickedBlock:(PraiseBtnClickedBlock)block;
-(void)setCommentTableHeadViewTextBlock:(CommentTableHeadViewTextBlock)block;
-(void)setCommentTableHeadViewTapGestureBlock:(CommentTableHeadViewTapGestureBlock)block;

@end
