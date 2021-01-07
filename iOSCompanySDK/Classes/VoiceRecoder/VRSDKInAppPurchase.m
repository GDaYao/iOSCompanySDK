



#import "VRSDKInAppPurchase.h"

#import <StoreKit/StoreKit.h>


@interface VRSDKInAppPurchase () <SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic,copy)NSString *vrsdkProductId;

@end


@implementation VRSDKInAppPurchase

- (void)addTransactionObserver:(id)observer {
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
}
- (void)removeTransactionObserver:(id)observer {
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
}


- (void)restoreProductId {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

// 内ss购sss数sss据ssssss请sss求sss
- (void)requestProductIdData:(NSString *)productId {
    if([SKPaymentQueue canMakePayments]){
        self.vrsdkProductId = productId;
        NSArray *product = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",productId], nil];
        NSSet *nsset = [NSSet setWithArray:product];
        SKProductsRequest   *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
        productRequest.delegate = self;
        [productRequest start];
    }else{
        NSLog(@"用户不允许程序内付费");
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    if (!product.count)
    {
        NSLog(@"未收到内购产品信息");
        if ([self.delegate respondsToSelector:@selector(productRequestInReceiveResponseWithNullProduct)]) {
            [self.delegate productRequestInReceiveResponseWithNullProduct];
        }
        return;
    }
    
    SKProduct *currentProduct = nil;
    for (SKProduct *skproduct in product)
    {
        if ([skproduct.productIdentifier isEqualToString:self.vrsdkProductId])
        {
            currentProduct = skproduct;
        }
    }
    // 发送购买请求
    if (currentProduct != nil) {
        SKPayment *payMent = [SKPayment paymentWithProduct:currentProduct];
        NSLog(@"加入内购购买队列-开始发送购买请求");
        if (payMent)
        {
            [[SKPaymentQueue defaultQueue] addPayment:payMent];
        }
    }

}
#pragma mark <SKRequestDelegate>
- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"内购购买请求成功");
    if ([self.delegate respondsToSelector:@selector(SKRequestInDidFinish)]) {
        [self.delegate SKRequestInDidFinish];
    }
    
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"内购购买请求失败-error:%@",error);
    if ([self.delegate respondsToSelector:@selector(SKRequestInDidFailWithError:)]) {
        [self.delegate SKRequestInDidFailWithError:error];
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
                NSLog(@"内购产品购买成功");
                
                // 自动续费 -- 添加二次内购验证
                [self completeTransaction:tran];
                
                // 订阅特殊处理
                if(tran.originalTransaction){
                    //如果是自动续费的订单originalTransaction会有内容
                }else{
                    //普通购买，以及 第一次购买 自动订阅
                }

                [[SKPaymentQueue defaultQueue] finishTransaction:tran];//记得关闭交易事件
                
            }
                break;
                case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"内购商品加入购物车");
            }
                break;
                case SKPaymentTransactionStateRestored:
            {
                NSLog(@"内购商品恢复购买成功");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
                NSString *productId = tran.payment.productIdentifier;
                NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
                NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
                if ([self.delegate respondsToSelector:@selector(restoreTransactionWithProductId:transactionReceipt:transactionId:)]) {
                    [self.delegate restoreTransactionWithProductId:productId transactionReceipt:receiptString transactionId:tran.transactionIdentifier];
                }
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"内购商品购买失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                NSString *productId = tran.payment.productIdentifier;
                if ([self.delegate respondsToSelector:@selector(IAPFailTransactionWithProductId:errorLocalizedDescription:)]) {
                    [self.delegate IAPFailTransactionWithProductId:productId errorLocalizedDescription:tran.error.localizedDescription];
                }
            }
            default:
                break;
        }
    }
    
}


#pragma mark - verify purchase
/**
 *  验证购买
 */
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    dispatch_async(dispatch_get_main_queue(), ^{
        //[SVProgressHUD showWithStatus:@"正式验证"];
    });
    NSString *productIdentifer = transaction.payment.productIdentifier;
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
    
    // 自动续订--需要共享密钥
    NSDictionary * bodyDic = @{
        @"receipt-data":receiptString,
        @"password":@"21a9a928a83c47c992b912a5fbaac36e"
    };
    NSString *bodyString = [self dictionaryToJson:bodyDic];

    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString: @"https://buy.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestM completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
            
            if ([self.delegate respondsToSelector:@selector(IAPFailTransactionWithProductId:errorLocalizedDescription:)]) {
                [self.delegate IAPFailTransactionWithProductId:@"" errorLocalizedDescription:@"验证购买过程中发生错误"];
            }
            
            return;
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        if([dic[@"status"] intValue]==0){
            //正式环境验证通过（说明是上线以后的用户购买）
            NSLog(@"log-购买成功！");
            
            //调用setVip接口
            NSString *productId = transaction.payment.productIdentifier;
            NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
            NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
            NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
            if([self.delegate respondsToSelector:@selector(completeTransactionWithProductId:transactionReceipt:transactionId:)]){
                [self.delegate completeTransactionWithProductId:productId transactionReceipt:receiptString transactionId:transaction.transactionIdentifier];
            }
            
        }else if([dic[@"status"] intValue]== 21007){
            //第二步，验证测试环境
            [self verifyPurchaseWithTestEnvironment:bodyData receiptString:receiptString productIdentifer:productIdentifer transaction:transaction];
        }else {
            NSLog(@"验证失败,订单出错");
            
            NSString *productId = transaction.payment.productIdentifier;
            if ([self.delegate respondsToSelector:@selector(IAPFailTransactionWithProductId:errorLocalizedDescription:)]) {
                [self.delegate IAPFailTransactionWithProductId:productId errorLocalizedDescription:@"验证失败,订单出错"];
            }
            
        }
        
    }] resume];
    
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *paraseError = nil;
    NSData *jonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&paraseError];
    NSString *base =[[NSString alloc] initWithData:jonData encoding:NSUTF8StringEncoding];
    base = [base stringByReplacingOccurrencesOfString:@"\r\n" withString : @"" ];
    base = [base stringByReplacingOccurrencesOfString:@"\n" withString : @"" ];
    base = [base stringByReplacingOccurrencesOfString:@"\t" withString : @"" ];
    base = [base stringByReplacingOccurrencesOfString:@" " withString : @"" ];
    base = [base stringByReplacingOccurrencesOfString:@"/n" withString : @"" ];
    return base;
}

// 创建请求到苹果官方进行购买验证（测试环境）
- (void)verifyPurchaseWithTestEnvironment:(NSData *)bodyData receiptString:(NSString *)receiptString productIdentifer:(NSString *)productIdentifer transaction:(SKPaymentTransaction *)transaction  {
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    NSURL *url=[NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestM completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
            
            if ([self.delegate respondsToSelector:@selector(IAPFailTransactionWithProductId:errorLocalizedDescription:)]) {
                [self.delegate IAPFailTransactionWithProductId:@"" errorLocalizedDescription:@"验证购买过程中发生错误"];
            }
            
            return;
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        if([dic[@"status"] intValue]==0){
            NSLog(@"购买成功！");
            
            //调用setVip接口
            NSString *productId = transaction.payment.productIdentifier;
            NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
            NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
            NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串
            if([self.delegate respondsToSelector:@selector(completeTransactionWithProductId:transactionReceipt:transactionId:)]){
                [self.delegate completeTransactionWithProductId:productId transactionReceipt:receiptString transactionId:transaction.transactionIdentifier];
            }
            
        }else {
            NSLog( @"验证失败,订单出错" );
            
            NSString *productId = transaction.payment.productIdentifier;
            if ([self.delegate respondsToSelector:@selector(IAPFailTransactionWithProductId:errorLocalizedDescription:)]) {
                [self.delegate IAPFailTransactionWithProductId:productId errorLocalizedDescription:@"验证失败,订单出错"];
            }
            
        }
        
    }] resume];
}


/** AppStore发起IAP内购购买时
 * 直接返回NO不在下单处理
 *
 */
- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product {
    return NO;
}









@end


