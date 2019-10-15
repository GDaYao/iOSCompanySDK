////  NWFInAppPurchase.h
//  
//
//  Created on 2019/10/9.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NWFInAppPurchaseDelegate <NSObject>

#pragma mark <SKProductsRequestDelegate>

- (void)productRequestInReceiveResponseWithNullProduct;

#pragma mark <SKRequestDelegate>

- (void)SKRequestInDidFinish;
- (void)SKRequestInDidFailWithError:(NSError *)error;

#pragma mark <SKPaymentTransactionObserver>

- (void)completeTransactionWithProductId:(NSString *)productId transactionReceipt:(NSString *)receiptString transactionId:(NSString *)transactionId;
/**
 内购商品加入购物车
 */
- (void)purchasingTransactionInSKPayment;
/**
 restore transaction

 @param productId 内购产品id.
 @param receiptString receipt string with base64 encoded string.
 @param transactionId transaction identifier.
 */
- (void)restoreTransactionWithProductId:(NSString *)productId transactionReceipt:(NSString *)receiptString transactionId:(NSString *)transactionId;
/**
 内购商品购买失败

 @param productId product id-内购商品id
 */
- (void)failTransactionWithProductId:(NSString *)productId;


@end



@interface NWFInAppPurchase : NSObject

@property (nonatomic,weak)id <NWFInAppPurchaseDelegate> deleagte;


#pragma mark - app request review
/**

 
 /// test test test
 */
+ (void)appRequestReviewWithAppId:(NSString *)appIdStr;


#pragma mark - In-App purchase
/**
 add transaction observer -- 设置内购监听

 @param observer 设置内购监听对象--可不传
 */
- (void)addTransactionObserver:(id)observer;
/**
 remove transaction observer -- 移除设置的内购监听

 @param observer 移除设置的内购监听--可不传
 */
- (void)removeTransactionObserver:(id)observer;
/**
 传入对应productId-内购id进行app内验证
 实现相应的内购监听，实现CreativePapersInAppPurchaseDelegate代理方法即可。

 @param productId 应用内购id-注意区分多个内购id
 */
- (void)requestProductIdData:(NSString *)productId;

/**
 restore product - 恢复购买
 */
- (void)restoreProductId;








@end

NS_ASSUME_NONNULL_END
