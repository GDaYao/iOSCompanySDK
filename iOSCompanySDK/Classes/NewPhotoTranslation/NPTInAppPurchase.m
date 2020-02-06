////  NPTInAppPurchase.m
//  iOSCompanySDK
//
//  Created on 2020/2/6.
//  
//

#import "NPTInAppPurchase.h"
#import <StoreKit/StoreKit.h>

@interface NPTInAppPurchase () <SKProductsRequestDelegate,SKPaymentTransactionObserver>


@property (nonatomic,copy)NSString *productId;

@end


@implementation NPTInAppPurchase


#pragma mark - In-App purchase
// add transaction observer
- (void)nptAddTransactionObserver:(id)observer {
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
}
// remove transaction observer
- (void)nptRemoveTransactionObserver:(id)observer {
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}

// restore product
- (void)nptRestoreProductId {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
// 内购数据请求
- (void)nptRequestProductIdData:(NSString *)productId {
    if([SKPaymentQueue canMakePayments]){
        self.productId = productId;
        NSArray *product = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",productId], nil];
        NSSet *nsset = [NSSet setWithArray:product];
        SKProductsRequest   *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
        productRequest.delegate = self;
        [productRequest start];
    }else{
        NSLog(@"NPTInAppPurchase-用户不允许程序内付费");
    }
}

#pragma mark <SKProductsRequestDelegate>
// call before <requestDidFinish>
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    if (!product.count)
    {
        NSLog(@"NPTInAppPurchase-未收到内购产品信息");
        if ([self.deleagte respondsToSelector:@selector(nptProductRequestInReceiveResponseWithNullProduct)]) {
            [self.deleagte nptProductRequestInReceiveResponseWithNullProduct];
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
        NSLog(@"NPTInAppPurchase-加入内购购买队列-开始发送购买请求");
        if (payMent)
        {
            [[SKPaymentQueue defaultQueue] addPayment:payMent];
        }
    }

}
#pragma mark <SKRequestDelegate>
// call in request finish with success
- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"NPTInAppPurchase-内购购买请求成功");
    if ([self.deleagte respondsToSelector:@selector(NPTSKRequestInDidFinish)]) {
        [self.deleagte NPTSKRequestInDidFinish];
    }
    
}
// call in request fail with error
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"NPTInAppPurchase-内购购买请求失败-error:%@",error);
    if ([self.deleagte respondsToSelector:@selector(NPTSKRequestInDidFailWithError:)]) {
        [self.deleagte NPTSKRequestInDidFailWithError:error];
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
                NSLog(@"NPTInAppPurchase-内购产品购买成功");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];//记得关闭交易事件
                
                NSString *productId = tran.payment.productIdentifier;
                NSString *receiptString = [tran.transactionReceipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                if([self.deleagte respondsToSelector:@selector(nptCompleteTransactionWithProductId:transactionReceipt:transactionId:)]){
                    [self.deleagte nptCompleteTransactionWithProductId:productId transactionReceipt:receiptString transactionId:tran.transactionIdentifier];
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
                NSLog(@"NPTInAppPurchase-内购商品加入购物车");
            }
                break;
                case SKPaymentTransactionStateRestored:
            {
                NSLog(@"NPTInAppPurchase-内购商品恢复购买成功");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
                NSString *productId = tran.payment.productIdentifier;
                NSString *receiptString = [tran.transactionReceipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                if ([self.deleagte respondsToSelector:@selector(nptRestoreTransactionWithProductId:transactionReceipt:transactionId:)]) {
                    [self.deleagte nptRestoreTransactionWithProductId:productId transactionReceipt:receiptString transactionId:tran.transactionIdentifier];
                }
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"NPTInAppPurchase-内购商品购买失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                NSString *productId = tran.payment.productIdentifier;
                if ([self.deleagte respondsToSelector:@selector(nptIAPFailTransactionWithProductId:errorLocalizedDescription:)]) {
                    [self.deleagte nptIAPFailTransactionWithProductId:productId errorLocalizedDescription:tran.error.localizedDescription];
                }
            }
            default:
                break;
        }
    }
    
}





@end
