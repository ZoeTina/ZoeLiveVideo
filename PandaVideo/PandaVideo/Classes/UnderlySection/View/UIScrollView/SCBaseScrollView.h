//
//  SCBaseScrollView.h
//  UISCrollViewDemo
//
//  Created by xiangjf on 2017/7/4.
//  Copyright © 2017年 Zcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubViewCliclDelegate <NSObject>

- (void)subViewClickWithView:(UIView *)view model:(id)model;

@end

@interface SCScrollViewDataModel : NSObject

//二选一
@property (nonatomic, copy) NSString *subNibViewName;

@property (nonatomic, copy) NSString *subViewName;

//item 大小
@property (nonatomic, assign) CGSize itemSize;

//item水平间距
@property (nonatomic, assign) CGFloat itemInstance;

//it的四周间距scrollView的间距,如果有其他的视图，必须设置edgeInsets，得到scrollView的相对位置
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

//item数据源
@property (nonatomic, strong) NSArray *itemsDataArray; //照片数组，存储图片名字

@end


@interface SCBaseScrollView : UIScrollView
@property (nonatomic, copy) void (^subViewBlock)(id view, id model);
@property (nonatomic, weak) id<SubViewCliclDelegate>subViewDelegate;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) SCScrollViewDataModel *dataModel;
@end
