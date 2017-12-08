//
//  PVBroadcastLiveCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/16.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBroadcastLiveCell.h"
#import "UIButton+Gradient.h"

@interface PVBroadcastLiveCell ()
 // 排名顺序
@property (weak, nonatomic) IBOutlet UIButton *rankingBtn;
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *headerIV;      // 用户头像
@property (weak, nonatomic) IBOutlet UILabel        *nicknameLB;    // 用户昵称
@property (weak, nonatomic) IBOutlet UILabel        *pandaCoinLB;   // 熊猫币

@end

@implementation PVBroadcastLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.rankingBtn.clipsToBounds = true;
    self.rankingBtn.layer.cornerRadius = 5.0f;
    
}

-(void)setTagGradation:(NSInteger)idx{
    UIColor* firstColor = [UIColor clearColor];
    UIColor* twoColor = [UIColor clearColor];
    if(idx == 0) {
        firstColor = [UIColor sc_colorWithHex:0xED5353];
        twoColor = [UIColor sc_colorWithHex:0xF47F64];
    }else if (idx == 1) {
        firstColor = [UIColor sc_colorWithHex:0xF07858];
        twoColor = [UIColor sc_colorWithHex:0xFF8C46];
    }else if (idx == 2) {
        firstColor = [UIColor sc_colorWithHex:0xFF9946];
        twoColor = [UIColor sc_colorWithHex:0xFEB516];
    }
    if (idx > 2) {
        self.rankingLabel.hidden = false;
        self.rankingBtn.hidden = true;
    }else{
        NSArray* colors = @[firstColor,twoColor];
        [self.rankingBtn gradientButtonWithSize:CGSizeMake(40, 18) colorArray:colors percentageArray:@[@0.3, @0.5, @1.0] gradientType:GradientFromLeftToRight];
        self.rankingLabel.hidden = true;
        self.rankingBtn.hidden = false;
    }
}
- (void)setListDataModel:(PVRankingList *)listDataModel{
    _listDataModel = listDataModel;
    YYLog(@"3");
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:self.listDataModel.lzUser.avatar] placeholderImage:kGetImage(@"mine_icon_avatar")];
    self.nicknameLB.text = self.listDataModel.lzUser.nickName;
    self.pandaCoinLB.text = [Utils seperateNumberByComma:self.listDataModel.contributionValue.integerValue];
    [self.rankingBtn setTitle:[NSString stringWithFormat:@"TOP%@",self.listDataModel.rank] forState:UIControlStateNormal];
    self.rankingLabel.text = [NSString stringWithFormat:@"TOP%@",self.listDataModel.rank];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
