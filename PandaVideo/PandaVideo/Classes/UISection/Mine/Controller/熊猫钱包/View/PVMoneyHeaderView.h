//
//  PVMoneyHeaderView.h
//  PandaVideo
//
//  Created by cara on 17/8/28.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVMoneyHeaderView : UITableViewHeaderFooterView
- (void)loadData;
@end


@interface PVMoneyModel : NSObject
@property (nonatomic, copy) NSString *balance;

@end
