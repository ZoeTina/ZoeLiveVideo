//
//  PVDBManager.m
//  PandaVideo
//
//  Created by cara on 17/9/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDBManager.h"
#import "FMDatabase.h"
#import "SearchHistory.h"
#import "PVHistoryModel.h"
#import "PVCollectionModel.h"
#import "PVLiveTelevisionChanelListModel.h"


@implementation PVDBManager
{
    //数据库对象
    FMDatabase *_database;
}

//获取单例对象
+(PVDBManager *)sharedInstance{
    static PVDBManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager=[[PVDBManager alloc]init];
    });
    return manager;
}

-(instancetype)init{
    if(self=[super init])
    {
        [self createDataBase];
    }
    return self;
}

-(void)createDataBase{
    NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/PVVideo.sqlite"];
    NSLog(@"pat=%@",path);
    _database=[[FMDatabase alloc] initWithPath:path];
    BOOL ret=[_database open];
    if(!ret) {
        NSLog(@"数据库打开失败:%@",_database.lastErrorMessage);
    }else{
        
        //创建搜索历史表
        NSString *createSearchHistorysql=@"create table if not exists SearchHistory (historyName varchar(1024))";
        BOOL flagSearchHistory=[_database executeUpdate:createSearchHistorysql];
        if(!flagSearchHistory){
            NSLog(@"创建搜索表格失败:%@",_database.lastErrorMessage);
        }
        
        //创建直播频道收藏列表
        NSString *createLiveChannelSql=@"create table if not exists LiveChannel (channelId varchar(1024),channelLogo varchar(1024),channelName varchar(1024),channelShareUrl varchar(1024),channelTag varchar(1024),channelType varchar(1024),liveUrl varchar(1024),lookbackUrl varchar(1024),programDateUrl varchar(1024),sort varchar(1024),codeRateLists blob)";
        BOOL flagLiveChannel=[_database executeUpdate:createLiveChannelSql];
        if(!flagLiveChannel){
            NSLog(@"创建直播频道收藏列表表格失败:%@",_database.lastErrorMessage);
        }
        
        //创建今天节目单预约状态
        NSString *createLiveChannelProgramSql=@"create table if not exists PVDetailProGramModel (programId varchar(1024),appointMentStatus varchar(1024))";
        BOOL flagLiveChannelProgram=[_database executeUpdate:createLiveChannelProgramSql];
        if(!flagLiveChannelProgram){
            NSLog(@"创建直播频道收藏列表表格失败:%@",_database.lastErrorMessage);
        }
        
        //创建观看视频列表
        NSString *createDemandVisitVideoSql=@"create table if not exists DemandVisitVideo (videoUrl varchar(1024),videoName varchar(1024),videoType varchar(1024),verticalPic varchar(1024),code varchar(1024),playStopTime varchar(1024),playVideoLength varchar(1024),totalVideoLength varchar(1024))";
        BOOL flagDemandVisitVideo=[_database executeUpdate:createDemandVisitVideoSql];
        if(!flagDemandVisitVideo){
            NSLog(@"创建观看视频表格失败:%@",_database.lastErrorMessage);
        }
        
        //创建收藏视频列表
        NSString *createDemandCollectVideoSql=@"create table if not exists DemandCollectVideo (code varchar(1024),videoUrl varchar(1024),icon varchar(1024),title varchar(1024),time varchar(1024),videoType varchar(1024),playStopTime varchar(1024),jsonUrl varchar(1024))";
        BOOL flagDemandCollectVideo=[_database executeUpdate:createDemandCollectVideoSql];
        if(!flagDemandCollectVideo){
            NSLog(@"创建收藏视频表格失败:%@",_database.lastErrorMessage);
        }
        
        //栏目
        NSString *createHomeColumnSql=@"create table if not exists PVHomeColumn (columId varchar(1024),columName varchar(1024))";
        BOOL flagHomeColumnSql=[_database executeUpdate:createHomeColumnSql];
        if(!flagHomeColumnSql){
            NSLog(@"创建栏目表格失败:%@",_database.lastErrorMessage);
        }
        
        //联想关键词
        NSString *createPVAssociationKeyWord=@"create table if not exists PVAssociationKeyWord (hotDegree varchar(1024),kId varchar(1024),word varchar(1024),lowerWord varchar(1024))";
        BOOL flagPVAssociationKeyWordSql=[_database executeUpdate:createPVAssociationKeyWord];
        if(!flagPVAssociationKeyWordSql){
            NSLog(@"创建联想关键词表格失败:%@",_database.lastErrorMessage);
        }
        
        //系统通知
        NSString *createPVSystemNotice=@"create table if not exists PVSystemNotice (msgId varchar(1024),title varchar(1024),jsonUrl varchar(1024))";
        BOOL flagPVSystemNoticeSql=[_database executeUpdate:createPVSystemNotice];
        if(!flagPVSystemNoticeSql){
            NSLog(@"创建系统消息表格失败:%@",_database.lastErrorMessage);
        }
        
        //ugc视频
        NSString *createUGCVideo=@"create table if not exists UGCVideo (creationDate varchar(1024),timeLength varchar(1024),videoState varchar(1024),publishTime varchar(1024),videoTitle varchar(1024), videoCorverImage varchar(1024), videoDescTitle varchar(1024),corverImageData blob,assetInentifier varchar(1024),videoInfoData blob)";
        BOOL flagUGCVideoSql=[_database executeUpdate:createUGCVideo];
        if(!flagUGCVideoSql){
            NSLog(@"创建UGC表格失败:%@",_database.lastErrorMessage);
        }
        
        //订单
        NSString *createPurchaseOrder=@"create table if not exists PurchaseOrder (purchaseOrderId varchar(1024),orderTestStr varchar(1024),code varchar(1024))";
        BOOL flagPurchaseOrderSql=[_database executeUpdate:createPurchaseOrder];
        if(!flagPurchaseOrderSql){
            NSLog(@"创建订单表格失败:%@",_database.lastErrorMessage);
        }
        
    }
}

//-----------------------直播频道列表--------------------
-(void)insertLiveChannelModel:(PVLiveTelevisionChanelListModel*)chanelListModel{
    NSString *insertsql = @"insert into LiveChannel (channelId,channelLogo,channelName,channelShareUrl,channelTag,channelType,liveUrl,lookbackUrl,programDateUrl,sort,codeRateLists) values (?,?,?,?,?,?,?,?,?,?,?)";
        
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:chanelListModel.codeRateLists];
    BOOL ret=[_database executeUpdate:insertsql,chanelListModel.channelId,chanelListModel.channelLogo,chanelListModel.channelName,chanelListModel.channelShareUrl,chanelListModel.channelTag,chanelListModel.channelType,chanelListModel.liveUrl,chanelListModel.lookbackUrl,chanelListModel.programDateUrl,chanelListModel.sort,data];
    if(!ret)
    {
        NSLog(@"添加失败:%@",_database.lastErrorMessage);
    }

}

-(void)deleteLiveChannelModel:(PVLiveTelevisionChanelListModel*)chanelListModel{
    NSString *deletesql=@"delete from LiveChannel where channelId=?";
    BOOL ret=[_database executeUpdate:deletesql,chanelListModel.channelId];
    if(!ret)
    {
        NSLog(@"删除用户失败:%@",_database.lastErrorMessage);
    }
}

-(NSArray *)selectLiveChannelAllData{
    NSString *selectsql= [NSString stringWithFormat:@"select * from LiveChannel"];
    FMResultSet *set=[_database executeQuery:selectsql];
    NSMutableArray *array=[NSMutableArray array];
    while ([set next]) {
        PVLiveTelevisionChanelListModel*chanelListModel  = [[PVLiveTelevisionChanelListModel alloc]  init];
        chanelListModel.channelId=[set stringForColumn:@"channelId"];
        chanelListModel.channelLogo=[set stringForColumn:@"channelLogo"];
        chanelListModel.channelName=[set stringForColumn:@"channelName"];
        chanelListModel.channelShareUrl=[set stringForColumn:@"channelShareUrl"];
        chanelListModel.channelTag=[set stringForColumn:@"channelTag"];
        chanelListModel.channelType=[set stringForColumn:@"channelType"];
        chanelListModel.liveUrl=[set stringForColumn:@"liveUrl"];
        chanelListModel.lookbackUrl=[set stringForColumn:@"lookbackUrl"];
        chanelListModel.programDateUrl=[set stringForColumn:@"programDateUrl"];
        chanelListModel.sort=[set stringForColumn:@"sort"];
        chanelListModel.copyright=@"0";
        chanelListModel.valiDataCode=@"1";
        chanelListModel.area=@"2";
        NSData* data = [set  dataForColumn:@"codeRateLists"];
        NSArray* jsonObject =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [chanelListModel.codeRateLists addObjectsFromArray:jsonObject];
        [array addObject:chanelListModel];
        
    }
   // NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
    return array;
}
-(BOOL)selectChanelListModelIsCollect:(PVLiveTelevisionChanelListModel*)chanelListModel{
    NSArray* array = [self selectLiveChannelAllData];
    for (PVLiveTelevisionChanelListModel* tempChanelListModel in array) {
        if ([tempChanelListModel.channelId isEqualToString:chanelListModel.channelId]) {
            return true;
            break;
        }
    }
    
    return false;

}

//-----------------------搜索相关--------------------
-(void)insertHistoryName:(NSString*)historyName{
    
    NSString *insertsql = @"";
    NSArray* namesArr = [self selectAllData];
    BOOL isHaveSame = false;
    for (NSString* tempString in namesArr) {
        if ([tempString isEqualToString:historyName]) {//删除旧的一条
            [self deleteSearchHistoryWithHistoryName:tempString];
            isHaveSame = true;
            break;
        }
    }
    if (namesArr.count > 5 && !isHaveSame) {
        [self deleteSearchHistoryWithHistoryName:namesArr.lastObject];
    }
    insertsql=@"insert into SearchHistory (historyName) values (?)";
    BOOL ret=[_database executeUpdate:insertsql,historyName];
    if(!ret)
    {
        NSLog(@"添加失败:%@",_database.lastErrorMessage);
    }
}
-(void)deleteSearchHistoryWithHistoryName:(NSString*)historyName{
    NSString *deletesql=@"delete from SearchHistory where historyName=?";
    BOOL ret=[_database executeUpdate:deletesql,historyName];
    if(!ret)
    {
        NSLog(@"删除用户失败:%@",_database.lastErrorMessage);
    }
}
-(BOOL)deleteAllData{
    NSString *sqlstr = [NSString stringWithFormat:@"delete from SearchHistory"];
    if (![_database executeUpdate:sqlstr])
    {
        PVLog(@"Delete table error!");
        return NO;
    }
    return YES;
}
-(NSArray *)selectAllData{
    NSString *selectsql= [NSString stringWithFormat:@"select * from SearchHistory"];
    FMResultSet *set=[_database executeQuery:selectsql];
    NSMutableArray *array=[NSMutableArray array];
    while ([set next]) {
        NSString* historyName=[set stringForColumn:@"historyName"];
        [array addObject:historyName];
    }
    NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
    return reversedArray;
}
-(void)updateModel:(id )model modifyId:(NSString*)modifyId;{
    NSString *updatesql=@"update SearchHistory set historyName=? where index=?";
    SearchHistory* historyModel = (SearchHistory*)model;
    BOOL ret=[_database executeUpdate:updatesql,historyModel.historyName];
    if(!ret)
    {
        NSLog(@"修改失败:%@",_database.lastErrorMessage);
    }
}


//---------------------今天频道中节目单预约状态-----------------------
//添加一个频道今天节目单的数据
-(void)insertLiveChannelAllProgram:(PVLiveTelevisionProGramModel*)proGramModel{
    [self deleteLiveChannelAllProgram];
    for (PVLiveTelevisionDetailProGramModel* detailProGramModel in proGramModel.programs) {
        NSString *insertsql = @"insert into PVDetailProGramModel (programId,appointMentStatus) values (?,?)";
        BOOL ret=[_database executeUpdate:insertsql,detailProGramModel.programId,detailProGramModel.appointMentStatus];
        if(!ret)
        {
            NSLog(@"添加失败:%@",_database.lastErrorMessage);
        }
    }
}
//更换一个节目单数据
-(void)updateLiveChannelProgramModel:(PVLiveTelevisionDetailProGramModel*)detailProGramModel{
    NSString *deletesql=@"delete from PVDetailProGramModel where programId=?";
    [_database executeUpdate:deletesql,detailProGramModel.programId];
    NSString *insertsql = @"insert into PVDetailProGramModel (programId,appointMentStatus) values (?,?)";
    [_database executeUpdate:insertsql,detailProGramModel.programId,detailProGramModel.appointMentStatus];
}
//查看全部节目单数据
-(NSArray *)selectLiveChannelAllProgramData{
    NSString *selectsql= [NSString stringWithFormat:@"select * from PVDetailProGramModel"];
    FMResultSet *set=[_database executeQuery:selectsql];
    NSMutableArray *array=[NSMutableArray array];
    while ([set next]) {
        PVLiveTelevisionDetailProGramModel* detailProGramModel = [[PVLiveTelevisionDetailProGramModel alloc]  init];
        detailProGramModel.programId=[set stringForColumn:@"programId"];
        detailProGramModel.appointMentStatus=[set stringForColumn:@"appointMentStatus"];
        [array addObject:detailProGramModel];
    }
    return array;
}
//查看一个节目单数据是否预约
-(BOOL)selectLiveChannelDetailProgram:(PVLiveTelevisionDetailProGramModel*)detailProGramModel{
    NSArray* array = [self selectLiveChannelAllProgramData];
    for (PVLiveTelevisionDetailProGramModel* resultDetailProGramModel in array) {
        if ([detailProGramModel.programId isEqualToString:resultDetailProGramModel.programId]) {
            if (resultDetailProGramModel.appointMentStatus.integerValue == 1) {
                return true;
            }else{
                return false;
            }
        }
    }
    return false;
}
-(BOOL)deleteLiveChannelAllProgram{
    
    NSString *sqlstr = [NSString stringWithFormat:@"delete from PVDetailProGramModel"];
    if (![_database executeUpdate:sqlstr])
    {
        PVLog(@"Delete table error!");
        return NO;
    }
    return YES;
}
//-----------------------视频观看相关--------------------
//添加一个观看视频数据
-(void)insertVisitVideoModel:(PVDemandVideoAnthologyModel*)videoAnthologyModel{
    [self deleteVisitVideoModel:videoAnthologyModel];
    NSString *insertsql = @"insert into DemandVisitVideo (videoUrl,videoName,videoType,verticalPic,code,playStopTime,playVideoLength,totalVideoLength,jsonUrl) values (?,?,?,?,?,?,?,?,?)";
    BOOL ret=[_database executeUpdate:insertsql,videoAnthologyModel.videoUrl,videoAnthologyModel.videoName,videoAnthologyModel.videoType,videoAnthologyModel.verticalPic,videoAnthologyModel.code,videoAnthologyModel.playStopTime,videoAnthologyModel.playVideoLength,videoAnthologyModel.totalVideoLength,videoAnthologyModel.jsonUrl];
    if(!ret)
    {
        NSLog(@"添加失败:%@",_database.lastErrorMessage);
    }
}
//删除一个观看视频数据
-(BOOL)deleteVisitVideoModel:(PVDemandVideoAnthologyModel*)videoAnthologyModel{
    NSString *deletesql=@"delete from DemandVisitVideo where code=?";
    BOOL ret=[_database executeUpdate:deletesql,videoAnthologyModel.code];
    if(!ret)
    {
        NSLog(@"删除用户失败:%@",_database.lastErrorMessage);
    }
    return ret;
}
//查看全部视频观看数据
-(NSArray *)selectVisitVideoAllData{
    NSString *selectsql= [NSString stringWithFormat:@"select * from DemandVisitVideo"];
    FMResultSet *set=[_database executeQuery:selectsql];
    NSMutableArray *array=[NSMutableArray array];
    while ([set next]) {
        PVHistoryModel* historyModel = [[PVHistoryModel alloc]  init];
        historyModel.time=[set stringForColumn:@"playStopTime"];
        historyModel.playLength=[set stringForColumn:@"playVideoLength"].integerValue;
        historyModel.title = [set stringForColumn:@"videoName"];
        historyModel.code = [set stringForColumn:@"code"];
        historyModel.videoType = [set stringForColumn:@"videoType"].integerValue;
        historyModel.videoUrl = [set stringForColumn:@"videoUrl"];
        historyModel.icon = [set stringForColumn:@"verticalPic"];
        historyModel.length = [set stringForColumn:@"totalVideoLength"];
        historyModel.jsonUrl = [set stringForColumn:@"jsonUrl"];
        [array addObject:historyModel];
    }
    NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
    return reversedArray;
    
}
//删除全部观看数据
-(BOOL)deleteAllVisitVideoData{
    NSString *sqlstr = [NSString stringWithFormat:@"delete from DemandVisitVideo"];
    if (![_database executeUpdate:sqlstr])
    {
        PVLog(@"Delete table error!");
        return NO;
    }
    return YES;
}

//-----------------------收藏视频相关--------------------
//添加一个收藏视频数据
-(void)insertCollectVideoModel:(PVDemandVideoAnthologyModel*)videoAnthologyModel{
    [self deleteCollectVideoModel:videoAnthologyModel];
    NSString *insertsql = @"insert into DemandCollectVideo (code,videoUrl,icon,title,time,videoType,playStopTime,jsonUrl) values (?,?,?,?,?,?,?,?)";
    BOOL ret=[_database executeUpdate:insertsql,videoAnthologyModel.code,videoAnthologyModel.videoUrl,videoAnthologyModel.verticalPic,videoAnthologyModel.videoName,videoAnthologyModel.totalVideoLength,videoAnthologyModel.videoType,videoAnthologyModel.playStopTime,videoAnthologyModel.jsonUrl];
    if(!ret)
    {
        NSLog(@"添加失败:%@",_database.lastErrorMessage);
    }
}

//删除一个收藏视频数据
-(BOOL)deleteCollectVideoModel:(PVDemandVideoAnthologyModel*)videoAnthologyModel{
    NSString *deletesql=@"delete from DemandCollectVideo where code=?";
    BOOL ret=[_database executeUpdate:deletesql,videoAnthologyModel.code];
    if(!ret)
    {
        NSLog(@"删除用户失败:%@",_database.lastErrorMessage);
    }
    return ret;
}

//查看全部视频收藏数据
-(NSArray *)selectCollectVideoAllData{
    NSString *selectsql= [NSString stringWithFormat:@"select * from DemandCollectVideo"];
    FMResultSet *set=[_database executeQuery:selectsql];
    NSMutableArray *array=[NSMutableArray array];
    while ([set next]) {
        PVCollectionModel* collectionModel = [[PVCollectionModel alloc]  init];
        collectionModel.cololectTime=[set stringForColumn:@"playStopTime"];
        collectionModel.time=[set stringForColumn:@"time"];
        collectionModel.title = [set stringForColumn:@"title"];
        collectionModel.code = [set stringForColumn:@"code"];
        collectionModel.videoType = [set stringForColumn:@"videoType"];
        collectionModel.videoUrl = [set stringForColumn:@"videoUrl"];
        collectionModel.icon = [set stringForColumn:@"icon"];
        collectionModel.jsonUrl = [set stringForColumn:@"jsonUrl"];
        [array addObject:collectionModel];
    }
    NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
    return reversedArray;
}
//删除全部收藏数据
-(BOOL)deleteAllCollectVideoData{
    NSString *sqlstr = [NSString stringWithFormat:@"delete from DemandCollectVideo"];
    if (![_database executeUpdate:sqlstr])
    {
        PVLog(@"Delete table error!");
        return NO;
    }
    return YES;
}

///---------------------栏目编辑-----------------------
//添加一个栏目
-(void)insertPVHomModel:(PVHomModel*)homModel{
    [self deletePVHomModelData:homModel];
    NSString *insertsql = @"insert into PVHomeColumn (columId,columName) values (?,?)";
    BOOL ret=[_database executeUpdate:insertsql,homModel.columId,homModel.columName];
    if(!ret)
    {
        NSLog(@"添加失败:%@",_database.lastErrorMessage);
    }
    
}
//查看全部栏目数据
-(NSArray *)selectPVHomModeAllData{
    NSString *selectsql= [NSString stringWithFormat:@"select * from PVHomeColumn"];
    FMResultSet *set=[_database executeQuery:selectsql];
    NSMutableArray *array=[NSMutableArray array];
    while ([set next]) {
        PVHomModel* homeModel = [[PVHomModel alloc]  init];
        homeModel.columName = [set stringForColumn:@"columName"];
        [array addObject:homeModel];
    }
    return array;
}
//删除一个栏目
-(BOOL)deletePVHomModelData:(PVHomModel*)homModel{
    NSString *deletesql=@"delete from PVHomeColumn where columName=?";
    BOOL ret=[_database executeUpdate:deletesql,homModel.columName];
    if(!ret)
    {
        NSLog(@"删除失败:%@",_database.lastErrorMessage);
    }
    return ret;
}
//删除全部栏目
-(BOOL)deleteAllPVHomModelData{
    NSString *sqlstr = [NSString stringWithFormat:@"delete from PVHomeColumn"];
    if (![_database executeUpdate:sqlstr])
    {
        PVLog(@"Delete table error!");
        return NO;
    }
    return YES;
}


///---------------------搜索关键词联想-----------------------
//添加所有关键词联想
-(void)insertAllPVAssociationKeyWord:(NSArray<PVAssociationKeyWordModel*>*)keyWords{
    [self deleteAllPVAssociationKeyWord];
    for (PVAssociationKeyWordModel* keyWordModel in keyWords) {
        NSString *insertsql = @"insert into PVAssociationKeyWord (hotDegree,kId,word,lowerWord) values (?,?,?,?)";
        BOOL ret=[_database executeUpdate:insertsql,keyWordModel.hotDegree,keyWordModel.kId,keyWordModel.word,keyWordModel.lowerWord];
        if(!ret)
        {
            NSLog(@"添加失败:%@",_database.lastErrorMessage);
        }
    }
}
//查看所有关键词联想
-(NSArray *)selectPVAssociationKeyWordAllData{
    NSString *selectsql= [NSString stringWithFormat:@"select * from PVAssociationKeyWord"];
    FMResultSet *set=[_database executeQuery:selectsql];
    NSMutableArray *array=[NSMutableArray array];
    while ([set next]) {
        PVAssociationKeyWordModel* keyWordModel = [[PVAssociationKeyWordModel alloc]  init];
        keyWordModel.hotDegree = [set stringForColumn:@"hotDegree"];
        keyWordModel.kId = [set stringForColumn:@"kId"];
        keyWordModel.word = [set stringForColumn:@"word"];
        keyWordModel.lowerWord = [set stringForColumn:@"lowerWord"];
        [array addObject:keyWordModel];
    }
    return array;
}
//删除所有关键词联想
-(BOOL)deleteAllPVAssociationKeyWord{
    NSString *sqlstr = [NSString stringWithFormat:@"delete from PVAssociationKeyWord"];
    if (![_database executeUpdate:sqlstr])
    {
        PVLog(@"Delete table error!");
        return NO;
    }
    return YES;
}


//插入系统通知消息
- (BOOL)insertSystemNotificationWithModel:(PVNoticeInfoModel *)infoModel {
    NSString *insertsql = @"insert into PVSystemNotice (msgId,title,jsonUrl) values (?,?,?)";
    BOOL ret=[_database executeUpdate:insertsql,infoModel.msgId,infoModel.title,infoModel.jsonUrl];
    if(!ret)
    {
        NSLog(@"添加失败:%@",_database.lastErrorMessage);
    }
    return ret;
}

//查看所有系统通知消息
-(NSMutableArray *)selectPVSystemNotificationAllData{
    NSString *selectsql= [NSString stringWithFormat:@"select * from PVSystemNotice"];
    FMResultSet *set=[_database executeQuery:selectsql];
    NSMutableArray *array=[NSMutableArray array];
    while ([set next]) {
        PVNoticeInfoModel* keyWordModel = [[PVNoticeInfoModel alloc]  init];
        keyWordModel.msgId = [set stringForColumn:@"msgId"];
        keyWordModel.title = [set stringForColumn:@"title"];
        keyWordModel.jsonUrl = [set stringForColumn:@"jsonUrl"];
        [array addObject:keyWordModel];
    }
    return array;
}

//删除某条系统通知消息
- (BOOL)deleteSystemNotificationWithData:(PVNoticeInfoModel *)infoModel {
    NSString *deletesql=@"delete from PVSystemNotice where msgId=?";
    BOOL ret=[_database executeUpdate:deletesql,infoModel.msgId];
    if(!ret)
    {
        NSLog(@"删除失败:%@",_database.lastErrorMessage);
    }
    return ret;
}

//删除所有系统通知消息
-(BOOL)deleteAllPVSystemNotificationData{
    NSString *sqlstr = [NSString stringWithFormat:@"delete from PVSystemNotice"];
    if (![_database executeUpdate:sqlstr])
    {
        PVLog(@"Delete table error!");
        return NO;
    }
    return YES;
}


//插入UGC视频数据
- (BOOL)insertShortVideoModelWithModel:(SCAssetModel *)infoModel {
    [self deleteShortVideoModelWithData:infoModel];
    
    NSString *insertSql = @"insert into UGCVideo (creationDate,timeLength,videoState,publishTime,videoTitle,videoCorverImage,videoDescTitle,corverImageData,assetInentifier,videoInfoData) values (?,?,?,?,?,?,?,?,?,?)";
    
    BOOL ret=[_database executeUpdate:insertSql,infoModel.createTime,infoModel.timeLength,infoModel.videoPublishState,infoModel.publishTime, infoModel.videoTitle, infoModel.videoCorverImage, infoModel.videoDescTitle,infoModel.corverImageData,infoModel.assetInentifier,infoModel.videoInfoData];
    if(!ret)
    {
        NSLog(@"添加失败:%@",_database.lastErrorMessage);
    }
    return ret;
}

//查看所有UGC视频数据
-(NSMutableArray *)selectShortVideoModelAllData {
    NSString *selectsql= [NSString stringWithFormat:@"select * from UGCVideo"];
    FMResultSet *set=[_database executeQuery:selectsql];
    NSMutableArray *array=[NSMutableArray array];
    while ([set next]) {
        SCAssetModel* keyWordModel = [[SCAssetModel alloc]  init];
        keyWordModel.createTime = [set stringForColumn:@"creationDate"];
        keyWordModel.timeLength = [set stringForColumn:@"timeLength"];
        keyWordModel.videoPublishState = [set stringForColumn:@"videoState"];
        keyWordModel.publishTime = [set stringForColumn:@"publishTime"];
        keyWordModel.videoTitle = [set stringForColumn:@"videoTitle"];
        keyWordModel.videoCorverImage = [set stringForColumn:@"videoCorverImage"];
        keyWordModel.videoDescTitle = [set stringForColumn:@"videoDescTitle"];
        keyWordModel.corverImageData = [set dataForColumn:@"corverImageData"];
        keyWordModel.assetInentifier = [set stringForColumn:@"assetInentifier"];
        keyWordModel.videoInfoData = [set dataForColumn:@"videoInfoData"];
        [array addObject:keyWordModel];
    }
    return array;
}
//删除某条UGC视频数据
- (BOOL)deleteShortVideoModelWithData:(SCAssetModel *)infoModel {
    NSString *deletesql=@"delete from UGCVideo where creationDate=?";
    BOOL ret=[_database executeUpdate:deletesql,infoModel.createTime];
    if(!ret)
    {
        NSLog(@"删除失败:%@",_database.lastErrorMessage);
    }
    return ret;
    
}
//删除所有UGC视频数据
-(BOOL)deleteAllShortVideoModelData {
    NSString *sqlstr = [NSString stringWithFormat:@"delete from UGCVideo"];
    if (![_database executeUpdate:sqlstr])
    {
        PVLog(@"Delete table error!");
        return NO;
    }
    return YES;
}


//--------------------------订单数据---------------------------------------
//插入订单数据
- (BOOL)insertPurchaseOrderModelWithModel:(PVAppStorePurchaseModel *)orderModel {
    [self deletePurchaseOrderModelWithData:orderModel];
//    create table if not exists PurchaseOrder (purchaseOrderId varchar(1024),orderTestStr varchar(1024),code varchar(1024))
    NSString *insertsql = @"insert into PurchaseOrder (purchaseOrderId,orderTestStr,code) values (?,?,?)";
    BOOL ret=[_database executeUpdate:insertsql,orderModel.purchaseOrderId,orderModel.orderTestStr,orderModel.code];
    if(!ret)
    {
        NSLog(@"添加失败:%@",_database.lastErrorMessage);
    }
    return ret;
}

//查看所有订单数据
-(NSMutableArray *)selectPurchaseOrderModelAllData {
    NSString *selectsql= [NSString stringWithFormat:@"select * from PurchaseOrder"];
    FMResultSet *set=[_database executeQuery:selectsql];
    NSMutableArray *array=[NSMutableArray array];
    while ([set next]) {
        PVAppStorePurchaseModel* orderModel = [[PVAppStorePurchaseModel alloc]  init];
        orderModel.purchaseOrderId = [set stringForColumn:@"purchaseOrderId"];
        orderModel.orderTestStr = [set stringForColumn:@"orderTestStr"];
        orderModel.code = [set stringForColumn:@"code"];
        [array addObject:orderModel];
    }
    return array;
}
//删除某条订单数据
- (BOOL)deletePurchaseOrderModelWithData:(PVAppStorePurchaseModel *)infoModel {
    NSString *deletesql=@"delete from PurchaseOrder where purchaseOrderId=?";
    BOOL ret=[_database executeUpdate:deletesql,infoModel.purchaseOrderId];
    if(!ret)
    {
        NSLog(@"删除失败:%@",_database.lastErrorMessage);
    }
    return ret;
}

//根据订单交易ID删除某条订单数据
- (BOOL)deletePurchaseOrderModelWithpurchaseOrderId:(NSString *)purchaseOrderId {
    NSString *deletesql=@"delete from PurchaseOrder where purchaseOrderId=?";
    BOOL ret=[_database executeUpdate:deletesql,purchaseOrderId];
    if(!ret)
    {
        NSLog(@"删除失败:%@",_database.lastErrorMessage);
    }
    return ret;
}

//删除所有订单数据
-(BOOL)deleteAllPurchaseOrderModelData {
    NSString *sqlstr = [NSString stringWithFormat:@"delete from PurchaseOrder"];
    if (![_database executeUpdate:sqlstr])
    {
        PVLog(@"Delete table error!");
        return NO;
    }
    return YES;
}

-(NSMutableArray *)associationKeyWordDataSource{
    if (!_associationKeyWordDataSource) {
        _associationKeyWordDataSource = [NSMutableArray array];
    }
    return _associationKeyWordDataSource;
}

@end
