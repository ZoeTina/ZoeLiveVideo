//
//  PVInviteFamilyHeaderView.h
//  PandaVideo
//
//  Created by Ensem on 2017/10/23.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVInviteFamilyHeaderView : UIView
/** 加载xib */
+ (PVInviteFamilyHeaderView *)headerView;
/** 通讯录按钮 */
@property (weak, nonatomic) IBOutlet UIButton *tongxunluBtn;
/** 邀请按钮 */
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
/** 手机号输入框 */
@property (weak, nonatomic) IBOutlet UITextField *telTextField;
@end
