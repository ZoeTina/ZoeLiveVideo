//
//  PVSettingsTableViewCell.m
//  PandaVideo
//
//  Created by cara on 17/8/22.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVSettingsTableViewCell.h"

@interface PVSettingsTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rowImageView;
@property (weak, nonatomic) IBOutlet UIView *botttomView;
@property (weak, nonatomic) IBOutlet UILabel *letTitleLabel;

@property (nonatomic, copy)NSString* cacheText;

@end


@implementation PVSettingsTableViewCell

static NSString *netPlay = @"2G/3G/4G网络下播放提醒";
static NSString *netUploading = @"允许使用2G/3G/4G流量上传";
static NSString *netCache = @"允许使用2G/3G/4G流量缓存";
static NSString *post = @"热门内容推送";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    
}

- (void)initSwitchView {
    PVMineConfigModel *configModel = [PVMineConfigModel shared];
    if ([self.title isEqualToString:netPlay]) {
        [self setSwitchBoolValueWithBoolValue:configModel.netPlayTips];
    }
    
    if ([self.title isEqualToString:netUploading]) {
        [self setSwitchBoolValueWithBoolValue:configModel.netUploadingTips];
    }
    
    if ([self.title isEqualToString:netCache]) {
        [self setSwitchBoolValueWithBoolValue:configModel.netCacheTips];
    }
    
    if ([self.title isEqualToString:post]) {
        [self setSwitchBoolValueWithBoolValue:configModel.postTips];
    }
}

- (void)setSwitchBoolValueWithBoolValue:(BOOL)boolValue {
    if (boolValue) {
        self.rightSwitch.on = YES;
    }else {
        self.rightSwitch.on = NO;
    }
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.letTitleLabel.text = title;
    [self initSwitchView];
}


-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.section == 0) {
        self.rightSwitch.hidden = (indexPath.row == 3) ? true : false;
        self.countLabel.hidden = self.rowImageView.hidden = (indexPath.row == 3) ? false : true;
        self.botttomView.hidden = (indexPath.row == 3) ? true : false;
        
        NSUInteger fileSize = [[SDImageCache sharedImageCache] getSize];
        self.cacheText = [NSString stringWithFormat:@"%.2fM", fileSize / (1000.0 * 1000.0)];
        self.countLabel.text = self.cacheText;
    }else if (indexPath.section == 1){
        self.rightSwitch.hidden = true;
        self.countLabel.hidden = true;
//        self.rightSwitch.hidden = false;
//        self.botttomView.hidden = self.countLabel.hidden = self.rowImageView.hidden = true;
    }else{
        self.rightSwitch.hidden = true;
        self.rowImageView.hidden = (indexPath.row == 1) ? true : false;
        self.countLabel.hidden = (indexPath.row == 1) ? false : true;
        self.botttomView.hidden = (indexPath.row == 2) ? true : false;
        self.countLabel.text = [NSString stringWithFormat:@"v%@",VERSIONing];
    }
}
- (IBAction)switchButtonClick:(id)sender {
    
    self.rightSwitch = (UISwitch *)sender;
    
    if ([self.title isEqualToString:netPlay]) {
        if (self.rightSwitch.on) {
            [PVMineConfigModel shared].netPlayTips = YES;
            
        }else {
            [PVMineConfigModel shared].netPlayTips = NO;
        }
    }
    if ([self.title isEqualToString:netUploading]) {
        if (self.rightSwitch.on) {
            [PVMineConfigModel shared].netUploadingTips = YES;
        }else {
            [PVMineConfigModel shared].netUploadingTips = NO;
        }
    }
    if ([self.title isEqualToString:netCache]) {
        if (self.rightSwitch.on) {
            [PVMineConfigModel shared].netCacheTips = YES;
        }else {
            [PVMineConfigModel shared].netCacheTips = NO;
        }
    }
//    if ([self.title isEqualToString:post]) {
//        if (self.rightSwitch.on) {
//            [PVMineConfigModel shared].postTips = YES;
//        }else {
//            [PVMineConfigModel shared].postTips = NO;
//        }
//    }
    [[PVMineConfigModel shared] dump];
   
}


@end
