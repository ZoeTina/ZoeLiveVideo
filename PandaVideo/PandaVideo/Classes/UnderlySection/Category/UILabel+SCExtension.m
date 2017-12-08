//
//  UILabel+SCExtension.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/22.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "UILabel+SCExtension.h"
#import <CoreText/CoreText.h>

@implementation UILabel (SCExtension)

+ (instancetype)sc_labelWithText:(NSString *)text {
    return [self sc_labelWithText:text fontSize:14 textColor:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft];
}

+ (instancetype)sc_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    return [self sc_labelWithText:text fontSize:fontSize textColor:[UIColor darkGrayColor] alignment:NSTextAlignmentLeft];
}

+ (instancetype)sc_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    return [self sc_labelWithText:text fontSize:fontSize textColor:textColor alignment:NSTextAlignmentLeft];
}

+ (instancetype)sc_labelWithText:(NSString *)text fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment {
    
    UILabel *label = [[self alloc] init];
    
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor;
    label.numberOfLines = 0;
    label.textAlignment = alignment;
    
    [label sizeToFit];
    
    return label;
}

-(CGSize)messageBodyLabelwith:(float)labelwith andLabelheight:(float)labelheieht
{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(labelwith, labelheieht) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    return size;
}

+(CGSize)messageBodyText:(NSString *)text andSyFontofSize:(float)fontsize andLabelwith:(float)labelwith andLabelheight:(float)labelheieht
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(labelwith, labelheieht) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    
    return size;
}

+ (NSArray *)getSeparatedLinesFromText:(NSString*)labelText  font:(UIFont*)labelFont  frame:(CGRect)labelFrame
{
    NSString *text = labelText;
    UIFont   *font = labelFont;
    CGRect    rect = labelFrame;
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}


+(CGSize)messageBodyText:(NSString *)text andBoldSystemFontOfSize:(float)fontsize andLabelwith:(float)labelwith andLabelheight:(float)labelheieht
{
    CGSize size = [text boundingRectWithSize:CGSizeMake(labelwith, labelheieht) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:fontsize]} context:nil].size;
    
    return size;
}

+ (NSAttributedString *)getLabelParagraph:(NSString*)text  height:(CGFloat)height{
    if (text == nil ||  text.length == 0) return nil;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:height];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    return attributedString;
}

@end
