//
//  PVCommentTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVCommentTableViewCell.h"

@interface PVCommentTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;

@end


@implementation PVCommentTableViewCell


-(void)awakeFromNib{
    [super awakeFromNib];
    self.commentTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

-(void)setRePlayList:(PVReplayList *)rePlayList{
    _rePlayList = rePlayList;
    NSString* text = rePlayList.content;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (rePlayList.userName.length) {
        text = [NSString stringWithFormat:@"%@:  %@",rePlayList.userName,rePlayList.content];
    }
    [self setDetailLabelHeight:text];
}

-(void)setDetailLabelHeight:(NSString*)text{
    if(text == nil || text == 0){
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    if (_rePlayList.userName.length) {
        NSRange range = [text localizedStandardRangeOfString:_rePlayList.userName];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor sc_colorWithHex:0x808080] range:range];
    }    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.commentTextLabel.attributedText = attributedString;
}



@end
