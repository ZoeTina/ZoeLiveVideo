//
//  PVHomModel.h
//  PandaVideo
//
//  Created by cara on 17/9/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"


/*
 isHidden = 0;
	sort = 1;
	columOName = 精选的原始名字;
	columUrl = http://172.16.17.188:80/Column/columns/jingxuan/e17005faa29d4bb0958f79fde61b7adb.json;
	isLocked = 1;
	columKeyword = 推荐搜索词;
	columType = 2;
	columName = 精选;
	columId = 1;
	columnIcon = http://172.16.17.188:80/Images/2017/09/01/20170901144518127vjeawinxlu.png;
 */

@interface PVHomModel : PVBaseModel

@property(nonatomic, copy)NSString* isHidden;
@property(nonatomic, copy)NSString* sort;
@property(nonatomic, copy)NSString* columName;
@property(nonatomic, copy)NSString* columUrl;
@property(nonatomic, copy)NSString* isLocked;
@property(nonatomic, copy)NSString* columKeyword;
@property(nonatomic, copy)NSString* columType;
@property(nonatomic, copy)NSString* columId;
@property(nonatomic, copy)NSString* columnIcon;
@property(nonatomic, copy)NSString* topType;
@property(nonatomic, copy)NSString* searchKey;

@property(nonatomic,assign)BOOL isSelect;
@property(nonatomic,copy)NSString *indexRowStr;
@property(nonatomic,copy)NSString *imgStr;

@end
