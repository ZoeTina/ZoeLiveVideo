//
//  SCButton.m
//  SiChuanFocus
//
//  Created by cara on 17/6/29.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "SCButton.h"
#import "UIButton+WebCache.h"

@implementation SCButton

+(SCButton*)customButtonWithTitlt: (NSString*)title  imageNolmalString: (NSString*)imageNolmalString  imageSelectedString: (NSString*)imageSelectedString{
    
    SCButton* customBtn = [SCButton buttonWithType:UIButtonTypeCustom];
    UIImage* imageNolmal = [UIImage imageNamed:imageNolmalString];
    if (imageNolmal == nil) {
        [customBtn sd_setImageWithURL:[NSURL URLWithString:imageNolmalString] forState:UIControlStateNormal];
    }else{
        [customBtn setImage:[UIImage imageNamed:imageNolmalString] forState:UIControlStateNormal];
    }
    
    UIImage* imageSelected = [UIImage imageNamed:imageNolmalString];

    if (imageSelected == nil) {
        [customBtn sd_setImageWithURL:[NSURL URLWithString:imageSelectedString] forState:UIControlStateSelected];
        [customBtn setImage:[UIImage imageNamed:imageSelectedString] forState:UIControlStateHighlighted];
    }else{
        [customBtn setImage:[UIImage imageNamed:imageSelectedString] forState:UIControlStateSelected];
        [customBtn setImage:[UIImage imageNamed:imageSelectedString] forState:UIControlStateHighlighted];
    }
    
    [customBtn setTitle:title forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor sc_colorWithHex:0x6B6A6B] forState:UIControlStateNormal];
    customBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [customBtn sizeToFit];
    
    return customBtn;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.imageView.frame = CGRectMake((self.sc_width-self.sc_height+15)*0.5, 0, self.sc_height-15, self.sc_height-15);
        self.imageView.frame = CGRectMake((self.sc_width-30)*0.5+1, 2, 30, 30);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+5, self.sc_width,self.sc_height - CGRectGetMaxY(self.imageView.frame)-5);
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}



@end
