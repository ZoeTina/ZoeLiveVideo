//
//  PVRecommandReusableView.m
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRecommandReusableView.h"

@interface PVRecommandReusableView()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *recommandImageView;

@property (weak, nonatomic) IBOutlet UIView *recommandContanierView;

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UIImageView *leftIconImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleImageViewLeftConstraint;

@property (weak, nonatomic) IBOutlet UIView *titleContainView;

@property (nonatomic, copy) PVRecommandReusableViewCallBlock callBlock;
@property (nonatomic, strong)ModelWord* modelWord;

@end

@implementation PVRecommandReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor sc_colorWithHex:0xf2f2f2];
    UIView* bottomView = [[UIView alloc]  init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self insertSubview:bottomView atIndex:0];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(@(3));
        make.bottom.equalTo(self);
    }];
    
    UITapGestureRecognizer* leftTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(leftTapGestureClicked)];
    [self.titleContainView addGestureRecognizer:leftTapGesture];
    
    UITapGestureRecognizer* rightTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(rightTapGestureClicked)];
    self.nickLabel.userInteractionEnabled = true;
    [self.nickLabel addGestureRecognizer:rightTapGesture];
    
    UITapGestureRecognizer* imageViewTapGesture = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(imageViewTapGestureClicked)];
    self.recommandImageView.userInteractionEnabled = true;
    [self.recommandImageView addGestureRecognizer:imageViewTapGesture];
    
    self.titleLabel.font = [UIFont fontWithName:FontBlod size:15];
    
}

-(void)leftTapGestureClicked{
    if (self.callBlock) {
        self.callBlock(self.modelWord,ClickedLeft);
    }
    PVLog(@"左边");
}
-(void)rightTapGestureClicked{
    if (self.callBlock) {
        self.callBlock(self.modelWord,ClickedRight);
    }
    PVLog(@"右边");
}
-(void)imageViewTapGestureClicked{
    if (self.callBlock) {
        self.callBlock(self.modelWord,ClickedImageView);
    }
    PVLog(@"大图");
}

-(void)setPVRecommandReusableViewCallBlock:(PVRecommandReusableViewCallBlock)block{
    self.callBlock = block;
}


-(void)setModelTitleDataModel:(PVModelTitleDataModel *)modelTitleDataModel{
    _modelTitleDataModel = modelTitleDataModel;

    NSInteger type = modelTitleDataModel.modelTitleType.integerValue;
    if (type == 1) {//文字
        self.modelWord = modelTitleDataModel.modelWord1;
        self.titleLabel.text = modelTitleDataModel.modelWord1.modelTitleTxt;
        self.titleLabel.hidden =  false;
        self.titleImageView.hidden = !modelTitleDataModel.modelWord1.modelArrowData.Arrow.boolValue;
        self.nickLabel.hidden = !modelTitleDataModel.modelWord1.modelKeyData.modelKey.boolValue;
        self.nickLabel.text = modelTitleDataModel.modelWord1.modelKeyData.modelKeyTxt;
        self.leftIconImageView.hidden = self.recommandImageView.hidden = true;
        self.recommandContanierView.hidden = false;
        if (self.leftIconImageView.hidden) {
            self.titleImageViewLeftConstraint.constant = -30;
        }else{
            self.titleImageViewLeftConstraint.constant = 10;
        }
    }else if (type == 2) {//文字+图
        self.modelWord = modelTitleDataModel.modelWord2;
        self.titleLabel.text = modelTitleDataModel.modelWord2.modelTitleTxt;
        [self.leftIconImageView sc_setImageWithUrlString:modelTitleDataModel.modelWord2.modelTitleImage placeholderImage:nil isAvatar:false];
        self.titleImageView.hidden = !modelTitleDataModel.modelWord2.modelArrowData.Arrow.boolValue;
        self.titleLabel.hidden = self.leftIconImageView.hidden = false;
        self.nickLabel.hidden = !modelTitleDataModel.modelWord2.modelKeyData.modelKey.boolValue;
        self.nickLabel.text = modelTitleDataModel.modelWord2.modelKeyData.modelKeyTxt;
        self.recommandImageView.hidden = true;
        self.recommandContanierView.hidden = false;
        if (self.leftIconImageView.hidden) {
            self.titleImageViewLeftConstraint.constant = -15;
        }else{
            self.titleImageViewLeftConstraint.constant = 10;
        }
    }else{//长图
        self.modelWord = modelTitleDataModel.modelWord3;
        self.recommandContanierView.hidden = true;
        self.recommandImageView.hidden = false;
        [self.recommandImageView sc_setImageWithUrlString:modelTitleDataModel.modelWord3.modelTitleImage placeholderImage:nil isAvatar:false];
    }
}




-(void)setType:(NSInteger)type{
    _type = type;
    
    if (type == 1) {
        self.titleLabel.text = @"今日推荐";
        self.titleLabel.hidden = self.titleImageView.hidden = false;
        self.nickLabel.hidden = self.recommandImageView.hidden = true;
        self.recommandContanierView.hidden = false;
    }else if (type == 2){
        self.recommandContanierView.hidden = false;
        self.titleLabel.text = @"热播连续剧";
        self.titleLabel.hidden = self.titleImageView.hidden = false;
        self.nickLabel.hidden = self.recommandImageView.hidden = true;
    }else if (type == 3){
        self.recommandContanierView.hidden = true;
        self.recommandImageView.hidden = false;
        self.recommandImageView.image = [UIImage imageNamed:@"1.jpg"];
    }else if (type == 4){
        self.recommandContanierView.hidden = false;
        self.titleLabel.text = @"电视剧";
        self.nickLabel.text = @"片库";
        self.nickLabel.hidden = self.titleLabel.hidden =  false;
        self.titleImageView.hidden =  self.recommandImageView.hidden = true;
    }else if (type == 5){
        self.recommandContanierView.hidden = false;
        self.titleLabel.text = @"电影";
        self.nickLabel.text = @"极限特工";
        self.nickLabel.hidden = self.titleLabel.hidden =  false;
        self.titleImageView.hidden =  self.recommandImageView.hidden = true;
    }else if (type == 6){
        self.recommandContanierView.hidden = false;
        self.titleLabel.text = @"广告";
        self.nickLabel.text = @"片库";
        self.titleLabel.hidden = self.nickLabel.hidden  = false;
        self.titleImageView.hidden = self.recommandImageView.hidden = true;
    }else if (type == 7){
        self.recommandContanierView.hidden = false;
        self.titleLabel.text = @"精彩电视直播";
        self.titleLabel.hidden = self.titleImageView.hidden = false;
        self.nickLabel.hidden = self.recommandImageView.hidden = true;
    }else if (type == 8){
        self.recommandContanierView.hidden = false;
        self.titleLabel.text = @"互动直播";
        self.titleLabel.hidden = self.titleImageView.hidden = false;
        self.nickLabel.hidden = self.recommandImageView.hidden = true;
    }else if (type == 9){
        self.recommandContanierView.hidden = false;
        self.titleLabel.text = @"再见江湖";
        self.titleLabel.hidden = self.titleImageView.hidden = false;
        self.nickLabel.hidden = self.recommandImageView.hidden = true;
    }else if (type == 10){
        self.recommandContanierView.hidden = false;
        self.titleLabel.text = @"XX排行榜";
        self.titleLabel.hidden = self.titleImageView.hidden = false;
        self.nickLabel.hidden = self.recommandImageView.hidden = true;
    }else if (type == 11){
        self.recommandContanierView.hidden = false;
        self.titleLabel.text = @"相关明星";
        self.titleLabel.hidden =  false;
       self.titleImageView.hidden = self.nickLabel.hidden = self.recommandImageView.hidden = true;
    }

    
//    if (type == 4) {
//        self.bgView.hidden = true;
//        self.recommandImageView.hidden = self.nickLabel.hidden = self.titleImageView.hidden = true;
//    }
}

-(void)setSectionOfStar:(NSInteger)sectionOfStar{
    _sectionOfStar = sectionOfStar;
    
    NSString* title = @"电影";
    if(sectionOfStar == 1){
        title = @"电视剧";
    }else if (sectionOfStar == 2){
        title = @"综艺";
    }
    self.titleLabel.text = title;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 3;
    [super setFrame:frame];
}

@end
