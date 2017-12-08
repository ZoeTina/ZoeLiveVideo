//
//  PVSearchResultAssociationCell.h
//  PandaVideo
//
//  Created by cara on 2017/11/7.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVAssociationKeyWordModel.h"

@interface PVSearchResultAssociationCell : UITableViewCell

@property(nonatomic, copy)NSString* searchWord;
@property(nonatomic, strong)PVAssociationKeyWordModel* keyWordModel;

@end
