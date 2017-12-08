//
//  PVIntroduceModel.h
//  PandaVideo
//
//  Created by Ensem on 2017/10/25.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CodeRateList,LZInfo,LZReview;

@interface PVIntroduceModel : PVBaseModel
/** 直播机构名称 */
@property(nonatomic, copy) NSString *organizationName;
/** 直播类型(1.系列直播，2.单场直播) */
@property(nonatomic, copy) NSString *liveType;
@property(nonatomic, copy) NSString *verPic;
/** 直播标题 */
@property(nonatomic, copy) NSString *liveTitle;
/** 在线人数 */
@property(nonatomic, copy) NSString *liveAudienceCount;
/** 直播ID */
@property(nonatomic, copy) NSString *liveId;
/** 直播系列ID */
@property(nonatomic, copy) NSString *parentId;
/** 直播LOGO */
@property(nonatomic, copy) NSString *logoUrl;
/** 快捷回复模板Url */
@property(nonatomic, copy) NSString *quickReplyModelUrl;
/** 分享URL */
@property(nonatomic, copy) NSString *shareH5Url;
@property(nonatomic, copy) NSString *horPic;
/** 直播地址 */
@property(nonatomic, copy) NSString *liveUrl;
@property(nonatomic, copy) NSString *liveTime;
@property(nonatomic, copy) NSString *giftModel;
/** 直播状态(0：预告；1：直播；2：回看)*/
@property(nonatomic, copy) NSString *liveState;
@property(nonatomic, strong) NSMutableArray<CodeRateList *> *codeRateList;
@property(nonatomic, strong) LZInfo *info;
@property(nonatomic, strong) LZReview *review;

@end

@interface CodeRateList : PVBaseModel

/** 码率显示名 */
@property(nonatomic, copy)NSString *showName;
/** 码率M3U8文件名 */
@property(nonatomic, copy)NSString *rateFileUrl;
/** 排序 */
@property(nonatomic, copy)NSString *sort;
/** 默认播放 */
@property(nonatomic, copy)NSString *isDefaultRate;
@property(nonatomic, assign)BOOL isSelected;

@end


@interface LZReview : PVBaseModel

@property(nonatomic, copy)NSString *reviewUrl;
@property(nonatomic, copy)NSString *reviewCode;
@property(nonatomic, copy)NSString *reviewName;

@end

@interface LZInfo : PVBaseModel

/** 活动信息 */
@property(nonatomic, copy)NSString *actInfo;
/** 图片介绍 */
@property(nonatomic, copy)NSString *image;
/** 组织信息 */
@property(nonatomic, copy)NSString *organizationInfo;

@end
//"barrage": true,
//"organizationName": "机构名称",
//"codeRateList": [{
//    "showName": "高清",
//    "rateFileUrl": "1.m3u8",
//    "sort": "1",
//    "isDefaultRate": "false"
//},
//                 {
//                     "showName": "标清",
//                     "rateFileUrl": "2.m3u8",
//                     "sort": "1",
//                     "isDefaultRate": "true"
//                 },
//                 {
//                     "showName": "流畅",
//                     "rateFileUrl": "3.m3u8",
//                     "sort": "1",
//                     "isDefaultRate": "false"
//                 }],
//"liveType": 2,
//"verPic": "http://182.138.102.131:8080/App2/Images/2017/10/22/20171022151822864sdyvlvefou.jpg",
//"liveTitle": "直播名称xx",
//"liveAudienceCount": 9999,
//"liveId": "8c265fb9032848d0bb8b08f98cb7f17e",
//"parentId": "c2b7aec76e1149579b70eccbf88d694c",
//"logoUrl": "http://182.138.102.131:8080/App2/Images/2017/09/03/g1.png",
//"quickReplyModelUrl": "快捷回复模板Url未确定",
//"shareH5Url": "分享URL未确定",
//"horPic": "http://182.138.102.131:8080/App2/Images/2017/10/22/20171022151818605vhmzjipkqv.jpg",
//"liveUrl": "http://101.207.176.15/sdlive/cctv13/index.m3u8",
//"liveTime": "2017-09-19 00:00:00",
//"giftModel": "礼品模板Url未确定",
//"info": {
//    "actInfo": "活动简介：说什么好呢。。。都是秘密",
//    "image": "http://182.138.102.131:8080/App2/Images/2017/09/03/g1.png",
//    "organizationInfo": "机构简介：哈哈哈哈"
//},
//"liveState": 2

@interface PVIntroduceMoneyModel : NSObject
/** 账户余额 */
@property (nonatomic, copy) NSString *balance;
@end
