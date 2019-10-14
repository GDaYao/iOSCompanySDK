

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol CWInAppPurchaseMgrDelegate <NSObject>


#pragma mark <SKPaymentTransactionObserver>
// transaction observer <SKPaymentTransactionObserver>
/**
 complete transcation

 @param productId 内购产品id.
 @param receiptString receipt string with base64 encoded string.
 @param transactionId transaction identifier.
 */
- (void)completeTransactionWithProductId:(NSString *)productId transactionReceipt:(NSString *)receiptString transactionId:(NSString *)transactionId;
#pragma mark <SKProductsRequestDelegate>
// no product information 未收到产品信息 -- 产品内购id为空 <SKProductsRequestDelegate>
- (void)productRequestInReceiveResponseWithNullProduct;

/**
 内购商品加入购物车
 */
- (void)purchasingTransactionInSKPayment;

#pragma mark <SKRequestDelegate>
// SKRequest <SKRequestDelegate>
- (void)SKRequestInDidFinish;
- (void)SKRequestInDidFailWithError:(NSError *)error;
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



@interface CWInAppPurchaseMgr : NSObject

@property (nonatomic,weak)id <CWInAppPurchaseMgrDelegate> deleagte;


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
 

 @param productId 应用内购id-注意区分多个内购id
 */
- (void)requestProductIdData:(NSString *)productId;


/**
 restore product - 恢复购买
 */
- (void)restoreProductId;




@end

NS_ASSUME_NONNULL_END
