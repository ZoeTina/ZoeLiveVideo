//
//  PVAlertModel.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

/**弹窗类型，只有文字的，和图文弹窗**/
typedef NS_ENUM(NSInteger,AlertViewType) {
    OnlyText = 0,
    ImageAndText = 1,
    BottomAlert = 2,
};

/**图文弹窗的图片位置，居左还是居右*/
typedef NS_ENUM(NSInteger, ImagePosition) {
        Left = 0,
        Right = 1,
};

@interface PVAlertModel : NSObject
@property (nonatomic, copy) NSString *alertTitle;  //弹窗标题，
@property (nonatomic, copy) NSString *descript;    //弹窗描述，必填
@property (nonatomic, copy) NSString *imageName;   //图文弹窗的图片名字，对于图文弹窗类型必填
@property (nonatomic, copy) NSString *cancleButtonName;  //取消按钮的名字，响应的是弹窗隐藏事件，必填
@property (nonatomic, copy) NSString *eventName;    //弹窗的事件按钮名字，响应的是弹窗的提示内容需要的交互事件，选填

@property (nonatomic, strong) NSArray *imagesArray; //底部弹窗的照片名字数，其他类型不需要
@property (nonatomic, strong) NSArray *imagesTextArray; //底部弹窗的按钮名字数组，其他类型不需要

@property (nonatomic, assign) ImagePosition imagePosition;  //图文弹窗的图片位置
@property (nonatomic, assign) AlertViewType alertType;  //弹窗类型，必填

@end
