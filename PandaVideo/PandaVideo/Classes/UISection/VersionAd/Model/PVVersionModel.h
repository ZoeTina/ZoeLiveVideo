//
//  PVVersionModel.h
//  PandaVideo
//
//  Created by songxf on 2017/10/27.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVVersionModel : NSObject
//现在版本
@property(nonatomic,copy)NSString *currentVersion;
//下载url
@property(nonatomic,copy)NSString *downloadUrl;
//类型
@property(nonatomic,assign)NSInteger type;
//代码版本
@property(nonatomic,assign)NSInteger codeVerison;
//是否强制更新
@property(nonatomic,assign)BOOL updateType;
//更新信息
@property(nonatomic,copy)NSString *updateInfo;
@end


@interface PVVersionCellModel : NSObject

@property(nonatomic,copy)NSString * updateText;
@property(nonatomic,assign)float cellheight;
@end
