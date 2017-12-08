//
//  PVTongxunluTableViewCell.h
//  PandaVideo
//
//  Created by Ensem on 2017/10/24.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVTongxunluTableViewCell : UITableViewCell

/** 姓名 */
@property (nonatomic, strong) IBOutlet UILabel *labelName;
/** 电话号码 */
@property (nonatomic, strong) IBOutlet UILabel *labelTel;
/** 电话号码 */
@property (nonatomic, strong) IBOutlet UILabel *labelTels;
/** 是否被邀请的状态 */
@property (nonatomic, strong) IBOutlet UILabel *labelState;
/** 是否被邀请的状态 */
@property (nonatomic, strong) IBOutlet UIButton *inviteBtn;
/** 电视剧logo */
@property (nonatomic, strong) IBOutlet UIImageView *teleplayIcon;


/** 通讯录第一种Cell的显示 */
- (void) showUI1;
/** 通讯录第二种Cell的显示 */
- (void) showUI2;
/** 通讯录第三种Cell的显示 */
- (void) showUI3;
@end
