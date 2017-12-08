//
//  PVRecommandReusableView.h
//  PandaVideo
//
//  Created by cara on 17/7/13.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVModelTitleDataModel.h"

typedef NS_ENUM(NSInteger, ClickedType)
{
    ClickedLeft = 0,//点击箭头
    ClickedRight = 1,//点右边文字
    ClickedImageView = 2,//点击大图
};

typedef void(^PVRecommandReusableViewCallBlock)(ModelWord* modelWord,ClickedType clickedType);


@interface PVRecommandReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic, assign)NSInteger type;
@property(nonatomic, assign)NSInteger sectionOfStar;

@property(nonatomic, strong)PVModelTitleDataModel* modelTitleDataModel;


-(void)setPVRecommandReusableViewCallBlock:(PVRecommandReusableViewCallBlock)block;

@end
