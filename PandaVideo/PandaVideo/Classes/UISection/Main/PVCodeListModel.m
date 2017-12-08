//
//  PVCodeListModel.m
//  PandaVideo
//
//  Created by cara on 2017/11/21.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVCodeListModel.h"

@implementation PVCodeListModel

//获取单例对象
+(PVCodeListModel *)sharedInstance{
    static PVCodeListModel *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager=[[PVCodeListModel alloc]init];
    });
    return manager;
}
-(NSMutableArray<PVCodeModel *> *)codeModelList{
    if (!_codeModelList) {
        _codeModelList = [NSMutableArray array];
    }
    return _codeModelList;
}
-(void)getVideoProduct{
    NSString* url = @"http://pandafile.sctv.com:42086/Pay/authcode.json";
    [PVNetTool getDataWithUrl:url success:^(id result) {
        if (result[@"codeList"] &&  [result[@"codeList"] isKindOfClass:[NSArray class]]) {
            NSArray* jsonArr = result[@"codeList"];
            [self.codeModelList  removeAllObjects];
            for (NSDictionary* jsonDict in jsonArr) {
                PVCodeModel* codeModel = [[PVCodeModel alloc]  init];
                [codeModel setValuesForKeysWithDictionary:jsonDict];
                [self.codeModelList addObject:codeModel];
            }
        }
    } failure:nil];
}
-(NSString*)getCorrespondingVideoProduct:(NSString*)code{
    if (code.length == 0) {
        return nil;
    }
    for (PVCodeModel* codeModel in self.codeModelList) {
        if ([codeModel.code isEqualToString:code]) {
            return codeModel.validatecode;
        }
    }
    return nil;
}
@end

@implementation PVCodeModel


@end
