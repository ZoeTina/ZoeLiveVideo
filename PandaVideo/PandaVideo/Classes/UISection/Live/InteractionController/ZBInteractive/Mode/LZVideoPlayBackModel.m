//
//  LZVideoPlayBackModel.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/17.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "LZVideoPlayBackModel.h"

@implementation LZVideoPlayBackModel
- (UIImage *)placeholderImage
{
    if (!_placeholderImage) {
    //        _placeholderImage = ZFPlayerImage(@"ZFPlayer_loading_bgView");
        _placeholderImage = [[UIImage alloc] init];
    }
    return _placeholderImage;
}
@end
