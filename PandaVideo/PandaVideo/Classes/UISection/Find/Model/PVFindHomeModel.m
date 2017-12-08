//
//  PVFindHomeModel.m
//  PandaVideo
//
//  Created by cara on 17/7/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVFindHomeModel.h"

@implementation PVFindHomeModel


-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"authorData"]) {
        AuthorData*  authorData = [[AuthorData alloc] init];
        [authorData setValuesForKeysWithDictionary:value];
        self.authorData = authorData;
    }else{
        [super setValue:value forKey:key];
    }
}


-(void)setCode:(NSString *)code{
    _code = code;
    
    NSLog(@"-------code-------%@",code);
    
}

-(void)setDate:(NSString *)date{
    _date = date;
    if (date.length){
        NSDate* timeDate = [NSDate PVDateStringToDate:date formatter:@"YYYY-MM-dd HH:mm:ss"];
        self.publishTimeStr = [timeDate sc_dateDescription];
    }
}

-(void)setLength:(NSString *)length{
    _length = length;
    if (length.length) {
        self.videoTime = [self stringWithTime:length.doubleValue];
    }
}
- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger m = time / 60;
    NSInteger s = (NSInteger)time % 60;
    NSString *stringtime = [NSString stringWithFormat:@"%02ld:%02ld",m, s];
    return stringtime;
}

-(void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    self.cellHeight = ScreenWidth*9/16 + 150;
    self.cellDetailHeight = ScreenWidth*9/16 + 100;
    if (subTitle.length) {
        CGSize size = [UILabel messageBodyText:subTitle andSyFontofSize:[[UIFont systemFontOfSize:15] pointSize] andLabelwith:ScreenWidth-20 andLabelheight:MAXFLOAT];
        self.cellHeight = size.height + ScreenWidth*9/16 + 150;
        self.cellDetailHeight = size.height + ScreenWidth*9/16 + 100;
    }
}

-(void)setVideoListModel:(PVVideoListModel *)videoListModel{
    _videoListModel = videoListModel;
    self.cellHeight = ScreenWidth*9/16 + 100;
    if (videoListModel.info.expand.subhead.length) {
        CGSize size = [UILabel messageBodyText:videoListModel.info.expand.subhead andSyFontofSize:[[UIFont systemFontOfSize:15] pointSize] andLabelwith:ScreenWidth-20 andLabelheight:MAXFLOAT];
        self.cellHeight = size.height + ScreenWidth*9/16 + 100;
    }
    if (videoListModel.createTime.length){
        NSDate* date = [NSDate PVDateStringToDate:videoListModel.createTime formatter:@"YYYY-MM-dd HH:mm:ss"];
        self.publishTimeStr = [date sc_dateDescription];
    }
}


@end


@implementation AuthorData

@end
