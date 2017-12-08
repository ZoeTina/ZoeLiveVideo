//
//  PVVideoInformationTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/8/2.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVDemandVideoDetailModel.h"

typedef void (^VideoDetailBtnClickedBlock)(UIButton*);
typedef void (^CommentBtnClickedBlock) (UIButton*);
typedef void (^StoreBtnClickedBlock) (UIButton*);
typedef void (^ShareBtnClickedBlock) (UIButton*);
typedef void (^CollectBtnClickedBlock)(UIButton*);

@interface PVVideoInformationTableViewCell : UITableViewCell

-(void)setVideoDetailBtnClickedBlock:(VideoDetailBtnClickedBlock)block;
-(void)setCommentBtnClickedBlock:(CommentBtnClickedBlock)block;
-(void)setStoreBtnClickedBlock:(StoreBtnClickedBlock)block;
-(void)setShareBtnClickedBlock:(ShareBtnClickedBlock)block;
-(void)setCollectBtnClickedBlock:(CollectBtnClickedBlock)block;

@property(nonatomic, strong)PVDemandVideoDetailModel* videoDetailModel;
@property(nonatomic, strong)PVDemandVideoDetailModel* videoDetailModel1;

@end
