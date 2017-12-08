//
//  SCBaseScrollView.m
//  UISCrollViewDemo
//
//  Created by xiangjf on 2017/7/4.
//  Copyright © 2017年 Zcy. All rights reserved.
//

#import "SCBaseScrollView.h"

@implementation SCScrollViewDataModel

@end

@interface SCBaseScrollView ()
{
    CGFloat _top;
    CGFloat _left;
    CGFloat _right;
    CGFloat _bottom;
}
@end

@implementation SCBaseScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initState];
    }
    return self;
}

- (void)initState {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self addSubViews];
}


#pragma mark - scrollView 添加子视图
- (void)addSubViews {
        
    _top = _dataModel.edgeInsets.top;
    _left = _dataModel.edgeInsets.left;
    _right = _dataModel.edgeInsets.right;
    _bottom = _dataModel.edgeInsets.bottom;
    
    CGFloat w = self.dataArray.count * _dataModel.itemSize.width + _dataModel.itemInstance * (self.dataArray.count - 1) + _left + _right;
    CGFloat h = _dataModel.itemSize.height;
    self.contentSize = CGSizeMake(w, h);
    
    //block 传view， model，外部处理
    for (int i = 0; i < self.dataArray.count; i++) {
        
        __block UIView *view;
        if (_dataModel.subNibViewName) {
            
            view = [[[NSBundle mainBundle] loadNibNamed:_dataModel.subNibViewName owner:nil options:nil] objectAtIndex:0];
        }else {

            Class viewClass = NSClassFromString(_dataModel.subNibViewName);
            view = [[viewClass alloc] init];
        }
        
        view.tag = 1000 + i;
        
        id model = self.dataArray[i];
        
        if (self.subViewBlock) {
            self.subViewBlock(view, model);
        }
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(_left + _dataModel.itemSize.width * i + _dataModel.itemInstance * i);
            make.top.mas_offset(_top);
            make.width.mas_equalTo(_dataModel.itemSize.width);
            make.height.mas_equalTo(_dataModel.itemSize.height);
        }];

    }
    
}

- (void)addGestureEventWithView:(UIView *)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseClickEvent:)];
    [view addGestureRecognizer:tap];
}

- (void)responseClickEvent:(UITapGestureRecognizer *)gesture {
    UIView *view =gesture.view;
    id model = self.dataArray[view.tag - 1000];
    if (self.subViewDelegate && [self.subViewDelegate respondsToSelector:@selector(subViewClickWithView:model:)]) {
        [self.subViewDelegate subViewClickWithView:view model:model];
    }
}

- (void)setDataModel:(SCScrollViewDataModel *)dataModel {
    _dataModel = dataModel;
}

@end
