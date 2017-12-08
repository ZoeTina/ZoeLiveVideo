//
//  PVGIftCell.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVGIftCell.h"

/// 送礼物的Cell
@implementation PVGIftCell

- (instancetype)initWithRow:(NSInteger)row{
    if (self = [super initWithRow:row]) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{

    
    [self addSubview:self.backView];
    [self.backView addSubview:self.backImageView];
//    [self.backImageView addSubview:self.iconImageView];
    [self.backImageView addSubview:self.giftImageView];
    [self.backImageView addSubview:self.senderLabel];
    [self.backImageView addSubview:self.giftLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 头像不显示
    /**[self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(2);
        make.height.mas_equalTo(@32);
        make.width.mas_equalTo(@32);
    }];*/
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(-35);
        make.right.equalTo(self).offset(30);
//        make.width.height.equalTo(@46);
//        make.centerY.equalTo(self);
    }];
    
    [self.senderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImageView.mas_right).offset(10);   // 有头像用此约束
//        make.top.equalTo(self.iconImageView.mas_top);                 // 有头像用此约束
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(7);
        make.right.equalTo(self.giftImageView.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
    
    
    [self.giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImageView.mas_right).offset(10);   // 有头像用此约束
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.senderLabel.mas_bottom);
        make.right.equalTo(self.giftImageView.mas_left).offset(-10);
        make.height.equalTo(@16);
    }];
}

/** 头像 */
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 16;
        _iconImageView.layer.masksToBounds = YES;
        NSString *urlStr = [NSString stringWithFormat:@"http://img1.ph.126.net/ooxqZzMrjHhRwFuGyF19Mg==/6598165979750622385.jpg"];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    return _iconImageView;
}

/** 礼物名称 */
- (UILabel *)giftLabel{
    if (!_giftLabel) {
        _giftLabel = [[UILabel alloc] init];
        _giftLabel.textColor = kColorWithRGB(248, 223, 112);
        _giftLabel.textAlignment = NSTextAlignmentLeft;
        _giftLabel.font = [UIFont systemFontOfSize:12];
    }
    return _giftLabel;
}

/** 昵称 */
- (UILabel *)senderLabel{
    if (!_senderLabel) {
        _senderLabel = [[UILabel alloc] init];
        _senderLabel.textColor = [UIColor whiteColor];
        _senderLabel.text = @"Aync";
        _senderLabel.textAlignment = NSTextAlignmentLeft;
        _senderLabel.font = [UIFont systemFontOfSize:12];
    }
    return _senderLabel;
}

/** 礼物图片 */
- (UIImageView *)giftImageView{
    if (!_giftImageView) {
        _giftImageView = [[UIImageView alloc] init];
        _giftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _giftImageView.autoresizesSubviews = YES;
        _giftImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _giftImageView;
}

/** 背景View */
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = kColorWithRGBA(0, 0, 0, 0);
//        _backView.layer.cornerRadius = 20;
//        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = kGetImage(@"live_gift_bg");
    }
    return _backImageView;
}

- (void)setPresentmodel:(PVPresentModel *)presentmodel{
    
    YYLog(@"presentmodel.giftName -- %@",presentmodel.giftName);
    YYLog(@"presentmodel.giftImageName -- %@",presentmodel.giftImageName);
    YYLog(@"presentmodel.giftId -- %ld",presentmodel.giftId);
    _presentmodel = presentmodel;
    self.senderLabel.text = presentmodel.sender;//presentmodel.sender;
    self.giftLabel.text = [NSString stringWithFormat:@"送出 %@",presentmodel.giftName];
    if((presentmodel.giftId == 2001)||(presentmodel.giftId == 2002)||(presentmodel.giftId == 2003)){
        [self.giftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(-30);
            make.right.equalTo(self).offset(30);
        }];
    }else{
        [self.giftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.width.height.equalTo(@46);
            make.centerY.mas_equalTo(0);
        }];
    }
    switch (presentmodel.giftId) {
        case 1001:
            self.giftImageView.image = [UIImage imageNamed:@"live_icon_gift1"];
            break;
        case 1002:
            self.giftImageView.image = [UIImage imageNamed:@"live_icon_gift2"];
            break;
        case 1003:
            self.giftImageView.image = [UIImage imageNamed:@"live_icon_gift3"];
            break;
        case 1004:
            self.giftImageView.image = [UIImage imageNamed:@"live_icon_gift4"];
            break;
        case 2001:
            [self startAnimation:@"心好累"];
            break;
        case 2002:
            [self startAnimation:@"糖心炸弹"];
            break;
        case 2003:
            [self startAnimation:@"香气粑粑"];
            break;
        case 3001:
           self.giftImageView.image = [UIImage imageNamed:@"live_icon_gift8"];
            break;
        case 3002:
            self.giftImageView.image = [UIImage imageNamed:@"live_icon_gift9"];
            break;
            
        default:
            break;
    }
}

- (void)startAnimation:(NSString *) imageName{
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (int i = 0; i < 54; i ++) {
        NSString *strImage = [NSString new];
        if (i<10) {
            strImage = [NSString stringWithFormat:@"%@_0000%d",imageName,i];
        }else{
            strImage = [NSString stringWithFormat:@"%@_000%d",imageName,i];
        }
        //不直接使用imageNamed（结束后不释放)
        //        NSString *path = [[NSBundle mainBundle] pathForResource:strImage ofType:@"png"];
        //        UIImage *image = [UIImage imageWithContentsOfFile:path];;
        //        YYLog(@"strImage --- %@",image);
        
        [tempArr addObject:kGetImage(strImage)];
        
    }
    
    _giftImageView.animationImages = tempArr;
    _giftImageView.animationDuration = 5.f;     // 执行一次完整动画所需的时长
    _giftImageView.animationRepeatCount = 1;    // 动画重复次数
    [_giftImageView startAnimating];
    
    [self performSelector:@selector(deleteGif:) withObject:nil afterDelay:8];
}

//释放内存
- (void)deleteGif:(id)object{
    _giftImageView.image = kGetImage(self.presentmodel.giftImageName);
    [_giftImageView stopAnimating];
//    _giftImageView.animationImages = nil;
    [self removeFromSuperview];
}

@end
