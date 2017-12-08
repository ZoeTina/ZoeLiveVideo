//
//  PVMessageCell.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PVMessageModel,PVChatList;
@interface PVMessageCell : UITableViewCell

@property (nonatomic, weak, readonly) TYAttributedLabel *attributedLabel;

@property (nonatomic, strong) PVChatList *dialogue;
@property (nonatomic, strong) PVMessageModel *messageModel;

@property (nonatomic, strong) UIButton *nicknameBtn;
@property (nonatomic, strong) UILabel *messageLabel;
@end
