//
//  PVTextView.m
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTextView.h"

@interface PVTextView() <UITextViewDelegate>

@property (nonatomic, weak) UILabel *placehoderLabel;

@end

@implementation PVTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI
{
    // 添加一个显示提醒文字的label（显示占位文字的label）
    UILabel *placehoderLabel = [[UILabel alloc] init];
    placehoderLabel.numberOfLines = 0;
    placehoderLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:placehoderLabel];
    self.placehoderLabel = placehoderLabel;
    
    // 设置默认的占位文字颜色
    self.placehoderColor = [UIColor lightGrayColor];
    
    // 设置默认的字体
    self.font = [UIFont systemFontOfSize:15];
    
    // 监听内部文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听文字改变
- (void)textDidChange
{
    // text属性：只包括普通的文本字符串
    // attributedText：包括了显示在textView里面的所有内容（表情、text）
    self.placehoderLabel.hidden = self.hasText;
    
//    if (self.text.length > 100) {
//        //对超出的部分进行剪切
//        self.text = [self.text substringToIndex:10];
//        
//    }
    if (self.text.length >= 100) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示!" message:@"亲!最多只能输入100个字!请您合理安排内容!" preferredStyle:UIAlertControllerStyleAlert];        
        UIAlertAction* action =  [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             [alertController dismissViewControllerAnimated:true completion:nil];
        }];
        [alertController addAction:action];
        UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
        [vc presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - 公共方法
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    _placehoder = [placehoder copy];
    
    // 设置文字
    self.placehoderLabel.text = placehoder;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)setPlacehoderColor:(UIColor *)placehoderColor
{
    _placehoderColor = placehoderColor;
    
    // 设置颜色
    self.placehoderLabel.textColor = placehoderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placehoderLabel.font = font;
    
    // 重新计算子控件的fame
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placehoderLabel.sc_y = 8;
    self.placehoderLabel.sc_x = 10;
    self.placehoderLabel.sc_width = self.sc_width - 2 * self.placehoderLabel.sc_x;
    // 根据文字计算label的高度
    CGSize maxSize = CGSizeMake(self.placehoderLabel.sc_width, MAXFLOAT);
    CGSize placehoderSize = [self.placehoder sizeWithFont:self.placehoderLabel.font constrainedToSize:maxSize];
    self.placehoderLabel.sc_height = placehoderSize.height;
}

@end
