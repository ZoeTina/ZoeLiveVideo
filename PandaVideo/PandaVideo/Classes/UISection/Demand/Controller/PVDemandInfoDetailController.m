//
//  PVDemandInfoDetailController.m
//  PandaVideo
//
//  Created by cara on 2017/11/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDemandInfoDetailController.h"

@interface PVDemandInfoDetailController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateVideoLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeVideoLabel;
@property (weak, nonatomic) IBOutlet UILabel *starVideoLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starTopConstaint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoTextViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *infoContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoTitleWidthConstraint;

@end

@implementation PVDemandInfoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor clearColor];
   // self.containerViewTopConstraint.constant = ScreenWidth*9/16-20;
    
    
    self.infoTextView.editable = false;
    self.updateVideoLabel.text =  self.detailModel.videoDescription.updateMsg;
    NSString* typeVideoText = self.detailModel.videoDescription.type;
    if (typeVideoText.length) {
        typeVideoText = [NSString stringWithFormat:@"%@   %@", self.detailModel.videoDescription.type, self.detailModel.videoDescription.area];
    }else{
        typeVideoText = self.detailModel.videoDescription.area;
    }
    if (typeVideoText.length) {
       typeVideoText = [NSString stringWithFormat:@"%@   %@年", typeVideoText,self.detailModel.videoDescription.year];
    }else{
        typeVideoText = self.detailModel.videoDescription.year;
    }
    self.typeVideoLabel.text = typeVideoText;
    [self setDetailLabelHeight:self.detailModel.videoDescription.actors];
    
    if (self.detailModel.videoSubTitle.length) {
        [self setDetailTextViewHeight:[NSString stringWithFormat:@"简介: %@", self.detailModel.videoSubTitle]];
    }
    self.commentNumberLabel.text = self.detailModel.videoDescription.rank;
    self.updateTopConstraint.constant = self.detailModel.videoDescription.updateMsg.length ? 10.0 : 0;
    self.typeTopConstraint.constant = (self.detailModel.videoDescription.year.length || self.detailModel.videoDescription.area.length || self.detailModel.videoDescription.type.length) ? 10.0 : 0;
    self.starTopConstaint.constant = self.detailModel.videoDescription.actors.length ? 10.0 : 0;
    self.infoTextViewTopConstraint.constant = self.detailModel.videoSubTitle.length ? 10.0 : 0;
    
    CGFloat width = ScreenWidth-100;
    CGSize titleSize = [UILabel messageBodyText:self.detailModel.videoTitle andSyFontofSize:[self.videoTitleLabel.font pointSize] andLabelwith:MAXFLOAT andLabelheight:16];
    if (titleSize.width > width) {
        self.videoTitleWidthConstraint.constant = width;
    }else{
        self.videoTitleWidthConstraint.constant = titleSize.width+5;
    }
    self.videoTitleLabel.text = self.detailModel.videoTitle;
}

-(void)setDetailLabelHeight:(NSString*)text{
    if(text == nil || text == 0){
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor sc_colorWithHex:0x808080] range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, text.length)];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.starVideoLabel.attributedText = attributedString;
}


-(void)setDetailTextViewHeight:(NSString*)text{
    if(text == nil || text == 0){
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor sc_colorWithHex:0x808080] range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, text.length)];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.infoTextView.attributedText = attributedString;
}


- (IBAction)backBtnClicked {
    [UIView animateWithDuration:0.25f animations:^{
        self.view.sc_y = ScreenHeight;
    }  completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}
@end
