//
//  PVKeyBoardInputView.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVKeyBoardInputView.h"
#import "PVCustomSwitch.h"
/** 键盘 */
#import "ChatKeyBoardMacroDefine.h"
#import "ChatKeyBoard.h"

@interface PVKeyBoardInputView()<UITextFieldDelegate,ChatKeyBoardDelegate,PVCustomSwitchDelegate>
{
    KeyBoardInputViewType Showtype;
}
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) PVCustomSwitch *customSwitch;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) BOOL danmu;
- (void)initLayout;

@end

@implementation PVKeyBoardInputView

- (id)initWityStyle:(KeyBoardInputViewType)type
{
    self = [super init];
    if (self) {
        Showtype = type;
        [self initLayout];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initLayout];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initLayout];
    }
    return self;
}

- (void)editBeginTextField {
    if (self.textField.isFirstResponder) {
        return;
    }
    self.isEdit = YES;
    [self.textField becomeFirstResponder];
}

- (void)editEndTextField {
    if (self.textField.isFirstResponder) {
        self.isEdit = NO;
        [self.textField resignFirstResponder];
    }
}

- (void)initLayout
{
    if (Showtype == KeyBoardInputViewTypeNomal) {
        
        [self.chatKeyBoard keyboardDownForComment];
    }else if(Showtype == KeyBoardInputViewTypeNoDanMu){
        
    }
}

-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.backgroundColor = [UIColor whiteColor];
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowFace = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"快来和小伙伴一起畅聊吧~";
        [self addSubview:_chatKeyBoard];
        [self bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}

- (void)sendButtonEvent:(UIButton*)sedner
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardSendMessage:withDanmu:)]) {
        [_delegate keyBoardSendMessage:_textField.text withDanmu:_danmu];
    }
    _textField.text = @"";
}

#pragma mark -
- (void)customSwitchOn {
    _danmu = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardDanmuOpen)]) {
        [_delegate keyBoardDanmuOpen];
    }
}

- (void)customSwitchOff {
    _danmu = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardDanmuClose)]) {
        [_delegate keyBoardDanmuClose];
    }
}
#pragma mark -  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardSendMessage:withDanmu:)]) {
        [_delegate keyBoardSendMessage:_textField.text withDanmu:_danmu];
    }
    textField.text = @"";
    return YES;
}

@end
