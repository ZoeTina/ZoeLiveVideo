//
//  PVDemandVideoDetailModel.m
//  PandaVideo
//
//  Created by cara on 17/8/3.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVDemandVideoDetailModel.h"


@implementation PVDemandVideoDetailModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"modelList"]) {
        PVVideoModelList* videoModelList = [[PVVideoModelList alloc]  init];
        [videoModelList setValuesForKeysWithDictionary:value];
        self.videoModelList = videoModelList;
    }else if ([key isEqualToString:@"description"]) {
        PVVideoDescription* videoDescription = [[PVVideoDescription alloc]  init];
        [videoDescription setValuesForKeysWithDictionary:value];
        self.videoDescription = videoDescription;
    }else{
        [super setValue:value forKey:key];
    }
}

-(void)setVideoUrl:(NSString *)videoUrl{
    videoUrl = [videoUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    _videoUrl = videoUrl;

}

-(void)calculationVideoInfoHeight{
    
    CGFloat height = 0;
    CGFloat fontMargin = 13;
    CGFloat topMargin = 10;
    CGFloat botttomMargin = 10;
    CGFloat margin = fontMargin+topMargin;
    
    if (self.videoDescription.year.length || self.videoDescription.area.length || self.videoDescription.type.length) {
        height += margin;
    }else{
        height += topMargin;
    }
    if (self.videoDescription.actors.length){
        height += margin;
    }else{
        height += topMargin;
    }
    if (self.videoDescription.updateMsg.length){
        height += margin;
    }else{
        height += topMargin;
    }
    if (self.videoSubTitle.length){
        height += (topMargin+botttomMargin);
        CGSize size = [UILabel messageBodyText:self.videoSubTitle andSyFontofSize:13 andLabelwith:CrossScreenWidth-30 andLabelheight:MAXFLOAT];
        height += size.height;
    }
    self.videoInfoHeight = height;
}

@end


@implementation PVVideoModelList

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"episodeModel"]) {
        PVVideoEpisodeModel* videoEpisodeModel = [[PVVideoEpisodeModel alloc]  init];
        [videoEpisodeModel setValuesForKeysWithDictionary:value];
        self.videoEpisodeModel = videoEpisodeModel;
    }else if ([key isEqualToString:@"editorModel"]) {
        PVVideoEditorModel* videoEditorModel = [[PVVideoEditorModel alloc]  init];
        [videoEditorModel setValuesForKeysWithDictionary:value];
        self.videoEditorModel = videoEditorModel;
    }else if ([key isEqualToString:@"advertisedModel"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            [self.videoAdvertisedModels removeAllObjects];
            NSArray* jsonArr = value;
            for (NSDictionary* jsonDict in jsonArr) {
                PVVideoEditorModel* videoEditorModel = [[PVVideoEditorModel alloc]  init];
                [videoEditorModel setValuesForKeysWithDictionary:jsonDict];
                [self.videoAdvertisedModels addObject:videoEditorModel];
            }
        }
    }else{
        [super setValue:value forKey:key];
    }
}


-(NSMutableArray<PVVideoEditorModel *> *)videoAdvertisedModels{
    if (!_videoAdvertisedModels) {
        _videoAdvertisedModels = [NSMutableArray array];
    }
    return _videoAdvertisedModels;
}

-(NSMutableArray<PVAdvertisementModel *> *)advertisementModels{
    if (!_advertisementModels) {
        _advertisementModels = [NSMutableArray array];
    }
    return _advertisementModels;
}


@end

@implementation PVVideoEpisodeModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.kDescription = value;
    }else{
        [super setValue:value forKey:key];
    }
}


@end


@implementation PVVideoEditorModel

-(NSMutableArray<PVVideoListModel *> *)videoList{
    if(!_videoList){
        _videoList = [NSMutableArray array];
    }
    return _videoList;
}

@end



@implementation PVVideoDescription

-(void)setArea:(NSString *)area{
    NSString *str = [area stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    _area = str;
}
-(void)setYear:(NSString *)year{
    NSString *str = [year stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    _year = str;
}
-(void)setType:(NSString *)type{
    NSString *str = [type stringByReplacingOccurrencesOfString:@"[" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    _type = str;
}


@end
