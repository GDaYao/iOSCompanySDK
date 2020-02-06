////  NPTInAppPurchase.h
//  iOSCompanySDK
//
//  Created on 2020/2/6.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NPTInAppPurchaseDelegate <NSObject>

#pragma mark <SKProductsRequestDelegate>

- (void)nptProductRequestInReceiveResponseWithNullProduct;

#pragma mark <SKRequestDelegate>

- (void)NPTSKRequestInDidFinish;
- (void)NPTSKRequestInDidFailWithError:(NSError *)error;

#pragma mark <SKPaymentTransactionObserver>

- (void)nptCompleteTransactionWithProductId:(NSString *)productId transactionReceipt:(NSString *)receiptString transactionId:(NSString *)transactionId;

- (void)nptPurchasingTransactionInSKPayment;


- (void)nptRestoreTransactionWithProductId:(NSString *)productId transactionReceipt:(NSString *)receiptString transactionId:(NSString *)transactionId;


 - (void)nptIAPFailTransactionWithProductId:(NSString *)productId errorLocalizedDescription:(NSString *)errorLocalizedDescription;


@end


@interface NPTInAppPurchase : NSObject

@property (nonatomic,weak)id <NPTInAppPurchaseDelegate> deleagte;


#pragma mark - In-App purchase
/**
 add transaction observer -- 设置内购监听

 @param observer 设置内购监听对象--可不传
 */
- (void)nptAddTransactionObserver:(id)observer;
/**
 remove transaction observer -- 移除设置的内购监听

 @param observer 移除设置的内购监听--可不传
 */
- (void)nptRemoveTransactionObserver:(id)observer;
/**
 传入对应productId-内购id进行app内验证
 实现相应的内购监听，实现CreativePapersInAppPurchaseDelegate代理方法即可。

 @param productId 应用内购id-注意区分多个内购id
 */
- (void)nptRequestProductIdData:(NSString *)productId;

/**
 restore product - 恢复购买
 */
- (void)nptRestoreProductId;



@end

NS_ASSUME_NONNULL_END


