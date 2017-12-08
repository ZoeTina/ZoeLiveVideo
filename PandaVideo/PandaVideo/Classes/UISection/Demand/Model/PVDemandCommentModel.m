//
//  PVDemandCommentModel.m
//  PandaVideo
//
//  Created by cara on 2017/10/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDemandCommentModel.h"

@implementation PVDemandCommentModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"replayList"] && [value isKindOfClass:[NSArray class]]) {
        NSArray* jsonArr = value;
        [self.replayList removeAllObjects];
        for (NSDictionary* jsonDict in jsonArr) {
            PVReplayList* replayListModel = [[PVReplayList alloc]  init];
            [replayListModel setValuesForKeysWithDictionary:jsonDict];
            [replayListModel calculationCellHeight];
            [self.replayList addObject:replayListModel];
        }
    }else if ([key isEqualToString:@"userData"]){
        PVUserData* userDataModel = [[PVUserData alloc]  init];
        [userDataModel setValuesForKeysWithDictionary:value];
        self.userData = userDataModel;
    }else{
        [super setValue:value forKey:key];
    }
}

-(void)setDate:(NSString *)date{
    _date = date;
    self.detailDate = [[NSDate PVDateStringToDate:date formatter:@"YYYY-MM-dd HH:mm:ss"] sc_dateDescription];
}


-(NSMutableArray<PVReplayList *> *)replayList{
    if (!_replayList) {
        _replayList = [NSMutableArray array];
    }
    return _replayList;
}
@end

@implementation PVReplayList

-(void)calculationCellHeight{
    
    self.content = [self.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.content = [self.content stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.content = [self.content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    self.content = [self.content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString* text = self.content;
    if(self.userName.length && !self.userName){
        text = [NSString stringWithFormat:@"%@:  %@",self.userName,self.content];
    }
    
   CGSize size = [UILabel messageBodyText:text andSyFontofSize:[[UIFont systemFontOfSize:15] pointSize] andLabelwith:ScreenWidth-75 andLabelheight:MAXFLOAT];
    CGRect frame = CGRectMake(0, 0, ScreenWidth-75, MAXFLOAT);
    
    NSArray *array = [UILabel getSeparatedLinesFromText:text font:[UIFont systemFontOfSize:15] frame:frame];
    if(array.count == 1){
        self.cellHeight = 30.0;
    }else{
        self.cellHeight = size.height + 10 + (array.count-1)*5;
    }
}

-(void)setNickName:(NSString *)nickName{
    _nickName = nickName;
    self.userName = nickName;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"userData"]){
        PVUserData* userDataModel = [[PVUserData alloc]  init];
        [userDataModel setValuesForKeysWithDictionary:value];
        self.userData = userDataModel;
    }else{
        [super setValue:value forKey:key];
    }
}
@end

@implementation PVUserData

@end
