////  NWFInAppPurchase.m
//  
//
//  Created on 2019/10/9.
//  
//

#import "NWFInAppPurchase.h"
#import <StoreKit/StoreKit.h>



@interface NWFInAppPurchase() <SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic,copy)NSString *productId;

@end


@implementation NWFInAppPurchase


#pragma mark - app request view
+ (void)appRequestReviewWithAppId:(NSString *)appIdStr {
    if (@available(iOS 10.3, *))
    {
        //iOS 10.3 以上支持
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)])
        {
            [SKStoreReviewController requestReview];
        }
    }
    else
    {
        // iOS 10.3 之前的使用这个
        NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",appIdStr];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
    }
}


#pragma mark - In-App purchase
// add transaction observer
- (void)addTransactionObserver:(id)observer {
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
}
// remove transaction observer
- (void)removeTransactionObserver:(id)observer {
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}

// restore product
- (void)restoreProductId {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
// 内购数据请求
- (void)requestProductIdData:(NSString *)productId {
    if([SKPaymentQueue canMakePayments]){
        self.productId = productId;
        NSArray *product = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",productId], nil];
        NSSet *nsset = [NSSet setWithArray:product];
        SKProductsRequest   *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
        productRequest.delegate = self;
        [productRequest start];
    }else{
        NSLog(@"NWFInAppPurchase-用户不允许程序内付费");
    }
}

#pragma mark <SKProductsRequestDelegate>
// call before <requestDidFinish>
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    if (!product.count)
    {
        NSLog(@"NWFInAppPurchase-未收到内购产品信息");
        if ([self.deleagte respondsToSelector:@selector(productRequestInReceiveResponseWithNullProduct)]) {
            [self.deleagte productRequestInReceiveResponseWithNullProduct];
        }
        return;
    }
    
    SKProduct *currentProduct = nil;
    for (SKProduct *skproduct in product)
    {
        if ([skproduct.productIdentifier isEqualToString:self.productId])
        {
            currentProduct = skproduct;
        }
    }
    // 发送购买请求
    if (currentProduct != nil)
    {
        SKPayment *payMent = [SKPayment paymentWithProduct:currentProduct];
        NSLog(@"NWFInAppPurchase-加入内购购买队列-开始发送购买请求");
        if (payMent)
        {
            [[SKPaymentQueue defaultQueue] addPayment:payMent];
        }
    }

}
#pragma mark <SKRequestDelegate>
// call in request finish with success
- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"NWFInAppPurchase-内购购买请求成功");
    if ([self.deleagte respondsToSelector:@selector(SKRequestInDidFinish)]) {
        [self.deleagte SKRequestInDidFinish];
    }
    
}
// call in request fail with error
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"NWFInAppPurchase-内购购买请求失败-error:%@",error);
    if ([self.deleagte respondsToSelector:@selector(SKRequestInDidFailWithError:)]) {
        [self.deleagte SKRequestInDidFailWithError:error];
    }
}


#pragma mark <SKPaymentTransactionObserver>
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *tran in transactions)
    {
        switch (tran.transactionState)
        {
                case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"NWFInAppPurchase-内购产品购买成功");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];//记得关闭交易事件
                
                NSString *productId = tran.payment.productIdentifier;
                NSString *receiptString = [tran.transactionReceipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                if([self.deleagte respondsToSelector:@selector(completeTransactionWithProductId:transactionReceipt:transactionId:)]){
                    [self.deleagte completeTransactionWithProductId:productId transactionReceipt:receiptString transactionId:tran.transactionIdentifier];
                }
                
                
                // 订阅特殊处理
                if(tran.originalTransaction){
                    //如果是自动续费的订单originalTransaction会有内容
                }else{
                    //普通购买，以及 第一次购买 自动订阅
                }
            }
                break;
                case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"NWFInAppPurchase-内购商品加入购物车");
            }
                break;
                case SKPaymentTransactionStateRestored:
            {
                NSLog(@"NWFInAppPurchase-内购商品恢复购买成功");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
                NSString *productId = tran.payment.productIdentifier;
                NSString *receiptString = [tran.transactionReceipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                if ([self.deleagte respondsToSelector:@selector(restoreTransactionWithProductId:transactionReceipt:transactionId:)]) {
                    [self.deleagte restoreTransactionWithProductId:productId transactionReceipt:receiptString transactionId:tran.transactionIdentifier];
                }
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"NWFInAppPurchase-内购商品购买失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                NSString *productId = tran.payment.productIdentifier;
                if ([self.deleagte respondsToSelector:@selector(nwfIAPFailTransactionWithProductId:errorLocalizedDescription:)]) {
                    [self.deleagte nwfIAPFailTransactionWithProductId:productId errorLocalizedDescription:tran.error.localizedDescription];
                }
            }
            default:
                break;
        }
    }
    
}






@end
