//
//  PVLookHistoryTableViewCell.h
//  PandaVideo
//
//  Created by songxf on 2017/10/30.
//  Copyright © 2017年 cara. All rights reserved.
//  历史记录

#import <UIKit/UIKit.h>
#import "PVPersonModel.h"

@protocol PVLookHistoryTableViewCellDelegate <NSObject>
- (void)historyorCollectionCellClickWithUrl:(NSString *)url code:(NSString *)code;
@end


@interface PVLookHistoryTableViewCell : UITableViewCell

@property (nonatomic, weak) id <PVLookHistoryTableViewCellDelegate>cellDelegate;
@property(nonatomic, strong)PVPersonModel* personModel;
- (void)tableViewDataSource:(NSArray *)tempArray isHistory:(BOOL)isHistory;
@end

//历史记录，单元格
@interface PVLookHistoryCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong,readonly)UIImageView * imageView;
@property(nonatomic,strong,readonly)UILabel * titleLabel;
@end
