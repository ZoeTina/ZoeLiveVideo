//
//  PVAdScrollView.h
//  PandaVideo
//
//  Created by cara on 2017/10/19.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdScrollViewDelegate <NSObject>

-(NSInteger)numbersOfAdScrollViewItems;
-(NSString*)adScrollViewIitleForIndex:(NSInteger)index;
-(NSString*)adScrollViewIconForIndex:(NSInteger)index;

@optional
-(void)adScrollViewOnAdClicked:(NSInteger)index;

@end


@interface PVAdScrollView : UIView


@property(nonatomic, weak)id<AdScrollViewDelegate>delegate;
@property(nonatomic, assign)NSTimeInterval kAutoScrollInterval;
@property(nonatomic, strong)NSTimer* scrollTimer;


-(void)reloadData;


@end




@interface ActivityInfoView : UIControl

@property(nonatomic, strong)UIImageView*  icon;
@property(nonatomic, strong)UILabel*  textLabel;

@end
