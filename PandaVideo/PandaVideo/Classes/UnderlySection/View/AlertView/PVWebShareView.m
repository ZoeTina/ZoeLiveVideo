//
//  PVWebShareView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVWebShareView.h"
#import "PVShareTool.h"

@interface PVWebShareView ()
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation PVWebShareView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        [self loadData];
        [self addGesture];
        [self initView];
    }
    return self;
}

- (void)addGesture {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap:)];
    [self addGestureRecognizer:tap];
}

- (void)dismissTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self];
    if ([self.contentView.layer containsPoint:point]) {
        return;
    }
    self.hidden = YES;
}

- (void)loadData {
    self.imagesArray = [[NSMutableArray alloc] init];
    self.nameArray = [[NSMutableArray alloc] init];
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
       
        [self.imagesArray addObject:@"live_btn_qqzone"];
        [self.nameArray addObject:@"QQ空间"];
    }
    
    [self.imagesArray addObject:@"live_btn_weibo"];
    [self.nameArray addObject:@"微博"];
    [self.imagesArray addObject:@"live_btn_link"];
    [self.nameArray addObject:@"复制链接"];
    
    
    //判断微信是否安装
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
        [self.imagesArray addObject:@"mine_btn_wechat"];
        [self.nameArray addObject:@"微信"];
        
        [self.imagesArray addObject:@"live_btn_pyquan"];
        [self.nameArray addObject:@"朋友圈"];
    }
    
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeQQ]) {
        [self.imagesArray addObject:@"live_btn_qqzone"];
        [self.nameArray addObject:@"QQ好友"];
    }
}

- (void)initView {
    [self addSubView];
    
    int totalColumn = 3;
    
    //    CGFloat btnH = IPHONE6WH(72);
    CGFloat btnH = IPHONE6WH(96);
    CGFloat btnW = IPHONE6WH(54);
    CGFloat margin = IPHONE6WH(50);
    CGFloat leftMargin = IPHONE6WH(57);
    
    for (int i = 0; i < self.imagesArray.count; i ++) {
        NSString *imageName = [self.imagesArray sc_safeObjectAtIndex:i];
        NSString *btnName = [self.nameArray sc_safeObjectAtIndex:i];
        
        UIView *btnView = [self createButtonWithTitle:btnName imageName:imageName];
        
       
        
        int row = i / totalColumn;
        int col = i % totalColumn;
        CGFloat cellX = leftMargin + (btnW + margin) * col;
        //        CGFloat cellY = row * btnH + IPHONE6WH(19);
        CGFloat cellY = self.sc_height - (IPHONE6WH(51) );
        [self.contentView addSubview:btnView];
        //        btnView.frame = CGRectMake(cellX, cellY, btnW, btnH);
        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(cellX);
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(btnH);
            make.bottom.mas_offset(IPHONE6WH(12)- btnH * row);
            
        }];
        
    }
}

- (void)addSubView {
    //添加每行button下面的横线
    NSInteger rows = ceilf(self.imagesArray.count / 3.0);
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(96 * rows + 41);
    }];
    
    UILabel *tipsLabel = [UILabel sc_labelWithText:@"分享" fontSize:15 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.mas_equalTo(40);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(1);
        make.top.equalTo(tipsLabel.mas_bottom);
    }];
}

- (void)shareBtnClickWithBtnName:(UITapGestureRecognizer *)tap {
    UIView *view = tap.view;
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)subView;
            if ([label.text isEqualToString:@"微信"]) {
                [PVShareTool shareWithPlatformType:SSDKPlatformSubTypeWechatSession PVDemandVideoDetailModel:self.shareModel shareresult:^(NSString *shareResultStr) {
                    
                }];
            }
            if ([label.text isEqualToString:@"朋友圈"]) {
                [PVShareTool shareWithPlatformType:SSDKPlatformSubTypeWechatTimeline PVDemandVideoDetailModel:self.shareModel shareresult:^(NSString *shareResultStr) {
                    
                }];
            }
            if ([label.text isEqualToString:@"QQ好友"]) {
                [PVShareTool shareWithPlatformType:SSDKPlatformSubTypeQQFriend PVDemandVideoDetailModel:self.shareModel shareresult:^(NSString *shareResultStr) {
                    
                }];
            }
            if ([label.text isEqualToString:@"QQ空间"]) {
                [PVShareTool shareWithPlatformType:SSDKPlatformSubTypeQZone PVDemandVideoDetailModel:self.shareModel shareresult:^(NSString *shareResultStr) {
                    
                }];
            }
            if ([label.text isEqualToString:@"微博"]) {
                [PVShareTool shareWithPlatformType:SSDKPlatformTypeSinaWeibo PVDemandVideoDetailModel:self.shareModel shareresult:^(NSString *shareResultStr) {
                    
                }];
            }
            if ([label.text isEqualToString:@"复制链接"]) {
                UIPasteboard *copyStr = [UIPasteboard generalPasteboard];
                copyStr.string = self.shareModel.videoUrl;
                WindowToast(@"链接复制成功");
            }
           
        }
    }
}

- (void)setShareModel:(PVShareModel *)shareModel {
    _shareModel = shareModel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor blackColor];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIView *)createButtonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.userInteractionEnabled = NO;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.mas_equalTo(IPHONE6WH(54));
    }];
    
    UILabel *titleLabel = [UILabel sc_labelWithText:title fontSize:13 textColor:[UIColor whiteColor] alignment:NSTextAlignmentCenter];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(imageView.mas_bottom).mas_offset(IPHONE6WH(6));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareBtnClickWithBtnName:)];
    [view addGestureRecognizer:tap];
    return view;
}
@end
