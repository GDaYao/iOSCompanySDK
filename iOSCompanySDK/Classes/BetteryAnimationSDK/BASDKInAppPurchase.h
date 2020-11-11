

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol BASDKInAppPurchaseDelegate <NSObject>

#pragma mark <SKProductsRequestDelegate>

- (void)productRequestInReceiveResponseWithNullProduct;

#pragma mark <SKRequestDelegate>

- (void)SKRequestInDidFinish;
- (void)SKRequestInDidFailWithError:(NSError *)error;

#pragma mark <SKPaymentTransactionObserver>

- (void)completeTransactionWithProductId:(NSString *)productId transactionReceipt:(NSString *)receiptString transactionId:(NSString *)transactionId;

- (void)purchasingTransactionInSKPayment;

- (void)restoreTransactionWithProductId:(NSString *)productId transactionReceipt:(NSString *)receiptString transactionId:(NSString *)transactionId;

- (void)IAPFailTransactionWithProductId:(NSString *)productId errorLocalizedDescription:(NSString *)errorLocalizedDescription;


@end



@interface BASDKInAppPurchase : NSObject

@property (nonatomic,weak)id <BASDKInAppPurchaseDelegate> deleagte;



#pragma mark - In-App purchase
- (void)addTransactionObserver:(id)observer;

- (void)removeTransactionObserver:(id)observer;

- (void)requestProductIdData:(NSString *)productId;

- (void)restoreProductId;



@end

NS_ASSUME_NONNULL_END


