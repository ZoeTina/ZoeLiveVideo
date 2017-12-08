//
//  PVToolView.h
//  PandaVideo
//
//  Created by cara on 17/7/31.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVTextView.h"

//定义block类型把ToolView中TextView中的文字传入到Controller中
typedef void (^MyTextBlock) (NSString *myText);

//改变根据文字改变TextView的高度
typedef void (^ContentSizeBlock)(CGSize contentSize);

//点赞事件回调
typedef void (^PraiseButtonClickedBlock)(void);


@interface PVToolView : UIView<UITextViewDelegate>

///那个类型评论(0:对视频进行评论, 1:回复评论)
@property (nonatomic, assign) NSInteger commentType;
//点赞按钮
@property (nonatomic, strong) UIButton *praiseButton;
//文本视图
@property (nonatomic, strong) PVTextView *sendTextView;
//提示文本
@property (nonatomic, copy) NSString *placehoder;
//提示文本颜色
@property (nonatomic, strong) UIColor *placehoderColor;

//设置MyTextBlock
-(void) setMyTextBlock:(MyTextBlock)block;

-(void)setContentSizeBlock:(ContentSizeBlock) block;

-(void)setPraiseButtonClickedBlock:(PraiseButtonClickedBlock)block;

-(id)initWithType:(NSInteger)type;
@end
