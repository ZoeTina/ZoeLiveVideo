//
//  SCImageLabel.h
//  SiChuanFocus
//
//  Created by songxf on 2017/7/4.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCImagePosition) {
    SCImagePositionBackground,
    SCImagePositionTop,
    SCImagePositionLeft,
    SCImagePositionBottom,
    SCImagePositionRight,
};

@interface SCImageLabel : UIView

@property (nonatomic, strong) UIFont    *font;
@property (nonatomic, strong) NSString  *text;
@property (nonatomic, strong) UIColor   *textColor;
@property (nonatomic, strong) UIColor   *highlightedTextColor;
@property (nonatomic, strong) UIImage   *image;
@property (nonatomic, strong) UIImage   *highlightedImage;

@property (nonatomic, assign, getter = isHighlighted) BOOL highlighted;
@property (nonatomic, assign) SCImagePosition imagePosition;
@property (nonatomic, assign) CGFloat spacing;  // space between image and text, default is 0.0f.
@property (nonatomic, assign) CGFloat offset;   // default is 0.0f
@property (nonatomic, strong) NSAttributedString  *attrString;

@end
