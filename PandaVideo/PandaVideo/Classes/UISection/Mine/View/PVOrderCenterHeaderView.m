//
//  PVOrderCenterHeaderView.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/11.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVOrderCenterHeaderView.h"

@interface PVOrderCenterHeaderView()

@property (nonatomic, copy) PVOrderCenterHeaderViewBlock loginBlock;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@end

@implementation PVOrderCenterHeaderView


- (instancetype)initOrderCenterViewWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PVOrderCenterHeaderView" owner:self options:nil] lastObject];
        [self initSubView];
    }
    return self;
}
- (void)initSubView {
    
    if ([self isLogin]) {
        self.nameLabel.text = [PVUserModel shared].baseInfo.nickName;
        self.activityLabel.text = @"订购小尊包成为会员 免费看大片";
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:[[PVUserModel shared].baseInfo.avatar sc_urlString]] placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"]];
        self.loginButton.hidden = YES;
    }else {
        self.headerView.image = [UIImage imageNamed:@"mine_icon_avatar"];
        self.nameLabel.text = @"未登录";
        self.activityLabel.text = @"请登陆后购买VIP会员";
        self.loginButton.hidden = NO;
    }
}

- (BOOL)isLogin {
    if ([PVUserModel shared].userId.length == 0) {
        return NO;
    }
    return YES;
}
//- (IBAction)repeatOrderButtonClick:(id)sender {
//    if (self.orderHeaderBlock) {
//        self.orderHeaderBlock(RepeatOrder);
//    }
//}
- (IBAction)loginButtonClick:(id)sender {
    if (self.loginBlock) {
        self.loginBlock(self);
    }
}
//- (IBAction)purchaseButtonClick:(id)sender {
//    if (self.orderHeaderBlock) {
//        self.orderHeaderBlock(Purchase);
//    }
//}

//- (void)searchOrderHistory {
//    if (self.orderHeaderBlock) {
//        self.orderHeaderBlock(LookOrderHistory);
//    }
//}

- (void)setPVOrderCenterHeaderViewBlock:(PVOrderCenterHeaderViewBlock)block {
    self.loginBlock = block;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.purchaseButton.layer.borderWidth = 1.0f;
//    self.purchaseButton.layer.borderColor = [UIColor sc_colorWithHex:0x2AB4E4].CGColor;
//    self.purchaseButton.clipsToBounds = true;
//    self.purchaseButton.layer.cornerRadius= self.purchaseButton.sc_height / 2.0;
//    
//    self.repeatOrderButton.layer.borderWidth = 1.0f;
//    self.repeatOrderButton.layer.borderColor = [UIColor sc_colorWithHex:0x2AB4E4].CGColor;
//    self.repeatOrderButton.clipsToBounds = true;
//    self.repeatOrderButton.layer.cornerRadius= self.repeatOrderButton.sc_height / 2.0;
//    self.frame = CGRectMake(0, 0, kScreenWidth, IPHONE6WH(79));
    self.loginButton.layer.borderWidth = 1.0f;
    self.loginButton.layer.borderColor = [UIColor sc_colorWithHex:0x2AB4E4].CGColor;
    self.loginButton.clipsToBounds = true;
    self.loginButton.layer.cornerRadius= self.loginButton.sc_height / 2.0;
    
    self.headerView.layer.cornerRadius = self.headerView.sc_height / 2.;
    self.headerView.layer.masksToBounds = YES;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchOrderHistory)];
//    [self.lookOrderHistoryView addGestureRecognizer:tap];
}
@end
