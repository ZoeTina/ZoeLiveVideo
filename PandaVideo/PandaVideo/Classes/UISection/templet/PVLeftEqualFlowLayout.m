//
//  PVLeftEqualFlowLayout.m
//  PandaVideo
//
//  Created by cara on 2017/10/29.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVLeftEqualFlowLayout.h"


@interface PVLeftEqualFlowLayout()



@end

@implementation PVLeftEqualFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* attributesToReturn = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attributesToReturn) {
        if (nil == attributes.representedElementKind) {
            NSIndexPath* indexPath = attributes.indexPath;
            attributes.frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
        }
    }
    return attributesToReturn;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *currentItemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    PVTempletModel* templetModel =  self.templetDataSource[indexPath.section];
    NSInteger type = templetModel.modelType.integerValue;
    NSInteger count = templetModel.videoTemletModel.count;
    
    if (type == 4 && count == 3 && indexPath.row == 2) {
        CGRect frame = currentItemAttributes.frame;
        currentItemAttributes.frame = CGRectMake(10, frame.origin.y, frame.size.width, frame.size.height);
    }else if (type == 6 && count == 2 && indexPath.row == 1) {
        CGRect frame = currentItemAttributes.frame;
        currentItemAttributes.frame = CGRectMake(10, frame.origin.y, frame.size.width, frame.size.height);
    }else if (type == 12 && count == 2 && indexPath.row == 1) {
        CGRect frame = currentItemAttributes.frame;
        currentItemAttributes.frame = CGRectMake(10, frame.origin.y, frame.size.width, frame.size.height);
    }
    return currentItemAttributes;
}

@end
