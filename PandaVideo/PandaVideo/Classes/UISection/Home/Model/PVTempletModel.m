//
//  PVTempletModel.m
//  PandaVideo
//
//  Created by cara on 17/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVTempletModel.h"

static NSString* timeFomatter = @"YYYY-MM-dd";


@interface   PVTempletModel()

@property(nonatomic, copy)UpdateCollectionView UpdateCollectionViewCallBlock;

@end

//

@implementation PVTempletModel


-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"type"]) {
        self.modelType = value;
    }else{
        [super setValue:value forKey:key];
    }
}
-(void)setUpdateCollectionView:(UpdateCollectionView)block{
    self.UpdateCollectionViewCallBlock = block;
}

-(void)setVideoTemletModel:(PVVideoTemletModel *)videoTemletModel{
    _videoTemletModel = videoTemletModel;
    if (self.modelType.integerValue == 14 ) {
        NSMutableArray* channelUrlArr = [NSMutableArray arrayWithCapacity:videoTemletModel.videoListModel.count];
        for (PVVideoListModel* videoListModel in videoTemletModel.videoListModel) {
            [channelUrlArr addObject:videoListModel.info.jsonUrl];
        }
        //发送请求频道的网络
        NSMutableArray* pramas = [NSMutableArray arrayWithCapacity:channelUrlArr.count];
        for (NSString* channelUrl in channelUrlArr) {
            PVNetModel* netModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:channelUrl param:nil];
            [pramas addObject:netModel];
        }
        [PVNetTool getMoreDataWithParams:pramas success:^(id result) {
            if (result != nil) {
                NSMutableArray* channels = [NSMutableArray arrayWithCapacity:pramas.count];
                for (int idx=0; idx<pramas.count; idx++) {
                    NSString* resultKey = [NSString stringWithFormat:@"%d",idx];
                    if (result[resultKey][@"channelInfo"] && [result[resultKey][@"channelInfo"] isKindOfClass:[NSDictionary class]]) {
                        PVLiveTelevisionChanelListModel* listModel = [[PVLiveTelevisionChanelListModel alloc]  init];
                        [listModel setValuesForKeysWithDictionary:result[resultKey][@"channelInfo"]];
                        videoTemletModel.videoListModel[idx].info.ChanelListModel = listModel;
                        [channels addObject:listModel];
                    }
                }
                ///请求频道对应的节目单
                [self loadPramas:videoTemletModel channelArr:channels];
            }
        } failure:^(NSArray *errors) {
            //提示网络错误
        }];
    }    
}
-(void)loadPramas:(PVVideoTemletModel *)videoTemletModel  channelArr:(NSArray*)channelArr{
    NSMutableArray* pramas = [NSMutableArray arrayWithCapacity:channelArr.count];
    
    for (PVLiveTelevisionChanelListModel* chanelListModel in channelArr) {
        PVNetModel* netModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:chanelListModel.programUrl param:nil];
        [pramas addObject:netModel];
    }
    [PVNetTool getMoreDataWithParams:pramas success:^(id result) {
        if (result != nil) {
            for (int idx=0; idx<channelArr.count; idx++) {
                NSString* resultKey = [NSString stringWithFormat:@"%d",idx];
                PVLiveTelevisionChanelListModel* chanelListModel = videoTemletModel.videoListModel[idx].info.ChanelListModel;
                if (result[resultKey] && [result[resultKey]  isKindOfClass:[NSArray class]]) {
                    NSMutableArray* tempResultArr = [NSMutableArray array];
                    for (NSDictionary* jsonDict in result[resultKey]) {
                        PVLiveTelevisionProGramModel* detailProGramModel = [[PVLiveTelevisionProGramModel alloc] init];
                        [detailProGramModel setValuesForKeysWithDictionary:jsonDict];
                        [tempResultArr addObject:detailProGramModel];
                        ///找出今天频道要请求的节目单
                        NSDate* todayDate = [NSDate PVDateStringToDate:detailProGramModel.date formatter:timeFomatter];
                        if ([todayDate isThisDay]) {
                            chanelListModel.nowProGramModel = detailProGramModel;
                        }
                    }
                    //对数组进行排序
                    NSArray* tempResult = [tempResultArr sortedArrayUsingComparator:^NSComparisonResult(PVLiveTelevisionProGramModel *obj1, PVLiveTelevisionProGramModel *obj2) {
                        return [obj2.date compare:obj1.date];
                    }];
                    [chanelListModel.programs addObjectsFromArray:tempResult];
                }
            }
            //请求频道今天的节目单
            [self loadPlayingProGram:videoTemletModel channelArr:channelArr];
        }
    } failure:^(NSArray *errors) {
    }];
}

-(void)loadPlayingProGram:(PVVideoTemletModel *)videoTemletModel  channelArr:(NSArray*)channelArr{
    
    //请求频道今天对应的节目单
    NSMutableArray* pramas = [NSMutableArray arrayWithCapacity:channelArr.count];
    for (PVVideoListModel* videoListModel in videoTemletModel.videoListModel) {
        PVNetModel* netModel = [[PVNetModel alloc]  initIsGetOrPost:true Url:videoListModel.info.ChanelListModel.nowProGramModel.programUrl param:nil];
        [pramas addObject:netModel];
    }
    [PVNetTool getMoreDataWithParams:pramas success:^(id result) {
        if (result != nil) {
            for (int idx=0; idx<pramas.count; idx++) {
                NSString* resultKey = [NSString stringWithFormat:@"%d",idx];
                PVLiveTelevisionChanelListModel* chanelListModel = self.videoTemletModel.videoListModel[idx].info.ChanelListModel;
                if (result[resultKey] && [result[resultKey]  isKindOfClass:[NSArray class]]) {
                    for (NSDictionary* jsonDict in result[resultKey]) {
                        PVLiveTelevisionDetailProGramModel*  detailProGramModel = [[PVLiveTelevisionDetailProGramModel alloc]  init];
                        [detailProGramModel setValuesForKeysWithDictionary:jsonDict];
                        [detailProGramModel calculationProgramTime:chanelListModel.nowProGramModel.date];
                        if (detailProGramModel.type == 3) {
                            chanelListModel.nowDetailProGramModel = detailProGramModel;
                        }
                        [chanelListModel.nowProGramModel.programs addObject:detailProGramModel];
                        if (chanelListModel.nowProGramModel.type == 1) {
                            [chanelListModel.nowProGramModel selectTodayProgramAppointMentStatus];
                        }
                    }
                }
                
            }
            //发出通知更新UI
            if (self.UpdateCollectionViewCallBlock) {
                self.UpdateCollectionViewCallBlock();
            }
        }
    } failure:^(NSArray *errors) {
    }];
}
-(NSMutableArray *)modelDataSource{
    if (!_modelDataSource) {
        _modelDataSource = [NSMutableArray array];
    }
    return _modelDataSource;
}



@end

