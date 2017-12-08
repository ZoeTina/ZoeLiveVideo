//
//  PVLookHistoryTableViewCell.m
//  PandaVideo
//
//  Created by songxf on 2017/10/30.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLookHistoryTableViewCell.h"
#import "PVHistoryModel.h"
#import "PVCollectionModel.h"
static NSString* resuPVLookHistoryCollectionViewCell = @"resuPVLookHistoryCollectionViewCell";

@interface PVLookHistoryTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
@private
    UICollectionView * _collectionView;
    UIImageView * _iconImageView;
    UILabel * _titleLabel;
}
@property(nonatomic,strong,readonly)UICollectionView * collectionView;
@property(nonatomic,strong,readonly)UIImageView * iconImageView;
@property(nonatomic,strong,readonly)UILabel * titleLabel;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)BOOL isHistory;

@end
@implementation PVLookHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setCellDelegate:(id<PVLookHistoryTableViewCellDelegate>)cellDelegate {
    _cellDelegate = cellDelegate;
}

- (void)setupUI{
    
    UIView * topView = [UIView sc_viewWithColor:[UIColor clearColor]];
    [self.contentView addSubview:topView];
    [self.contentView addSubview:self.collectionView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.equalTo(@50);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14);
        make.right.equalTo(self.contentView);
        make.top.equalTo(topView.mas_bottom);
        make.height.equalTo(@96);
        
    }];
    
    UIImageView * backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_btn_enter"]];
    [topView addSubview:self.iconImageView];
    [topView addSubview:self.titleLabel];
    [topView addSubview:backImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(30);
    }];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView).offset(-18);
        make.centerY.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(11);
        make.centerY.equalTo(self.iconImageView);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView).offset(-40);
    }];
    
    UIView *bottomLine = [UIView sc_viewWithColor:[UIColor sc_colorWithHex:0xf2f2f2]];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(14);
        make.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.equalTo(@1);
    }];
}

- (void)tableViewDataSource:(NSArray *)tempArray isHistory:(BOOL)isHistory{
    self.dataArray = tempArray;
    self.isHistory = isHistory;
    [self.collectionView reloadData];
}
-(void)setPersonModel:(PVPersonModel *)personModel{
    _personModel = personModel;
    self.titleLabel.text = personModel.title;
    self.iconImageView.image = [UIImage imageNamed:personModel.imageText];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return MAX(self.dataArray.count, 0);
//    if (self.dataArray.count == 0) {
//        return <#expression#>
//    }
    return self.dataArray.count >=4 ? 4 : self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     PVLookHistoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVLookHistoryCollectionViewCell forIndexPath:indexPath];
    NSString * imageString = @"";
    NSString *title = @"";
    if (self.isHistory) {
        PVHistoryModel * model = [self.dataArray sc_safeObjectAtIndex:indexPath.row];
        imageString = model.icon;
        title = model.title;
    }else{
        PVCollectionModel * model = [self.dataArray sc_safeObjectAtIndex:indexPath.row];
        imageString = model.icon;
        title = model.title;
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[imageString sc_urlString]] placeholderImage:[UIImage imageNamed:BIGBITMAP]];
    cell.titleLabel.text = title;
    return cell;
}
//同一行的cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(109, 96);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isHistory) {
        PVHistoryModel * model = [self.dataArray sc_safeObjectAtIndex:indexPath.row];
        if (self.cellDelegate) {
            [self.cellDelegate historyorCollectionCellClickWithUrl:model.videoUrl code:model.code];
        }
    }else{
        PVCollectionModel * model = [self.dataArray sc_safeObjectAtIndex:indexPath.row];
        if (self.cellDelegate) {
            [self.cellDelegate historyorCollectionCellClickWithUrl:model.videoUrl code:model.code];
        }
    }
}

#pragma mark -- setter getter
- (UIImageView *)iconImageView{
    if (_iconImageView  == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel sc_labelWithText:@"skdjjdjdj" fontSize:14 textColor:[UIColor sc_colorWithHex:0x000000] alignment:NSTextAlignmentLeft];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
         layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PVLookHistoryCollectionViewCell class] forCellWithReuseIdentifier:resuPVLookHistoryCollectionViewCell];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
    }
    return _collectionView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end




#pragma mark  
@interface PVLookHistoryCollectionViewCell ()
{
@private
    UIImageView * _imageView;
    UILabel * _titleLabel;
}

@end

@implementation PVLookHistoryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.equalTo(@61);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.imageView.mas_bottom).offset(3);
        make.height.equalTo(@35);
    }];
}

#pragma mark -- setter getter
- (UIImageView *)imageView{
    if (_imageView  == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.image = [UIImage imageNamed:@"4.jpg"];
    }
    return _imageView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel sc_labelWithText:@"中共中央总书记、国家主席、中央军委主席习近平28日给西藏隆子县玉麦乡牧民卓嘎、央宗姐妹回信" fontSize:13 textColor:[UIColor sc_colorWithHex:0x000000] alignment:NSTextAlignmentLeft];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
@end
