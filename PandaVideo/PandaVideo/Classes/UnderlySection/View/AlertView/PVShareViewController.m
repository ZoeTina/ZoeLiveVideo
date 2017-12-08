//
//  PVShareViewController.m
//  PandaVideo
//
//  Created by xiangjf on 2017/11/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVShareViewController.h"
#import "PVShareTool.h"

@interface PVShareViewController ()
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation PVShareViewController

- (void)dealloc {
    [self.contentView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.scNavigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.scNavigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self addGesture];
    [self initView];
    self.baseTopView.hidden = YES;
}

- (void)addGesture {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissTap:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:self.view];
    if ([self.contentView.layer containsPoint:point]) {
        return;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
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
    CGFloat btnW = IPHONE6WH(100);
    CGFloat margin = IPHONE6WH(0);
    CGFloat leftMargin = IPHONE6WH(35);
    
    for (int i = 0; i < self.imagesArray.count; i ++) {
        NSString *imageName = [self.imagesArray sc_safeObjectAtIndex:i];
        NSString *btnName = [self.nameArray sc_safeObjectAtIndex:i];
        
        UIView *btnView = [self createButtonWithTitle:btnName imageName:imageName];
        
        int row = i / totalColumn;
        int col = i % totalColumn;
        CGFloat cellX = leftMargin + (btnW + margin) * col;
        [self.contentView addSubview:btnView];
        //        btnView.frame = CGRectMake(cellX, cellY, btnW, btnH);
        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(cellX);
            make.width.mas_equalTo(btnW);
            make.height.mas_equalTo(btnH);
            make.bottom.mas_offset(- btnH * row - IPHONE6WH(53));
        }];
        
    }
}

- (void)addSubView {
    //添加每行button下面的横线
    NSInteger rows = ceilf(self.imagesArray.count / 3.0);
    [self.view addSubview:self.contentView];
    
    //height是分享按钮的高度*行数+分享给小伙伴Label的高度+底部取消按钮的高度
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(IPHONE6WH(96) * rows + 37 + IPHONE6WH(53));
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorHexString(0xD7D7D7);
    [self.contentView addSubview:lineView];
    
    UILabel *tipsLabel = [UILabel sc_labelWithText:@"分享给小伙伴" fontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    tipsLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.height.mas_equalTo(37);
        make.width.mas_equalTo(100);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(13);
        make.right.mas_offset(-13);
        make.height.mas_equalTo(1);
        make.centerY.mas_equalTo(tipsLabel.mas_centerY);
        //        make.top.equalTo(tipsLabel.mas_bottom);
    }];
   
    
    UILabel *canclelabel = [UILabel sc_labelWithText:@"取消" fontSize:15 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:canclelabel];
    [canclelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.mas_equalTo(IPHONE6WH(50));
    }];
    UITapGestureRecognizer *cancleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap:)];
    [canclelabel addGestureRecognizer:cancleTap];
    
    
    UIView *grayLineView = [[UIView alloc] initWithFrame:CGRectZero];
    grayLineView.backgroundColor = UIColorHexString(0xF2F2F2);
    [self.contentView addSubview:grayLineView];
    [grayLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_equalTo(IPHONE6WH(3));
        make.bottom.equalTo(canclelabel.mas_top).mas_offset(0);
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
                    if (shareResultStr) {
                        
                    }
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
    if (_shareModel.h5Url.length == 0) {
        _shareModel.h5Url = @"http://www.baidu.com";
        Toast(@"分享的链接为空");
    }
    
    if (_shareModel.h5Url.length == 0) {
        _shareModel.h5Url = @"http://www.baidu.com";
        Toast(@"h5链接为空");
    }
    
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}

- (UIView *)createButtonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = NO;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.mas_equalTo(IPHONE6WH(54));
    }];
    
    UILabel *titleLabel = [UILabel sc_labelWithText:title fontSize:13 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.equalTo(imageView.mas_bottom).mas_offset(IPHONE6WH(6));
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareBtnClickWithBtnName:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

@implementation PVShareModel

@end
