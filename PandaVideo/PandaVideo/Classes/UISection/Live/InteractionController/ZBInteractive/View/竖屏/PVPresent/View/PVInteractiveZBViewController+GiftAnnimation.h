//
//  PVInteractiveZBViewController+GiftAnnimation.h
//  PandaVideo
//
//  Created by Ensem on 2017/9/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "PVInteractiveZBViewController.h"

@interface PVInteractiveZBViewController (GiftAnnimation)

- (void)chooseGiftOnClick:(NSInteger)idx presentView:(PVPresentView *) presentView giftNum:(NSInteger)giftNum giftTotal:(NSInteger)giftTotal  gifSender:(NSString *)gifSender;

@end
