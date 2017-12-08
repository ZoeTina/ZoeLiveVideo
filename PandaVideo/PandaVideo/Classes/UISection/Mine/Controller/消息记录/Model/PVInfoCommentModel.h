//
//  PVInfoCommentModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/1.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVUserDataModel : NSObject
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@end


@interface PVInfoCommentModel : NSObject

@property (nonatomic, assign) BOOL isFullText;

@property (nonatomic, strong) PVUserDataModel *userData;
@property (nonatomic, copy) NSString *replyTime;
@property (nonatomic, copy) NSString *replyContent;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *replyId;
@end



@interface PVInfoListCommentModel : NSObject
@property (nonatomic, strong) NSArray <PVInfoCommentModel *> *replyList;
@end
