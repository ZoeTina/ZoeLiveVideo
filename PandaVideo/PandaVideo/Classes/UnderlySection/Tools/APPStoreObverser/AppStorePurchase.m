//
//  AppStorePurchase.m
//  PandaVideo
//
//  Created by xiangjf on 2017/10/18.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "AppStorePurchase.h"
#import "PVAppStorePurchaseModel.h"
#import "PVDBManager.h"
#import "NSMutableDictionary+SCExtension.h"
#import <CommonCrypto/CommonDigest.h>

@interface AppStorePurchase ()
@property (nonatomic, strong) SKProductsRequest *skRequest;
@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) AppStorePurchaseSuccessBlock purchaseBlock;
@property (nonatomic, copy) NSString *environmentUrl;
@end

@implementation AppStorePurchase

static AppStorePurchase *storePurchase = nil;

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

+ (AppStorePurchase *)shareStoreObserver {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storePurchase = [[AppStorePurchase alloc] init];
    });
    return storePurchase;
}

//block
- (void)setAppStorePurchaseBlock:(AppStorePurchaseSuccessBlock)block {
    self.purchaseBlock = block;
}

//- (void)setPurchaseBlock:(AppStorePurchaseSuccessBlock)purchaseBlock {
//    if (self.purchaseBlock) {
//        
//    }
//}

-  (void)showPurchaseToastWithString:(NSString *)string {
    [[UIApplication sharedApplication].keyWindow makeToast:string duration:2 position:CSToastPositionCenter];
}

/** 在点击内购产品的时候可以检测是否可以内购 */
- (void)paymentStartWithProductId:(NSString *)productId {
    [[PVProgressHUD shared] showHudInWindow:[UIApplication sharedApplication].keyWindow];
    //开启内购检测
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    self.productID = productId;
    
    if ([SKPaymentQueue canMakePayments]) {
        [self requestProfuctData:productId];
    }else {
        [[PVProgressHUD shared] hideHudInWindow:[UIApplication sharedApplication].keyWindow];
        WindowToast(@"不允许程序内付费购买");
    }
}

/** 内购代理方法，根据产品id来请求对应产品，开始请求产品 */
- (void)requestProfuctData:(NSString *)productId {
    
    NSSet *sets = [NSSet setWithObjects:productId, nil];
    _skRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:sets];
    _skRequest.delegate = self;
    [_skRequest start];
}

/**内购代理，返回内购信息，如果内购流程正确，会返回包括产品信息的数组*/
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    SCLog(@"---收到产品信息----");
    
    NSArray *product = response.products;
    if (product.count == 0) {
        SCLog(@"-----没有商品------");
        [[PVProgressHUD shared] hideHudInWindow:[UIApplication sharedApplication].keyWindow];
        [self showPurchaseToastWithString:@"没有可以内购的相关产品"];
        return;
    }
    
    SCLog(@"productId:%@", response.invalidProductIdentifiers);
    SCLog(@"付费产品数量:%lu", (unsigned long)product.count);
    
    SKProduct *prod = nil;
    for (SKProduct *pro in product) {
        SCLog(@"%@",[pro description]);
        SCLog(@"%@",[pro localizedTitle]);
        SCLog(@"%@",[pro localizedDescription]);
        SCLog(@"%@",[pro price]);
        SCLog(@"%@",[pro productIdentifier]);
        
        if ([pro.productIdentifier isEqualToString:self.productID]) {
            prod = pro;
        }
    }
    
    if (prod != nil) {
        SKPayment *payment = [SKPayment paymentWithProduct:prod];
        SCLog(@"------发送内购请求--------");
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

/**内购代理，请求失败函数*/
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    SCLog(@"------内购失败---------");
    [[PVProgressHUD shared] hideHudInWindow:[UIApplication sharedApplication].keyWindow];
    [self showPurchaseToastWithString:[error.userInfo pv_objectForKey:@"NSLocalizedDescription"]];
}

/**购买结束，可以进行后续操作*/
- (void)requestDidFinish:(SKRequest *)request {
    SCLog(@"------反馈信息结束--------");
//    [[PVProgressHUD shared] hideHudInWindow:[UIApplication sharedApplication].keyWindow];
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *tran in transactions) {
        SCLog(@"--------打印错误日志---------%@",tran.error.description);
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                NSString * str=[[NSString alloc]initWithData:tran.transactionReceipt encoding:NSUTF8StringEncoding];
                
                NSString *environment=[self environmentForReceipt:str];
                if ([environment containsString:@"Sandbox"]) {
                    self.environmentUrl = SANDBOX;
                }else {
                    self.environmentUrl = AppStore;
                }
                SCLog(@"----- 完成交易调用的方法completeTransaction 1--------%@",environment);
                [self verifyPurchaseWithPaymentTransaction];

                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            }
                
            case SKPaymentTransactionStatePurchasing:{
                SCLog(@"商品添加进列表");
                break;
            }
            case SKPaymentTransactionStateRestored:{
                [self showPurchaseToastWithString:@"已经购买过商品"];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            }
            case SKPaymentTransactionStateFailed:{
                SCLog(@"购买失败");
                [self failedTransaction:tran];

                break;
            }
                
            default:
                break;
        }
    }
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        [[PVProgressHUD shared] hideHudInWindow:[UIApplication sharedApplication].keyWindow];
        [self showPurchaseToastWithString:[transaction.error.userInfo pv_objectForKey:@"NSLocalizedDescription"]];
    }else {
         [self showPurchaseToastWithString:@"订单已取消"];
        [[PVProgressHUD shared] hideHudInWindow:[UIApplication sharedApplication].keyWindow];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}



/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 */
-(void)verifyPurchaseWithPaymentTransaction {
    [[PVProgressHUD shared] hideHudInWindow:[UIApplication sharedApplication].keyWindow];
    
    NSString *receiptString = [self getProductInfo];
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:self.environmentUrl];
    
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody = bodyData;
    requestM.HTTPMethod = @"POST";

    //创建连接并发送同步请求
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if(error) {
        SCLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    [self uploadDataToServerWithDict:dict msg:receiptString];

}

-(NSString * )environmentForReceipt:(NSString * )str
{
    str= [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    str=[str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSArray * arr=[str componentsSeparatedByString:@";"];
    
    //存储收据环境的变量
    NSString * environment=arr[2];
    return environment;
}

- (void)uploadDataToServerWithDict:(NSDictionary *)dict msg:(NSString *)msg{
    if ([[dict pv_objectForKey:@"status"] integerValue] == 0) {
        NSArray *orderArray = [[dict pv_objectForKey:@"receipt"] pv_objectForKey:@"in_app"];
        NSDictionary *orderDic = [orderArray sc_safeObjectAtIndex:0];
        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:@{@"msg":msg,@"productId":[orderDic pv_objectForKey:@"product_id"],@"purchaseDate":[orderDic pv_objectForKey:@"purchase_date_ms"],@"status":@"0",@"transactionId":[orderDic pv_objectForKey:@"transaction_id"],@"userId":[PVUserModel shared].userId,@"verifyState":[dict pv_objectForKey:@"environment"]}];
        
        NSData *baseData = [bodyDict yy_modelToJSONData];
        NSString *base64Str = [baseData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString *noCharBaseStr = [base64Str sc_abandonCharacterWithCharacterArray:@[@"\n",@"\r",@" "]];
        
        NSString *md5Str = [NSString stringWithFormat:@"msg=%@&productId=%@&purchaseDate=%@&status=%@&transactionId=%@&userId=%@&verifyState=%@&token=%@",msg,[orderDic pv_objectForKey:@"product_id"],[orderDic pv_objectForKey:@"purchase_date_ms"],@"0",[orderDic pv_objectForKey:@"transaction_id"],[PVUserModel shared].userId,[dict pv_objectForKey:@"environment"],[PVUserModel shared].token];
        NSString *md5ResultStr = [self md5:md5Str];
        
        NSDictionary *dict = @{@"params":noCharBaseStr, @"ciphertext":md5ResultStr};
        
        NSString *paraJson = [dict yy_modelToJSONString];
        [PVNetTool postBodyDataURLString:applePay parameter:paraJson success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
                    [self tokenLogin];
                }else {
                    if (self.purchaseBlock) {
                        self.purchaseBlock(NO);
                    }

                    NSString *code = [NSString stringWithFormat:@"%@",[responseObject pv_objectForKey:@"rs"]];
                    [self addDataBaseWithOrderId:[orderDic pv_objectForKey:@"transaction_id"] orderJsonStr:paraJson responseCode:code];
                }
            }
        } failure:^(NSError *error) {
            if (error) {
                [self addDataBaseWithOrderId:[orderDic pv_objectForKey:@"transaction_id"] orderJsonStr:paraJson responseCode:@"0"];
            }
        }];
    }
}

- (void)addDataBaseWithOrderId:(NSString *)transactionid orderJsonStr:(NSString *)orderJsonStr responseCode:(NSString *)code {
    PVAppStorePurchaseModel *orderModel = [[PVAppStorePurchaseModel alloc] init];
    orderModel.purchaseOrderId = transactionid;
    orderModel.orderTestStr = orderJsonStr;
    orderModel.code = code;
    if ([[PVDBManager sharedInstance] insertPurchaseOrderModelWithModel:orderModel]) {
//        WindowToast(@"等待订单审核");
        [self tokenLogin];
    }
}
- (NSString *)getProductInfo {
    //从沙盒中获取交易凭证信息并且拼接成请求数据，receiptUrl file:///private/var/mobile/Containers/Data/Application/7CF21991-2903-488E-B017-EBC8AA3B017D/StoreKit/sandboxReceipt
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    //转换为base64字符串
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return receiptString;
}

- (void)tokenLogin {
    [[PVProgressHUD shared] showHudInWindow:[UIApplication sharedApplication].keyWindow];
    
        NSDictionary *dict = @{@"device":@(iOSPlatform),@"token":[PVUserModel shared].token, @"uid":[PVUserModel shared].userId};;
        [PVNetTool postDataWithParams:dict url:@"/tokenLogin" success:^(id result) {
            [[PVProgressHUD shared] hideHudInWindow:[UIApplication sharedApplication].keyWindow];
            if (result) {
                if ([[result pv_objectForKey:@"rs"] integerValue] == 200) {
    
                    PVUserModel *userModel = [PVUserModel shared];
                    [userModel yy_modelSetWithDictionary:[result pv_objectForKey:@"data"]];;
                    [userModel dump];
    
                    SCLog(@"%@",[PVUserModel shared]);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeUserInfo" object:nil];
                    if (self.purchaseBlock) {
                        self.purchaseBlock(YES);
                    }
                }else {
                    if (self.purchaseBlock) {
                        self.purchaseBlock(NO);
                    }
                    WindowToast(@"数据更新失败");
                }
            }
        } failure:^(NSError *error) {
            if (error) {
                [[PVProgressHUD shared] hideHudInWindow:[UIApplication sharedApplication].keyWindow];
                if (self.purchaseBlock) {
                    self.purchaseBlock(NO);
                }
                WindowToast(@"数据更新失败");
            }
        }];
}

/**最后一步，购买完商品后，把苹果返回的一个大长串json数据给后台进行验证，查看充值了多少钱*/
//- (void)completeTransaction:(SKPaymentTransaction *)transation {
//    //    Toast(@"交易完成");
//    NSString *productIdentifier = transation.payment.productIdentifier;
//
//    //验证购买结果
//    if (productIdentifier.length > 0) {
////        receiptUrl    NSURL *    @"file:///private/var/mobile/Containers/Data/Application/451B1B3F-69EF-45A6-93E5-F8FD98EE9DEB/StoreKit/sandboxReceipt"    0x00000001c46a1920
//        //最好把返回的结果转换为base64给后台，让后台再转回来，因为返回的结果可能存在特殊字符，后台会给变成空格
//        NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] appStoreReceiptURL] path]];
//        NSString *base64 = [data base64EncodedStringWithOptions:0];
//        NSDictionary *dict = @{@"userId":[PVUserModel shared].userId,@"token":@"token",@"receipt":base64};
//        [PVNetTool postDataHaveTokenWithParams:dict url:applePay success:^(id responseObject) {
//            if (responseObject) {
//                if ([[responseObject pv_objectForKey:@"rs"] integerValue] == 200) {
//                    WindowToast(@"商品购买成功");
//                }else {
//                    //                    WindowToast(@"商品购买失败");
//                }
//            }
//        } failure:^(NSError *error) {
//
//        } tokenErrorInfo:^(NSString *tokenErrorInfo) {
//
//        }];
//    }
//}
- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[16];
    unsigned int x=(int)strlen(cStr) ;
    CC_MD5( cStr, x, digest );
      // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return  output;
}

@end
