//
//  PVSpecialDetailModel.m
//  PandaVideo
//
//  Created by cara on 2017/10/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSpecialDetailModel.h"

@implementation PVSpecialDetailModel


-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"topicList"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            [self.topicList removeAllObjects];
            NSArray* jsonArr = value;
            for (NSDictionary* jsonDict in jsonArr) {
                PVVideoListModel* listModel = [[PVVideoListModel alloc] init];
                [listModel setValuesForKeysWithDictionary:jsonDict];
                [self.topicList addObject:listModel];
            }
        }
    }else if ([key  isEqualToString:@"topicSubTitle"]){
        [super setValue:value forKey:key];
        CGSize size = [UILabel messageBodyText:value andSyFontofSize:[[UIFont systemFontOfSize:15] pointSize] andLabelwith:ScreenWidth-24 andLabelheight:MAXFLOAT];
        self.topicSubTitleHeight = size.height+10;
    }else{
        [super setValue:value forKey:key];
    }
}

-(NSMutableArray<PVVideoListModel *> *)topicList{
    if(!_topicList){
        _topicList = [NSMutableArray array];
    }
    return _topicList;
}

@end
