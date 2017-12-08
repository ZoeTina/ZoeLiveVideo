//
//  PVInteractiveZBViewController+GiftAnnimation.m
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInteractiveZBViewController+GiftAnnimation.h"
#import "PVGifViews.h"

@implementation PVInteractiveZBViewController (GiftAnnimation)

- (void)chooseGiftOnClick:(NSInteger)idx presentView:(PVPresentView *) presentView giftNum:(NSInteger)giftNum   giftTotal:(NSInteger)giftTotal  gifSender:(NSString *)gifSender{
    switch (idx) {
        break;
        case 104://糖心炸弹
        {
            [presentView insertPresentMessages:@[self.itemModelArray[idx-100]] showShakeAnimation:YES giftNum:giftNum giftTotal:giftTotal gifSender:gifSender];
        }
            break;
        case 105://香气粑粑
        {
            [presentView insertPresentMessages:@[self.itemModelArray[idx-100]] showShakeAnimation:YES giftNum:giftNum giftTotal:giftTotal gifSender:gifSender];
        }
            break;
        case 106://心好累
        {
            [presentView insertPresentMessages:@[self.itemModelArray[idx-100]] showShakeAnimation:YES giftNum:giftNum giftTotal:giftTotal gifSender:gifSender];
        }
            break;
        case 107://兰博基尼
        {
            [presentView insertPresentMessages:@[self.itemModelArray[idx-100]] showShakeAnimation:YES giftNum:giftNum giftTotal:giftTotal gifSender:gifSender];
        }
            break;
        case 108://豪华游艇
        {
            [presentView insertPresentMessages:@[self.itemModelArray[idx-100]] showShakeAnimation:YES giftNum:giftNum giftTotal:giftTotal gifSender:gifSender];
        }
            break;
        default:// 默认效果(静态图)
            [presentView insertPresentMessages:@[self.itemModelArray[idx-100]] showShakeAnimation:YES giftNum:giftNum giftTotal:giftTotal gifSender:gifSender];
            break;
    }
}
@end
