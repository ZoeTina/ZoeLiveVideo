//
//  PVRecordTableViewCell.h
//  PandaVideo
//
//  Created by cara on 17/8/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVHistoryModel.h"
#import "PVCollectionModel.h"
#import "PVTelevisionHistoryModel.h"

typedef void (^PVRecordTableViewCellBlock) (UIButton*);

@interface PVRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *isSelectedImageView;
@property (nonatomic, strong) PVHistoryModel *historyModel;
@property (nonatomic, strong) PVCollectionModel *collectionModel;
@property (nonatomic, strong) PVTelevisionHistoryModel *teleHistoryModel;

@property(nonatomic, assign)BOOL isShow;
-(void)setPVRecordTableViewCellBlockBlock:(PVRecordTableViewCellBlock)block;

@property(nonatomic,assign)BOOL isTeleversionHistory;

@end
