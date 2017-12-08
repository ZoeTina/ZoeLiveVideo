//
//  SCButton.h
//  SiChuanFocus
//
//  Created by cara on 17/6/29.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCButton : UIButton

/**
 *  用于创建的按钮上面是图片，下面说文字
 *
 *  @param title                    下面显示的文字
 *  @param imageNolmalString        上面摇显示的图片
 *
 */

+(SCButton*)customButtonWithTitlt: (NSString*)title  imageNolmalString: (NSString*)imageNolmalString  imageSelectedString: (NSString*)imageSelectedString ;


@end
