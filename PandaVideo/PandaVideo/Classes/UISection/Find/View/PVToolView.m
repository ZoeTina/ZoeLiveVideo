//
//  PVToolView.m
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVToolView.h"

@interface PVToolView() <UITextViewDelegate>


//文字提示
@property (nonatomic, weak) UILabel *placehoderLabel;

//键盘坐标系的转换
@property (nonatomic, assign) CGRect endKeyBoardFrame;

//传输文字的block回调
@property (strong, nonatomic) MyTextBlock textBlock;

//contentsinz
@property (strong, nonatomic) ContentSizeBlock sizeBlock;
//类型
@property(nonatomic, assign)NSInteger type;
//点击事件回调
@property(nonatomic, copy)PraiseButtonClickedBlock clickedCallBlock;

@end

@implementation PVToolView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(id)initWithType:(NSInteger)type{
    if (self = [super init]) {
        self.type = type;
        [self addSubview];
        [self addConstraint];
    }
    return self;
}

-(void)setMyTextBlock:(MyTextBlock)block{
    self.textBlock = block;
}
-(void)setContentSizeBlock:(ContentSizeBlock)block{
    self.sizeBlock = block;
}
-(void)setPraiseButtonClickedBlock:(PraiseButtonClickedBlock)block{
    self.clickedCallBlock = block;
}

//控件的初始化
-(void) addSubview{
    self.backgroundColor = [UIColor whiteColor];
    self.sendTextView = [[PVTextView alloc] initWithFrame:CGRectZero];
    self.sendTextView.backgroundColor = [UIColor sc_colorWithHex:0xECECEC];
    self.sendTextView.clipsToBounds = true;
    self.sendTextView.returnKeyType = UIReturnKeySend;
    self.sendTextView.font = [UIFont systemFontOfSize:15];
    [self.sendTextView setTextColor:[UIColor sc_colorWithHex:0x808080]];
    self.sendTextView.layer.cornerRadius = 15;
    self.sendTextView.delegate = self;
    [self addSubview:self.sendTextView];
    
    //给sendTextView添加轻击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.sendTextView addGestureRecognizer:tapGesture];
    
    if (self.type == 1){
        self.praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.praiseButton setImage:[UIImage imageNamed:@"find_btn_like_normal"] forState:UIControlStateNormal];
        [self.praiseButton setImage:[UIImage imageNamed:@"find_btn_like_selected"] forState:UIControlStateSelected];
        self.praiseButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.praiseButton setTitleColor:[UIColor sc_colorWithHex:0x808080] forState:UIControlStateNormal];
        [self.praiseButton setTitle:@"  1223" forState:UIControlStateNormal];
        [self.praiseButton addTarget:self action:@selector(praiseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.praiseButton];
    }
    
    UIView* topView = [[UIView alloc]  init];
    topView.backgroundColor = [UIColor sc_colorWithHex:0xd7d7d7];
    [self addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@(1));
    }];
    
}

//轻击sendText切换键盘
-(void)tapGesture:(UITapGestureRecognizer *) sender{
    
    if (![self.sendTextView isFirstResponder])
    {
        [self.sendTextView becomeFirstResponder];
    }
}



//给控件加约束
-(void)addConstraint{
    //给文本框添加约束
    NSInteger rigthConstraint = -80;
    if (self.type == 2) {
        rigthConstraint = -15;
    }else if (self.type == 1){
        [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@15);
            make.right.equalTo(@(-10));
        }];
    }
    
    self.sendTextView.translatesAutoresizingMaskIntoConstraints = YES;
    [self.sendTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.bottom.equalTo(@(-10));
        make.left.equalTo(@15);
        make.right.equalTo(@(rigthConstraint));
    }];
}

//通过文字的多少改变toolView的高度
-(void)textViewDidChange:(UITextView *)textView{
    CGSize contentSize = self.sendTextView.contentSize;
    self.sizeBlock(contentSize);
}

//发送信息（点击return）
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        //通过block回调把text的值传递到Controller中共
        self.textBlock(self.sendTextView.text);
        return NO;
    }
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    self.commentType = 0;
    return true;
}

-(void)praiseButtonClicked{
    if(self.clickedCallBlock){
        self.clickedCallBlock();
    }
}
@end
