//
//  PVMessageCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMessageCell.h"
#import "PVMessageModel.h"
#import "YYExtensions.h"
#import "DialogueModel.h"
#import "UIButton+UserInfo.h"
#import "Dialog.h"

@implementation PVMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //取消单元格选中效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addAtrribuedLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addAtrribuedLabel];
    }
    return self;
}
- (void)setMessageModel:(PVMessageModel *)messageModel{
    _messageModel = messageModel;
    NSLog(@"发送的消息:%@",messageModel.textContainer);
    self.attributedLabel.textContainer = messageModel.textContainer;
}

- (void)addAtrribuedLabel {
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:label];
    _attributedLabel = label;
    
    NSArray *verticalContrainsts = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[label]-3-|" options:0 metrics:nil views:@{@"label":_attributedLabel}];
    NSArray *horizontalCOntraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[label]-5-|" options:0 metrics:nil views:@{@"label":_attributedLabel}];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [NSLayoutConstraint activateConstraints:verticalContrainsts];
        [NSLayoutConstraint activateConstraints:horizontalCOntraints];
    } else {
        [self.contentView addConstraints:verticalContrainsts];
        [self.contentView addConstraints:horizontalCOntraints];
    }
}


- (void)setDialogue:(PVChatList *)dialogue{


    // 显示昵称
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, dialogue.userNameSize.width+20, dialogue.userNameSize.height)];
    [button setTitle:dialogue.userData.nickName forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [button setUserid:dialogue.chatId];
    
    [button setTitleColor:kColorWithRGB(128, 128, 128) forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    [self addSubview:button];
    self.nicknameBtn = button;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:dialogue.chatMsg];
    [text addAttribute:NSForegroundColorAttributeName value:kColorWithRGB(211, 0, 0) range:NSMakeRange(0, text.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    // 首行缩进
    style.firstLineHeadIndent = dialogue.userNameSize.width;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    
    // 显示聊天内容
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sc_width, dialogue.msgSize.height)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0];
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.attributedText = text;
    [self addSubview:label];
    self.messageLabel = label;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
