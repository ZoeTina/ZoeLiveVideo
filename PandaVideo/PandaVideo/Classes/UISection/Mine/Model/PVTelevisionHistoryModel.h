//
//  PVTelevisionHistoryModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVTelevisionHistoryModel : NSObject
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *horizontalPic;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) NSInteger playLength;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *videoType;
@property (nonatomic, copy) NSString *verticalPic;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, assign) NSInteger length;
@end

@interface PVTelevisionListHistoryModel : NSObject
@property (nonatomic, strong) NSArray <PVTelevisionHistoryModel *> *historyList;
@property (nonatomic, assign) NSInteger total;
@end
