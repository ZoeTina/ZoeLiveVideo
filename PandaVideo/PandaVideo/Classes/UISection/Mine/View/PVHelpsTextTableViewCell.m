//
//  PVHelpsTextTableViewCell.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVHelpsTextTableViewCell.h"

@interface PVHelpsTextTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation PVHelpsTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)setIsQuestion:(BOOL)isQuestion{
    _isQuestion = isQuestion;
    if (isQuestion) {
        self.bottomView.hidden = true;
    }
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setQuestionModel:(PVQuestionModel *)questionModel {
    _questionModel = questionModel;
    self.titleLabel.text = _questionModel.question;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    CGFloat height = self.bottomView.sc_y + 1;
//    self.contentView.sc_height = height;
}

-(void)setupUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    UILabel* titleLabel = [[UILabel alloc]  init];
//    titleLabel.textColor = [UIColor sc_colorWithHex:0x000000];
//    titleLabel.font = [UIFont systemFontOfSize:15];
//    titleLabel.numberOfLines = 100;
//    [self.contentView addSubview:titleLabel];
//    self.titleLabel = titleLabel;
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self);
//        make.left.equalTo(@10);
//        make.right.mas_offset(-10);
//    }];
//    UIView* bottomView = [[UIView alloc]  init];
//    //    bottomView.backgroundColor = [UIColor sc_colorWithHex:0xF2F2F2];
//    bottomView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
//        make.height.equalTo(@1);
//        make.right.equalTo(self);
//        make.left.equalTo(@10);
//    }];
//    self.bottomView = bottomView;
//    CGFloat height = self.bottomView.sc_y + 1;
//    self.contentView.sc_height = self.bottomView.sc_y + 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
