//
//  LZPageContentView.h
//  Huim
//
//  Created by huim on 2017/4/28.
//  Copyright © 2017年 huim. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LZPageContentView;

@protocol LZPageContentViewDelegate <NSObject>

@optional

/**
 LZPageContentView开始滑动
 
 @param contentView LZPageContentView
 */
- (void)LZContentViewWillBeginDragging:(LZPageContentView *)contentView;

/**
 LZPageContentView滑动调用
 
 @param contentView LZPageContentView
 @param startIndex 开始滑动页面索引
 @param endIndex 结束滑动页面索引
 @param progress 滑动进度
 */
- (void)LZContentViewDidScroll:(LZPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;

/**
 LZPageContentView结束滑动
 
 @param contentView LZPageContentView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)LZContenViewDidEndDecelerating:(LZPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

/**
 scrollViewDidEndDragging
 
 @param contentView LZPageContentView
 */
- (void)LZContenViewDidEndDragging:(LZPageContentView *)contentView;

@end

@interface LZPageContentView : UIView

/**
 对象方法创建LZPageContentView
 
 @param frame frame
 @param childVCs 子VC数组
 @param parentVC 父视图VC
 @param delegate delegate
 @return LZPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<LZPageContentViewDelegate>)delegate;

@property (nonatomic, weak) id<LZPageContentViewDelegate>delegate;

/**
 设置contentView当前展示的页面索引，默认为0
 */
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;

/**
 设置contentView能否左右滑动，默认YES
 */
@property (nonatomic, assign) BOOL contentViewCanScroll;

@end
