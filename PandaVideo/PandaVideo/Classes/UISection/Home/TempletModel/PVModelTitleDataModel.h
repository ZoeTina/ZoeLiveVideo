//
//  PVModelTitleDataModel.h
//  PandaVideo
//
//  Created by cara on 17/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVBaseModel.h"

@class ModelWord;

@interface PVModelTitleDataModel : PVBaseModel

///模板标题类型（1、文字，2、文字+图片，3、长图）
@property(nonatomic, copy)NSString*  modelTitleType;
@property(nonatomic, strong)ModelWord* modelWord1;
@property(nonatomic, strong)ModelWord* modelWord2;
@property(nonatomic, strong)ModelWord* modelWord3;

@end


@class ModelArrowData,ModelKeyData;

@interface ModelWord : PVBaseModel

@property(nonatomic, copy)NSString* modelTitleUrlType;
@property(nonatomic, copy)NSString* modelTitleUrlId;
@property(nonatomic, copy)NSString* modelTitleTxt;
@property(nonatomic, copy)NSString* modelTitleImage;
@property(nonatomic, copy)NSString* modelJumpUrl;

@property(nonatomic, strong)ModelArrowData* modelArrowData;
@property(nonatomic, strong)ModelKeyData* modelKeyData;

@end


@interface ModelArrowData : PVBaseModel

@property(nonatomic, copy)NSString*  Arrow;
@property(nonatomic, copy)NSString*  ArrowType;
@property(nonatomic, copy)NSString*  ArrowId;
@property(nonatomic, copy)NSString*  ArrowTit;
@property(nonatomic, copy)NSString*  ArrowUrl;

@end



@interface ModelKeyData : PVBaseModel

@property(nonatomic, copy)NSString*  modelKey;
@property(nonatomic, copy)NSString*  modelKeyType;
@property(nonatomic, copy)NSString*  modelKeyId;
@property(nonatomic, copy)NSString*  modelKeyTxt;
@property(nonatomic, copy)NSString*  modelKeyUrl;

@end

