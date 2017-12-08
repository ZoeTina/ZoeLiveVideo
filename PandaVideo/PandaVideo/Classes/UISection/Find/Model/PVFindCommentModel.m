//
//  PVFindCommentModel.m
//  PandaVideo
//
//  Created by cara on 17/8/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFindCommentModel.h"

@implementation PVFindCommentModel

-(void)setText:(NSString *)text{
//    text = @"哦 i 阿道夫哈的方法是那块地方能受得了开发你的看法门口等方面卡杜米发多发理发店理发妈妈反对，方面的，粉色的麻烦，都没法，发麻，没法，没法发，没法，没法，发麻，发麻，短发发麻，发麻，发麻，按摩法，啊";
    _text = text;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (!text.length) {
        self.isShowFullBtn = false;
        self.isShowText = false;
        self.headHeight = 0;
        return;
    }
    
    
    
    
    CGSize size = [UILabel messageBodyText:text andSyFontofSize:[[UIFont systemFontOfSize:15] pointSize] andLabelwith:ScreenWidth-69 andLabelheight:MAXFLOAT];
    
    CGRect frame = CGRectMake(0, 0, ScreenWidth-69, MAXFLOAT);
    NSArray *array = [UILabel getSeparatedLinesFromText:text font:[UIFont systemFontOfSize:15] frame:frame];
//    self.headFullHeight = size.height +115 + (array.count-1)*5;
    if (array.count > 4) {
        self.isShowFullBtn = true;
        self.isShowText = false;
        self.headHeight = size.height*4/array.count + 90;
    }else{
        self.headHeight = size.height*4/array.count + 70 + (array.count-1)*5;
        self.isShowFullBtn = false;
        self.isShowText = true;
    }
    self.headFullHeight = size.height + 70 + (array.count-1)*5;

  
}

-(void)setHeadHeight:(CGFloat)headHeight{
    if (headHeight == 0) {
        _headHeight = 100;
    }else{
        _headHeight = headHeight;
    }
}
-(void)setHeadFullHeight:(CGFloat)headFullHeight{
    if (headFullHeight == 0) {
        _headFullHeight = 100;
    }else{
        _headFullHeight = headFullHeight;
    }

}



@end
