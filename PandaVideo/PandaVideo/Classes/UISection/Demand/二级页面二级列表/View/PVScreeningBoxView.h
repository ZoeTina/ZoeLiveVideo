//
//  PVScreeningBoxView.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/5.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVChoiceSecondColumnModel.h"

@interface PVScreeningBoxView : UIView

@property (nonatomic, strong) UIView *boxView;
-(instancetype)initWithModels:(PVChoiceSecondColumnModel *) secondColumnModel;

@end
