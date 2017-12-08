//
//  PVRecordTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVRecordTableViewCell.h"

@interface PVRecordTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoImageLeftConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;


@property (nonatomic, copy)PVRecordTableViewCellBlock recordCellBlock;

@end


@implementation PVRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.videoImageView.image = [UIImage imageNamed:@"3.jpg"];
    self.videoImageLeftConstraint.constant = -11;
    self.isSelectedImageView.hidden = true;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel setFont:[UIFont systemFontOfSizeAdapter:15]];
}

- (IBAction)deleteBtnClicked:(id)sender {
    self.isSelectedImageView.selected = !self.isSelectedImageView.selected;
    if (self.recordCellBlock) {
        self.recordCellBlock(self.isSelectedImageView);
    }
}

-(void)setPVRecordTableViewCellBlockBlock:(PVRecordTableViewCellBlock)block{
    self.recordCellBlock = block;
}

-(void)setIsShow:(BOOL)isShow{
    _isShow = isShow;
    if (isShow) {
        self.videoImageLeftConstraint.constant = 8;
        self.isSelectedImageView.hidden = false;
    }else{
        self.videoImageLeftConstraint.constant = -11;
        self.isSelectedImageView.hidden = true;
    }
//    [self layoutIfNeeded];
}

-(void)setHistoryModel:(PVHistoryModel *)historyModel{
    _historyModel = historyModel;
    self.isSelectedImageView.selected = historyModel.isDelete;
    [self layoutHistoryCell];
}

- (void)setCollectionModel:(PVCollectionModel *)collectionModel {
    _collectionModel = collectionModel;
    self.isSelectedImageView.selected = _collectionModel.isDelete;
    [self layoutCollectionCell];
}

- (void)setTeleHistoryModel:(PVTelevisionHistoryModel *)teleHistoryModel {
    _teleHistoryModel = teleHistoryModel;
    self.titleLabel.text = _teleHistoryModel.title;
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:[_teleHistoryModel.horizontalPic sc_urlString]] placeholderImage:[UIImage imageNamed:CROSSMAPBITMAP]];
    self.smallImageView.image = [UIImage imageNamed:@"mine_icon_tv"];
    self.activeLabel.text = [[NSDate sc_dateFromString:_teleHistoryModel.time withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"MM-dd HH:mm"];
    self.recordTimeLabel.text = [NSString stringWithFormat:@" 观看至%@",[SCSmallTool getHHMMSSFromSS:_teleHistoryModel.playLength]];
//    self.totalTimeLabel.text = self.historyModel.
}

- (void)layoutHistoryCell {
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:[self.historyModel.icon sc_urlString]] placeholderImage:[UIImage imageNamed:CROSSMAPBITMAP]];
    NSString *timeFormat = [SCSmallTool getHHMMSSFromSS:self.historyModel.playLength];
    self.recordTimeLabel.text = [NSString stringWithFormat:@" 观看至%@",timeFormat];
    self.titleLabel.text = self.historyModel.title;
    self.activeLabel.text = [[NSDate sc_dateFromString:self.historyModel.time withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"MM-dd HH:mm"];
    self.smallImageView.image = [UIImage imageNamed:@"mine_history_icon_phone"];
    self.totalTimeLabel.text = [NSString getHHMMSSFromSS:self.historyModel.length.integerValue];
}

- (void)layoutCollectionCell {
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:[self.collectionModel.icon sc_urlString]] placeholderImage:[UIImage imageNamed:CROSSMAPBITMAP]];
    self.activeLabel.text = [[NSDate sc_dateFromString:self.collectionModel.time withFormat:@"yyyy-MM-dd HH:mm:ss"] stringFromDate:@"MM-dd HH:mm"];
    self.titleLabel.text = self.collectionModel.title;
    self.smallImageView.hidden = true;
}

-(void)setIsTeleversionHistory:(BOOL)isTeleversionHistory{
    _isTeleversionHistory = isTeleversionHistory;
    if (isTeleversionHistory) {
        self.smallImageView.image = [UIImage imageNamed:@"mine_icon_tv"];
//        self.recordTimeLabel.text = @" 观看至00:25:30";
    }
}


@end
