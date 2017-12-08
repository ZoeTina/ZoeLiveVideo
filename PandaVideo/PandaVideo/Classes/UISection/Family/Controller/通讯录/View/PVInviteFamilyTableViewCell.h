//
//  PVInviteFamilyTableViewCell.h
//  PandaVideo
//
//  Created by Ensem on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVInviteFamilyTableViewCell : UITableViewCell

/** 是否被邀请的状态 */
@property (nonatomic, strong) IBOutlet UILabel *joinStateLabel;

@property (nonatomic, strong) PVTongxunluModel *contractModel;

/** 没有姓名时候的电话号码 */
@property (nonatomic, strong) IBOutlet UILabel *bigPhoneLabel;

/** 有姓名时候的电话号码 */
@property (nonatomic, strong) IBOutlet UILabel *smallPhoneLabel;

/** 姓名 */
@property (nonatomic, strong) IBOutlet UILabel *labelName;

@property (nonatomic, assign) BOOL isShowArrowView;
/** 第一种Cell的显示 */
- (void) showUI1;
/** 第二种Cell的显示 */
- (void) showUI2;
/** 第三种Cell的显示 */ 
- (void) showUI3;
@end
