//
//  PVMoneyHeaderView.m
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVMoneyHeaderView.h"

@interface PVMoneyHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation PVMoneyHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIView* bgView = [[UIView alloc]  init];
    bgView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bgView;
    self.iconImageView.clipsToBounds = true;
    self.iconImageView.layer.cornerRadius = 25;
    [self initHeaderView];
//    [self loadData];
}

- (void)initHeaderView {
    PVUserModel *userModel = [PVUserModel shared];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[userModel.baseInfo.avatar sc_urlString]] placeholderImage:[UIImage imageNamed:@"mine_icon_avatar"]];
    
}

- (void)loadData {
    NSDictionary *dict = @{@"platform":@(iOSPlatform),@"token":[PVUserModel shared].token, @"userId":[PVUserModel shared].userId};
    [PVNetTool postDataHaveTokenWithParams:dict url:getPandaBalance success:^(id responseObject) {
        if (responseObject) {
            if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                PVMoneyModel *moneyModel = [PVMoneyModel yy_modelWithDictionary:[responseObject pv_objectForKey:@"data"]];
                self.moneyLabel.text = moneyModel.balance;

            }
        }
    } failure:^(NSError *error) {
        
    } tokenErrorInfo:^(NSString *tokenErrorInfo) {
        
    }];
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 2;
    [super setFrame:frame];
}

@end

@implementation PVMoneyModel

@end
