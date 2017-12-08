//
//  PVIntroduceViewController.m
//  PandaVideo
//
//  Created by Ensem on 2017/8/15.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVIntroduceViewController.h"
#import "LZKeyboardAvoidingScrollView.h"

@interface PVIntroduceViewController ()

@property (nonatomic, strong) IBOutlet UIView *titleView;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UILabel *mechanismNameLable;
/** 机构简介标题 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 机构简介内容 */
@property (nonatomic, strong) UILabel *introduceLabel;
/** 当前活动简介标题 */
@property (nonatomic, strong) UILabel *cTitleLabel;
/** 当前活动简介内容 */
@property (nonatomic, strong) UILabel *cIntroduceLabel;
@property (nonatomic, strong) PVIntroduceModel *introduceModel;
@property (strong, nonatomic) LZKeyboardAvoidingScrollView *mainScroll;


@end

@implementation PVIntroduceViewController

- (instancetype)initIntroduceModel:(PVIntroduceModel *)introduceModel{
    
    if ( self = [super init] ){
        self.introduceModel = introduceModel;
    }
    return self;
}

- (void)setCurrentHeigh:(CGFloat)currentHeigh{
    _currentHeigh = currentHeigh;
    YYLog(@"currentHeigh -- %f",currentHeigh);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    // Do any additional setup after loading the view from its nib.
    self.titleView.sc_height = AUTOLAYOUTSIZE(49);
//    self.mechanismNameLable.text = self.introduceModel.organizationName;
    self.introduceLabel.text = self.introduceModel.info.organizationInfo;
    self.titleLabel.text = @"机构方简介";
    self.cIntroduceLabel.text = self.introduceModel.info.actInfo;
    self.cTitleLabel.text = @"当前活动简介";
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_introduceModel.info.image]
                      placeholderImage:kGetImage(VERTICALMAPBITMAP)];
    
    CGFloat width = (kScreenWidth - AUTOLAYOUTSIZE(24));
    // 图片
    self.imageView.frame = CGRectMake(13, 0, kScreenWidth - 26, AUTOLAYOUTSIZE(198));
    // 机构方简介标题
    self.titleLabel.frame = CGRectMake(13, CGRectGetMaxY(self.imageView.frame)+13, width+2, 15);
    // 机构方简介
    CGSize introduceSize = [self sizeWithText:self.introduceLabel.text fontSize:13.0 maxW:width];
    self.introduceLabel.frame = CGRectMake(12, CGRectGetMaxY(self.titleLabel.frame) + 10, introduceSize.width, introduceSize.height);
    // 当前活动简介标题
    self.cTitleLabel.frame = CGRectMake(13, CGRectGetMaxY(self.introduceLabel.frame)+15, width+2, 15);
    // 当前活动简介
    CGSize cIntroduceSize = [self sizeWithText:self.cIntroduceLabel.text fontSize:13.0 maxW:width];
    self.cIntroduceLabel.frame = CGRectMake(12, CGRectGetMaxY(self.cTitleLabel.frame) + 7, cIntroduceSize.width, cIntroduceSize.height+10);
    // 滑动Scroll
    self.mainScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(self.cIntroduceLabel.frame));
    
    YYLog(@"s -- %f",self.view.sc_height);
}

- (CGSize)sizeWithText:(NSString *)text fontSize:(CGFloat)fontSize maxW:(CGFloat)maxW {
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
    CGSize textSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:textSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}

- (void) initView{
 
    [self.view insertSubview:self.mainScroll atIndex:0];
    [self.mainScroll addSubview:self.imageView];
    [self.mainScroll addSubview:self.titleLabel];
    [self.mainScroll addSubview:self.introduceLabel];
    [self.mainScroll addSubview:self.cTitleLabel];
    [self.mainScroll addSubview:self.cIntroduceLabel];
}

- (IBAction)backBtnClicked {
    [UIView animateWithDuration:0.25f animations:^{
        self.view.sc_y = ScreenHeight;
    } completion:^(BOOL finished) {
        self.view.hidden = true;
    }];
}

#pragma mark -- 懒加载
- (LZKeyboardAvoidingScrollView *)mainScroll {
    if (!_mainScroll) {
        _mainScroll = [[LZKeyboardAvoidingScrollView alloc] init];
        _mainScroll.frame = CGRectMake(0, self.titleView.sc_height, kScreenWidth, self.currentHeigh-self.titleView.sc_height);
        _mainScroll.showsHorizontalScrollIndicator = NO;
        _mainScroll.backgroundColor = [UIColor clearColor];
    }
    return _mainScroll;
}

- (UIImageView *)imageView{
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}


/// 机构简介方标题
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textColor = kColorWithRGB(0, 0, 0);
    }
    return _titleLabel;
}

/// 机构方简介内容
- (UILabel *)introduceLabel{
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] init];
        _introduceLabel.font = [UIFont systemFontOfSize:13.0];
        _introduceLabel.textColor = kColorWithRGB(128, 128, 128);
        _introduceLabel.numberOfLines = 0;
        [_introduceLabel sizeToFit];
    }
    return _introduceLabel;
}

/// 当前活动简介标题
- (UILabel *)cTitleLabel{
    if (!_cTitleLabel) {
        _cTitleLabel = [[UILabel alloc] init];
        _cTitleLabel.font = [UIFont systemFontOfSize:15.0];
        _cTitleLabel.textColor = kColorWithRGB(0, 0, 0);
    }
    return _cTitleLabel;
}

/// 当前活动简介内容
- (UILabel *)cIntroduceLabel{
    if (!_cIntroduceLabel) {
        _cIntroduceLabel = [[UILabel alloc] init];
        _cIntroduceLabel.font = [UIFont systemFontOfSize:13.0];
        _cIntroduceLabel.textColor = kColorWithRGB(128, 128, 128);
        _cIntroduceLabel.numberOfLines = 0;
        [_cIntroduceLabel sizeToFit];
    }
    return _cIntroduceLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
