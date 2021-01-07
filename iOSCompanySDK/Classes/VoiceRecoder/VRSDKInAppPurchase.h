


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VRSDKInAppPurchaseDelegate <NSObject>


- (void)productRequestInReceiveResponseWithNullProduct;


- (void)SKRequestInDidFinish;
- (void)SKRequestInDidFailWithError:(NSError *)error;


- (void)completeTransactionWithProductId:(NSString *)productId transactionReceipt:(NSString *)receiptString transactionId:(NSString *)transactionId;

- (void)purchasingTransactionInSKPayment;

- (void)restoreTransactionWithProductId:(NSString *)productId transactionReceipt:(NSString *)receiptString transactionId:(NSString *)transactionId;

- (void)IAPFailTransactionWithProductId:(NSString *)productId errorLocalizedDescription:(NSString *)errorLocalizedDescription;


@end




@interface VRSDKInAppPurchase : NSObject

@property (nonatomic,weak)id <VRSDKInAppPurchaseDelegate> delegate;


- (void)addTransactionObserver:(id)observer;

- (void)removeTransactionObserver:(id)observer;

- (void)requestProductIdData:(NSString *)productId;

- (void)restoreProductId;




@end

NS_ASSUME_NONNULL_END
