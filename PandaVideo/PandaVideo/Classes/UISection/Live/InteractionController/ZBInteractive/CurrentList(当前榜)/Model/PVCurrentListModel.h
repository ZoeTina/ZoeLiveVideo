//
//  PVCurrentListModel.h
//  PandaVideo
//
//  Created by Ensem on 2017/11/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

@class PVCurrentListData,PVRankingList,LZUser;
@interface PVCurrentListModel : PVBaseModel

@property (nonatomic, strong) PVCurrentListData *listData;
@property (nonatomic, copy) NSString *errorMsg;
@property (nonatomic, copy) NSString *rs;

@end

@interface PVCurrentListData : PVBaseModel

@property (nonatomic, strong) NSMutableArray<PVRankingList *> *rankingList;

@end

@interface PVRankingList : PVBaseModel
/** 贡献值 */
@property (nonatomic, copy) NSString *contributionValue;
/** 排名 */
@property (nonatomic, copy) NSString *rank;
/** 用户对象 */
@property (nonatomic, strong) LZUser *lzUser;


@end

@interface LZUser : PVBaseModel

/** 头像 */
@property (nonatomic, copy) NSString *avatar;
/** ID */
@property (nonatomic, copy) NSString *userId;
/** 用户名 */
@property (nonatomic, copy) NSString *nickName;

@end
