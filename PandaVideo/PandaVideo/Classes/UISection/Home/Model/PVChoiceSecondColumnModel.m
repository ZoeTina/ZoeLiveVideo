//
//  PVChoiceSecondColumnModel.m
//  PandaVideo
//
//  Created by cara on 2017/10/19.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVChoiceSecondColumnModel.h"

@implementation PVChoiceSecondColumnModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"baseInfo"]) {
        BaseInfo* baseInfo = [[BaseInfo alloc]  init];
        [baseInfo setValuesForKeysWithDictionary:value];
        self.baseInfo = baseInfo;
    }else if ([key isEqualToString:@"models"]){
        
    }else if ([key isEqualToString:@"filterList"] ){
        if ([value isKindOfClass:[NSArray class]]) {
            [self.filterList removeAllObjects];
            NSArray* jsonArr = value;
            
            for (NSDictionary* jsonDict in jsonArr) {
                if (jsonDict[@"filterKeys"] && [jsonDict[@"filterKeys"] isKindOfClass:[NSDictionary class]]) {
                    Filter* filter = [[Filter alloc]  init];
                    [filter setValuesForKeysWithDictionary:jsonDict[@"filterKeys"]];
                    [self.filterList addObject:filter];
                }
            }
        }
    }else if ([key isEqualToString:@"list"] ){
        if ([value isKindOfClass:[NSArray class]]) {
            [self.listModel removeAllObjects];
            NSArray* jsonArr = value;
            for (NSDictionary* jsonDict in jsonArr) {
                ListModel* listModel = [[ListModel alloc]  init];
                [listModel setValuesForKeysWithDictionary:jsonDict];
                [self.listModel addObject:listModel];
            }
        }
    }else {
        [super setValue:value forKey:key];
    }
}
-(NSMutableArray<Filter *> *)filterList{
    if (!_filterList) {
        _filterList = [NSMutableArray array];
    }
    return _filterList;
}
-(NSMutableArray<ListModel *> *)listModel{
    if (!_listModel) {
        _listModel = [NSMutableArray array];
    }
    return _listModel;
}


@end

@implementation BaseInfo

@end

@implementation Filter

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"keys"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            [self.keys removeAllObjects];
            NSArray* jsonArr = value;
            for (NSDictionary* jsonDict in jsonArr) {
                KeyModel* keyModel = [[KeyModel alloc]  init];
                [keyModel setValuesForKeysWithDictionary:jsonDict];
                [self.keys addObject:keyModel];
            }
            if (self.keys.count) {
                KeyModel *keymodel = [[KeyModel alloc] init];
                keymodel.kId = @"100";
                keymodel.name = @"全部";
                keymodel.isSelect = YES;
                self.selectKeyMode = keymodel;
                [self.keys insertObject:keymodel atIndex:0];
            }
        }
    }else{
        [super setValue:value forKey:key];
    }
}
-(NSMutableArray<KeyModel *> *)keys{
    if (!_keys) {
        _keys = [NSMutableArray array];
    }
    return _keys;
}
@end

@implementation KeyModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.kId = value;
    }else{
        [super setValue:value forKey:key];
    }
}
@end


@implementation ListModel

@end
