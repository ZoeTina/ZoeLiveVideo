//
//  PVGifView.m
//  PandaVideo
//
//  Created by cara on 17/9/19.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVGifView.h"

@interface PVGifView()

/** 播放gif的控件 */
@property (nonatomic, strong)UIImageView* gifImageView;
///返回事件block
@property (nonatomic, copy)PVGifViewCallBlock callBlock;
///播放类型
@property (nonatomic, assign)NSInteger type;

@end


@implementation PVGifView


-(instancetype)initType:(NSInteger)type{
    self = [super init];
    if (self) {
        self.type = type;
        [self setupUI];
    }
    return self;
}

-(void)dealloc{
    [self.gifImageView stopAnimating];
    [self.gifImageView removeFromSuperview];
    self.gifImageView = nil;
}


-(void)setupUI{
    self.userInteractionEnabled = false;
    if (self.type != 10) {
        self.videoBgImageView = [[UIImageView alloc]  init];
        self.videoBgImageView.image = [UIImage imageNamed:@"bj_player_02"];
        [self addSubview:self.videoBgImageView];
        [self.videoBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
        
        UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"all_btn_back_white"] forState:UIControlStateNormal];
        [self addSubview:backBtn];
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(@0);
            make.width.height.equalTo(@70);
        }];
        [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.backBtn = backBtn;
    }
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 1; i < 10; i ++) {
        NSString *strImage = [NSString new];
        strImage = [NSString stringWithFormat:@"player0%d",i];
        [tempArr addObject:kGetImage(strImage)];
    }
    
    UIImageView *gifImageView = [[UIImageView alloc]  init];
    gifImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:gifImageView];
    [gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(CrossScreenWidth));
        make.height.equalTo(@(CrossScreenWidth*419/750));
        make.center.equalTo(self);
    }];
    gifImageView.animationImages = tempArr;
    gifImageView.animationDuration = 2.0f;
    gifImageView.animationRepeatCount = 10000;
    self.gifImageView = gifImageView;

}

///开始第一次加载动画
-(void)startFirstGif{
    self.hidden = false;
    [self.gifImageView startAnimating];
}
///停止第一次加载动画
-(void)stopFirstGif{
    self.hidden = true;
    [self.gifImageView stopAnimating];
}

-(void)setPVGifViewCallBlock:(PVGifViewCallBlock)block{
    self.callBlock = block;
}

-(void)backBtnClicked{
    if (self.callBlock) {
        self.callBlock();
    }
}

@end
