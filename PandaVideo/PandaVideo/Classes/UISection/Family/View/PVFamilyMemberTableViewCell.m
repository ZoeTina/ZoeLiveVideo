//
//  PVFamilyMemberTableViewCell.m
//  PandaVideo
//
//  Created by songxf on 2017/11/8.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFamilyMemberTableViewCell.h"
#import "PVFamilyInfoModel.h"

static NSString* resuPVFamilyMemberCollectionViewCell = @"resuPVFamilyMemberCollectionViewCell";
@interface PVFamilyMemberTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
@private
    UICollectionView * _collectionView;
}
@property(nonatomic,strong,readonly)UICollectionView * collectionView;
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation PVFamilyMemberTableViewCell

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

- (void)tableViewDataSource:(NSArray *)tempArray{
    self.dataArray = [NSArray arrayWithArray:tempArray];
    [self.collectionView reloadData];
}
- (void)setupUI{
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(IPHONE6WH(11), IPHONE6WH(13), IPHONE6WH(11), IPHONE6WH(13)));
        
    }];
}


#pragma mark --  UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MAX(self.dataArray.count + 1, 1);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PVFamilyMemberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuPVFamilyMemberCollectionViewCell forIndexPath:indexPath];
    if (indexPath.row >= self.dataArray.count) {
        cell.iconView.image = [UIImage imageNamed:@"add_more"];
        cell.memberLabel.text = @"添加成员";
    }else{
        PVFamilyInfoListModel * infoModel = [self.dataArray sc_safeObjectAtIndex:indexPath.row];
        [cell.iconView sc_setImageWithUrlString:infoModel.avatar placeholderImage:[UIImage imageNamed:@"user1"] isAvatar:NO];
        cell.memberLabel.text = infoModel.nickName;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= self.dataArray.count) {
        if (self.addFamilyBlock) {
            self.addFamilyBlock();
        }
    }
}
//上下行cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
    
}
//同一行的cell的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return  (ScreenWidth - IPHONE6WH(26) - IPHONE6WH(64 * 5))/4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(IPHONE6WH(64), IPHONE6WH(77));
    
}

#pragma mark -- setter getter
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[PVFamilyMemberCollectionViewCell class] forCellWithReuseIdentifier:resuPVFamilyMemberCollectionViewCell];
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
@interface PVFamilyMemberCollectionViewCell ()
{
@private
    UIImageView * _iconView;
    UILabel * _memberLabel;
}

@end

@implementation PVFamilyMemberCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.memberLabel];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(IPHONE6WH(50)));
        make.width.equalTo(@(IPHONE6WH(50)));
    }];
    [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(self.iconView.mas_bottom).mas_offset(IPHONE6WH(13));
    }];
    
}

#pragma mark -- setter getter
- (UIImageView *)iconView{
    if (_iconView  == nil) {
        _iconView = [[UIImageView alloc] init];
        _iconView.clipsToBounds = YES;
        _iconView.layer.cornerRadius = IPHONE6WH(25);
//         _iconView.contentMode = UIViewContentModeCenter;
        _iconView.backgroundColor = [UIColor clearColor];
        _iconView.image = [UIImage imageNamed:@"user3"];
        _iconView.userInteractionEnabled = YES;
    }
    return _iconView;
}
- (UILabel *)memberLabel{
    if (_memberLabel == nil) {
        _memberLabel = [UILabel sc_labelWithText:@"小黄人" fontSize:14 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
        _memberLabel.numberOfLines = 1;
    }
    return _memberLabel;
}
@end

