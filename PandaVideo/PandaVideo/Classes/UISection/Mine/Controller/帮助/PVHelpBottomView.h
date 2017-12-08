//
//  PVHelpBottomView.h
//  PandaVideo
//
//  Created by xiangjf on 2017/11/10.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVQuestionClassModel.h"

typedef void(^PVHelpBottomViewBlock)(id sender);

@interface PVHelpBottomView : UIView

//@property (nonatomic, copy) NSString *phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *phonelabel;
@property (weak, nonatomic) IBOutlet UILabel *serveerLabel;
@property (nonatomic, strong) PVQuestionClassModel *questionClassModel;
- (void)setPVHelpBottomViewBlock:(PVHelpBottomViewBlock)block;

- (instancetype)initHelpBottomView;


@end
