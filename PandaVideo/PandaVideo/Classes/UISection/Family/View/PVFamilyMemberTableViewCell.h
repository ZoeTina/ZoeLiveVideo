//
//  PVFamilyMemberTableViewCell.h
//  PandaVideo
//
//  Created by songxf on 2017/11/8.
//  Copyright © 2017年 cara. All rights reserved.
//  家庭成员列表

#import <UIKit/UIKit.h>

@interface PVFamilyMemberTableViewCell : UITableViewCell

@property(nonatomic,copy)void(^addFamilyBlock)(void);
- (void)tableViewDataSource:(NSArray *)tempArray;
@end

//历史记录，单元格
@interface PVFamilyMemberCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong,readonly)UIImageView * iconView;
@property(nonatomic,strong,readonly)UILabel * memberLabel;
@end
