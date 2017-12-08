//
//  PVDBManager.h
//  PandaVideo
//
//  Created by cara on 17/9/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVDemandVideoAnthologyModel.h"
#import "PVHomModel.h"
#import "PVAssociationKeyWordModel.h"
#import "PVNoticeInfoModel.h"
#import "SCAssetModel.h"
#import "PVAppStorePurchaseModel.h"

@class PVLiveTelevisionChanelListModel,PVLiveTelevisionProGramModel,PVLiveTelevisionDetailProGramModel;

@interface PVDBManager : NSObject

+(PVDBManager *)sharedInstance;



///联想词数据
@property(nonatomic, strong)NSMutableArray* associationKeyWordDataSource;

//添加一条搜索数据
-(void)insertHistoryName:(NSString*)historyName;

//查询所有搜索数据
-(NSArray *)selectAllData;

//删除全部搜索数据
-(BOOL)deleteAllData;

//添加一个频道数据
-(void)insertLiveChannelModel:(PVLiveTelevisionChanelListModel*)chanelListModel;

//删除一个频道数据
-(void)deleteLiveChannelModel:(PVLiveTelevisionChanelListModel*)chanelListModel;

//查看全部频道数据
-(NSArray *)selectLiveChannelAllData;

//查看一个频道是否存在
-(BOOL)selectChanelListModelIsCollect:(PVLiveTelevisionChanelListModel*)chanelListModel;

///---------------------今天频道中节目单预约状态-----------------------
//添加一个频道今天节目单的数据
-(void)insertLiveChannelAllProgram:(PVLiveTelevisionProGramModel*)proGramModel;
//更换一个节目单数据
-(void)updateLiveChannelProgramModel:(PVLiveTelevisionDetailProGramModel*)detailProGramModel;
//查看全部节目单数据
-(NSArray *)selectLiveChannelAllProgramData;
//查看一个节目单数据是否预约
-(BOOL)selectLiveChannelDetailProgram:(PVLiveTelevisionDetailProGramModel*)detailProGramModel;
//删除节目单
-(BOOL)deleteLiveChannelAllProgram;

///---------------------观看视频记录-----------------------
//添加一个观看视频数据
-(void)insertVisitVideoModel:(PVDemandVideoAnthologyModel*)videoAnthologyModel;
//删除一个观看视频数据
-(BOOL)deleteVisitVideoModel:(PVDemandVideoAnthologyModel*)videoAnthologyModel;
//查看全部视频观看数据
-(NSArray *)selectVisitVideoAllData;
//删除全部观看数据
-(BOOL)deleteAllVisitVideoData;

///---------------------收藏视频记录-----------------------
//添加一个收藏视频数据
-(void)insertCollectVideoModel:(PVDemandVideoAnthologyModel*)videoAnthologyModel;
//删除一个收藏视频数据
-(BOOL)deleteCollectVideoModel:(PVDemandVideoAnthologyModel*)videoAnthologyModel;
//查看全部视频收藏数据
-(NSArray *)selectCollectVideoAllData;
//删除全部收藏数据
-(BOOL)deleteAllCollectVideoData;



///---------------------栏目编辑-----------------------
//添加一个栏目
-(void)insertPVHomModel:(PVHomModel*)homModel;
//查看全部栏目数据
-(NSArray *)selectPVHomModeAllData;
//删除全部栏目
-(BOOL)deleteAllPVHomModelData;


///---------------------搜索关键词联想-----------------------
//添加所有关键词联想
-(void)insertAllPVAssociationKeyWord:(NSArray<PVAssociationKeyWordModel*>*)keyWords;
//查看所有关键词联想
-(NSArray *)selectPVAssociationKeyWordAllData;
//删除所有关键词联想
-(BOOL)deleteAllPVAssociationKeyWord;

//------------------------系统消息-----------------------------------
//插入系统通知消息
- (BOOL)insertSystemNotificationWithModel:(PVNoticeInfoModel *)infoModel;
//查看所有系统通知消息
-(NSMutableArray *)selectPVSystemNotificationAllData;
//删除某条系统通知消息
- (BOOL)deleteSystemNotificationWithData:(PVNoticeInfoModel *)infoModel;
//删除系统通知消息
-(BOOL)deleteAllPVSystemNotificationData;


//--------------------------视频数据---------------------------------------
//插入UGC视频数据
- (BOOL)insertShortVideoModelWithModel:(SCAssetModel *)infoModel;
//查看所有UGC视频数据
-(NSMutableArray *)selectShortVideoModelAllData;
//删除某条UGC视频数据
- (BOOL)deleteShortVideoModelWithData:(SCAssetModel *)infoModel;
//删除所有UGC视频数据
-(BOOL)deleteAllShortVideoModelData;

//--------------------------订单数据---------------------------------------
//插入订单数据
- (BOOL)insertPurchaseOrderModelWithModel:(PVAppStorePurchaseModel *)orderModel;
//根据订单交易ID删除某条订单数据
- (BOOL)deletePurchaseOrderModelWithpurchaseOrderId:(NSString *)purchaseOrderId;
//查看所有订单数据
-(NSMutableArray *)selectPurchaseOrderModelAllData;
//删除某条订单数据
- (BOOL)deletePurchaseOrderModelWithData:(PVAppStorePurchaseModel *)infoModel;
//删除所有订单数据
-(BOOL)deleteAllPurchaseOrderModelData;
@end
