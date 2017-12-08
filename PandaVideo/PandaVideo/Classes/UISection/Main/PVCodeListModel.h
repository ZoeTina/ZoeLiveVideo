//
//  PVCodeListModel.h
//  PandaVideo
//
//  Created by cara on 2017/11/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

@class PVCodeModel;

@interface PVCodeListModel : PVBaseModel

@property(nonatomic, strong)NSMutableArray<PVCodeModel*>* codeModelList;

+(PVCodeListModel *)sharedInstance;
//获取产品包
-(void)getVideoProduct;
//获取匹配产品包
-(NSString*)getCorrespondingVideoProduct:(NSString*)code;

@end

@interface PVCodeModel : PVBaseModel

@property(nonatomic, copy)NSString* validatecode;
@property(nonatomic, copy)NSString* code;

@end
