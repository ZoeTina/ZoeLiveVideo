//
//  AppStorePurchase.h
//  PandaVideo
//
//  Created by xiangjf on 2017/10/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import <UIKit/UIKit.h>

typedef void(^AppStorePurchaseSuccessBlock)(BOOL isSuccess);

@interface AppStorePurchase : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    int buyType;
}


+ (AppStorePurchase *)shareStoreObserver;
- (void)setAppStorePurchaseBlock:(AppStorePurchaseSuccessBlock)block;
- (void)paymentStartWithProductId:(NSString *)productId;
@end
