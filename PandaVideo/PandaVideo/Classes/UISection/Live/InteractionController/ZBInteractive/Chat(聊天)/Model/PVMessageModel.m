//
//  PVMessageModel.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMessageModel.h"

@implementation PVMessageModel

- (void)setModel:(NSString*)userID withName:(NSString*)name withIcon:(NSString*)icon withType:(CellType)type withMessage:(NSString*)message
{
    userID = userID?userID:@"";
    name = name?name:@"";
    icon = icon?icon:@"";
    if (message.length==0) {
        return;
    }
    TYTextContainer *container = [[TYTextContainer alloc]init];
    container.font = [UIFont systemFontOfSize:15];
    container.linesSpacing = 0;
    container.characterSpacing = 0;
    NSString *allMessage;
    switch (type) {
        case CellNewChatMessageType:
        {
            allMessage = [NSString stringWithFormat:@"%@:%@",name,message];
            
            // 属性文本生成器
            container.text = allMessage;
            NSMutableArray *tmpArray = [NSMutableArray array];
            
//            // 正则匹配表情
//            [allMessage enumerateStringsMatchedByRegex:@"\\[emot:(\\w+\\d+)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
//
//                if (captureCount > 0) {
//                    // 图片信息储存
//                    TYImageStorage *imageStorage = [[TYImageStorage alloc]init];
//                    imageStorage.cacheImageOnMemory = YES;
//                    imageStorage.imageName = capturedStrings[1];
//                    imageStorage.range = capturedRanges[0];
//                    imageStorage.size = CGSizeMake(30, 30);
//
//                    [tmpArray addObject:imageStorage];
//                }
//            }];
            
            TYTextStorage *nameTextStorage = [[TYTextStorage alloc]init];
            nameTextStorage.range = [allMessage rangeOfString:name];
            nameTextStorage.textColor = kColorWithRGB(30, 153, 247);
            nameTextStorage.font = [UIFont boldSystemFontOfSize:15];
            [container addTextStorage:nameTextStorage];
            
            TYTextStorage *deserveTextStorage = [[TYTextStorage alloc]init];
            deserveTextStorage.range = [allMessage rangeOfString:message];
            deserveTextStorage.textColor = [UIColor whiteColor];
            deserveTextStorage.font = [UIFont boldSystemFontOfSize:15];
            [container addTextStorage:deserveTextStorage];
            
            [container addLinkWithLinkData:userID linkColor:kColorWithRGB(30, 153, 247) underLineStyle:kCTUnderlineStyleNone range:[allMessage rangeOfString:name]];
            
            // 链接
            //            TYTextStorage *textStorage = [[TYTextStorage alloc]init];
            //            textStorage.range = [allMessage rangeOfString:name];
            //            textStorage.textColor = RGB(30, 153, 247, 1);
            //            textStorage.font = [UIFont systemFontOfSize:15];
            //            [container addTextStorage:textStorage];
            
            // 添加表情数组到label
            [container addTextStorageArray:tmpArray];
        }
            break;
            
        default:
            break;
    }
    _unColoredMsg = allMessage;
    _textContainer = container;
}

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [PVMessageData class]};
}
@end

@implementation PVMessageData

-(void)setValue:(id)value forKey:(NSString *)key{
    
    if ([value isKindOfClass:[NSArray class]]) {
        [self.chatList removeAllObjects];
        NSArray* jsonArr = value;
        for (NSDictionary* jsonDict in jsonArr) {
            PVChatList* chatList = [[PVChatList alloc]  init];
            [chatList setValuesForKeysWithDictionary:jsonDict];
            [self.chatList addObject:chatList];
        }
    }else{
        [super setValue:value forKey:key];
    }
}
@end

@implementation PVChatList

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"userData"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            LZUserData *userdata = [[LZUserData alloc] init];
            [userdata setValuesForKeysWithDictionary:value];
            self.userData = userdata;
        }
    }else{
        [super setValue:value forKey:key];
    }
}

@end
@implementation LZUserData

@end

