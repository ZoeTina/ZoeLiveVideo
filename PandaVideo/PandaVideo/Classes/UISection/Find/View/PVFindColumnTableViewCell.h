//
//  PVFindColumnTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVFindHomeModel.h"

typedef void (^CommentBtnClickedBlock) (UIButton*);
typedef void (^PraiseBtnClickedBlock) (UIButton*);
typedef void (^ShareBtnClickedBlock) (UIButton*);
typedef void (^ImageViewClickedBlock) (UIButton*);


@interface PVFindColumnTableViewCell : UITableViewCell

@property (nonatomic, strong)PVFindHomeModel* findHomeModel;
@property (weak, nonatomic) IBOutlet UIView *videoContanierView;

-(void) setCommentBtnClickedBlock:(CommentBtnClickedBlock)block;
-(void) setPraiseBtnClickedBlock:(PraiseBtnClickedBlock)block;
-(void) setShareBtnClickedBlock:(ShareBtnClickedBlock)block;
-(void) setImageViewClickedBlock:(ImageViewClickedBlock)block;

@end
