//
//  PVInteractionInfoView.h
//  PandaVideo
//
//  Created by Ensem on 2017/8/14.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义block类型把点击事件传入到Controller中
typedef void (^JJBtnClickedBlock) (UIButton*);

@interface PVInteractionInfoView : UIView

/** 显示机构名称 */
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *profileLabel;
@property (nonatomic, strong) UIImageView   *iconIMG;

-(void) setJJBtnClickedBlock:(JJBtnClickedBlock)block;
@end
