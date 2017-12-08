//
//  PVLiveTelevisionCodeRateList.m
//  PandaVideo
//
//  Created by cara on 17/9/20.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLiveTelevisionCodeRateList.h"


@interface PVLiveTelevisionCodeRateList() <NSCoding>


@end

@implementation PVLiveTelevisionCodeRateList


-(void)setIsDefaultRate:(NSString *)isDefaultRate{
    _isDefaultRate = isDefaultRate;
    if (isDefaultRate.boolValue) {
        self.isSelected = true;
    }else{
        self.isSelected = false;
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.showName forKey:@"showName"];
    [aCoder encodeObject:self.rateFileUrl forKey:@"rateFileUrl"];
    [aCoder encodeObject:self.sort forKey:@"sort"];
    [aCoder encodeObject:self.isDefaultRate forKey:@"isDefaultRate"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isSelected] forKey:@"isSelected"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.showName = [aDecoder decodeObjectForKey:@"showName"];
        self.rateFileUrl = [aDecoder decodeObjectForKey:@"rateFileUrl"];
        self.sort = [aDecoder decodeObjectForKey:@"sort"];
        self.isDefaultRate = [aDecoder decodeObjectForKey:@"isDefaultRate"];
        self.isSelected =((NSNumber*) [aDecoder decodeObjectForKey:@"isSelected"]).boolValue;
    }
    return self;
}
@end
