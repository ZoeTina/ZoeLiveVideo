//
//  PVLiveRoomModel.m
//  PandaVideo
//
//  Created by Ensem on 2017/11/2.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLiveRoomModel.h"

@implementation PVLiveRoomModel

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([key isEqualToString:@"data"] ){
        if ([value isKindOfClass:[NSDictionary class]]) {
            PVLiveRoomData *liveRoom = [[PVLiveRoomData alloc] init];
            [liveRoom setValuesForKeysWithDictionary:value];
            self.liveRoomData = liveRoom;
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end

@implementation PVLiveRoomData


@end
