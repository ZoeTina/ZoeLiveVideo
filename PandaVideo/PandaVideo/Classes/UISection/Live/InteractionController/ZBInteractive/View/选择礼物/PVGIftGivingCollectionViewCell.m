//
//  PVGIftGivingCollectionViewCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVGIftGivingCollectionViewCell.h"

@interface PVGIftGivingCollectionViewCell ()

@property (nonatomic, weak) UIImageView *bigImageView;
@property (nonatomic, weak) UILabel     *titleLabel;
@property (nonatomic, weak) UILabel     *moneyLabel;

@end

@implementation PVGIftGivingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = kColorWithRGB(215, 215, 215);
        [self.contentView addSubview:imageView];
        _bigImageView = imageView;
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@50);
            make.width.mas_equalTo(@71);
            make.centerX.equalTo(self.contentView);
        }];
        
        UILabel *titlelabel = [[UILabel alloc]init];
        titlelabel.backgroundColor     = [UIColor clearColor];
//        label.textColor           = HexRGB(0x8fa1a3);
        titlelabel.textAlignment       = NSTextAlignmentCenter;
        titlelabel.font                = [UIFont systemFontOfSize:12.f];
        titlelabel.text                = @"玫瑰花";
        titlelabel.layer.masksToBounds = YES;
        [self.contentView addSubview:titlelabel];
        _titleLabel = titlelabel;
        [titlelabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.top.equalTo(imageView.mas_bottom).with.offset(7);
        }];
        
        UILabel *moneylabel = [[UILabel alloc]init];
        moneylabel.backgroundColor     = [UIColor clearColor];
        moneylabel.textColor           = kColorWithRGB(128, 128, 128);
        moneylabel.textAlignment       = NSTextAlignmentCenter;
        moneylabel.font                = [UIFont systemFontOfSize:12.f];
        moneylabel.text                = @"1000";
        moneylabel.layer.masksToBounds = YES;
        [self.contentView addSubview:moneylabel];
        _moneyLabel = moneylabel;
        [moneylabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(titlelabel);
            make.left.equalTo(imageView).with.offset(5);
            make.top.equalTo(titlelabel.mas_bottom).with.offset(7);
        }];

        UIImageView *iconImage = [[UIImageView alloc]init];
        iconImage.backgroundColor = [UIColor clearColor];
        iconImage.image = [UIImage imageNamed:@"live_icon_money"];
        [self.contentView addSubview:iconImage];
        [iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(AUTOLAYOUTSIZE(12));
            make.width.mas_equalTo(AUTOLAYOUTSIZE(12));
            make.centerY.equalTo(moneylabel);
            make.left.equalTo(moneylabel.mas_right).with.offset(-15);
        }];
        
        // 1.创建一个富文本
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"1000"];
        
        
        NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,
                                       kColorWithRGB(128, 128, 128),NSForegroundColorAttributeName,nil];
        
        [attributeStr addAttributes:attributeDic range:NSMakeRange(0,attributeStr.length)];
        // 2.添加表情图片
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"live_icon_money"];
//        attach.bounds = CGRectMake(0, 0, 32, 32);
        NSAttributedString *attributeStr2 = [NSAttributedString attributedStringWithAttachment:attach];
        
        [attributeStr appendAttributedString:attributeStr2];
//        titlelabel.attributedText = attributeStr;
    }
    return self;
}

//- (void)setModel:(ColumnModel *)model
//{
//    _model  = model;
//    [_bigImageView setImageWithURL:model.thumb placeholder:nil];
//    _titleLabel.text = model.name;
//}

@end
