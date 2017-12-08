//
//  PVSearchResultTextCell.m
//  PandaVideo
//
//  Created by cara on 17/8/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSearchResultTextCell.h"

@interface PVSearchResultTextCell()

@property(nonatomic, strong)UILabel* titleLabel;

@end

@implementation PVSearchResultTextCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}


-(void)setEpisodeListModel:(PVSearchEpisodeListModel *)episodeListModel{
    _episodeListModel = episodeListModel;
    NSString* sort = @"1";
    if (episodeListModel.episodeModel.sort == 2) {
        sort = @"2";
    }
    self.titleLabel.text = [NSString stringWithFormat:@"  第%@集  %@",sort,episodeListModel.episodeModel.videoName];
}



-(void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    UILabel* titleLabel = [[UILabel alloc]  init];
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor sc_colorWithHex:0x808080];
    titleLabel.backgroundColor = [UIColor sc_colorWithHex:0xF2F2F2];
    titleLabel.clipsToBounds = true;
    titleLabel.layer.cornerRadius = 3.0f;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(13, 2, self.sc_width-27, self.sc_height-4);
}


@end


@interface PVSearchResultMoreCell()

@end

@implementation PVSearchResultMoreCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    UILabel* titleLabel = [[UILabel alloc]  init];
    titleLabel.numberOfLines = 1;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.textColor = [UIColor sc_colorWithHex:0x808080];
    titleLabel.text =@"查看更多";
//    titleLabel.backgroundColor = [UIColor sc_colorWithHex:0x00b6e9];
    [self.contentView addSubview:titleLabel];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home2_btn_enter_blue"]];
    imageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.height.equalTo(@10.5);
        make.width.equalTo(@5.5);
        make.centerX.mas_equalTo(5.5);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.equalTo(imageView.mas_left).offset(-1);
        make.centerY.equalTo(self.contentView);
    }];
    
}


@end

