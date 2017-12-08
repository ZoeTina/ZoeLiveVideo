//
//  PVNoticeInfoModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVNoticeInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *jsonUrl;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, assign) BOOL isRead;
@end

@interface PVNoticeInfoListModel : NSObject
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger pageAllIndex;
@property (nonatomic, strong) NSArray<PVNoticeInfoModel *> *list;
@end

@interface PVNoticeInfoDetailModel : NSObject
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *htmlUrl;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *title;
@end
