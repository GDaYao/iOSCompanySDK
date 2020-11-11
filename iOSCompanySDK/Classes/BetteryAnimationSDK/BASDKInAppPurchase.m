
#import "BASDKInAppPurchase.h"
#import <StoreKit/StoreKit.h>



@interface BASDKInAppPurchase() <SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (nonatomic,copy)NSString *productId;

@end


@implementation BASDKInAppPurchase


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
        NSLog(@"log-CS-用户不允许程序内付费");
    }
}

#pragma mark <SKProductsRequestDelegate>
// call before <requestDidFinish>
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *product = response.products;
    if (!product.count)
    {
        NSLog(@"log-CS-未收到内购产品信息");
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
    if (currentProduct != nil) {
        SKPayment *payMent = [SKPayment paymentWithProduct:currentProduct];
        NSLog(@"log-CS-加入内购购买队列-开始发送购买请求");
        if (payMent)
        {
            [[SKPaymentQueue defaultQueue] addPayment:payMent];
        }
    }

}
#pragma mark <SKRequestDelegate>
- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"log-CS-内购购买请求成功");
    if ([self.deleagte respondsToSelector:@selector(SKRequestInDidFinish)]) {
        [self.deleagte SKRequestInDidFinish];
    }
    
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"log-CS-内购购买请求失败-error:%@",error);
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
                NSLog(@"内购产品购买成功");
                
                // no 二次验证
                //[self completeTransaction:tran];
                
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
                NSString *receiptString = [tran.transactionReceipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
                if ([self.deleagte respondsToSelector:@selector(restoreTransactionWithProductId:transactionReceipt:transactionId:)]) {
                    [self.deleagte restoreTransactionWithProductId:productId transactionReceipt:receiptString transactionId:tran.transactionIdentifier];
                }
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"内购商品购买失败");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                NSString *productId = tran.payment.productIdentifier;
                if ([self.deleagte respondsToSelector:@selector(IAPFailTransactionWithProductId:errorLocalizedDescription:)]) {
                    [self.deleagte IAPFailTransactionWithProductId:productId errorLocalizedDescription:tran.error.localizedDescription];
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
//    NSDictionary * bodyDic = @{
//        @"receipt-data":receiptString,
//        @"password":@"xxx"
//    };
//    NSString *bodyString = [self dictionaryToJson:bodyDic];
    
    // 其他
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据

    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString: @"https://buy.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestM completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
            return;
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        if([dic[@"status"] intValue]==0){
            //正式环境验证通过（说明是上线以后的用户购买）
            NSLog(@"购买成功！");
            //调用setVip接口
            
        }else if([dic[@"status"] intValue]== 21007){
            //第二步，验证测试环境
            [self verifyPurchaseWithTestEnvironment:bodyData receiptString:receiptString productIdentifer:productIdentifer];
        }else {
            NSLog(@"验证失败,订单出错");
            
        }
        
    }] resume];
    
}

// 创建请求到苹果官方进行购买验证（测试环境）
- (void)verifyPurchaseWithTestEnvironment:(NSData *)bodyData receiptString:(NSString *)receiptString productIdentifer:(NSString *)productIdentifer  {
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    NSURL *url=[NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestM completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
            return;
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        if([dic[@"status"] intValue]==0){
            NSLog(@"购买成功！");
            //调用setVip接口
            
        }else {
            NSLog( @"验证失败,订单出错" );
        }
        
    }] resume];
    
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
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




@end


