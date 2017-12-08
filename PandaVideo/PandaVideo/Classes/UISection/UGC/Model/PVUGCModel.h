//
//  PVUGCModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVUGCColorModel : NSObject
@property (nonatomic,copy) NSString *value;
@property (nonatomic, assign) NSInteger status;
@end

@interface PVUGCTagModel : NSObject
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger maxCount;
@end

@interface PVUGCModel : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *protocol;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger videoSize;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *guideHtml;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) PVUGCColorModel *color;
@property (nonatomic, strong) PVUGCTagModel *tag;
           
@end

@interface PVUGCVideoInfo : NSObject
@property (nonatomic, assign) NSInteger ugcId;
@property (nonatomic, copy) NSString *videoDes;
@property (nonatomic, copy) NSString *videoImg;
@property (nonatomic, copy) NSString *videoTitle;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, strong) NSArray *tag;
@property (nonatomic, assign) NSInteger videoDuration;
@end

