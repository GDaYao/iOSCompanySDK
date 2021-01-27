////  VCSDKKeychainItemWrapper.h
//  iOSCompanySDK
//
//  Created on 2021/1/27.
//  
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VCSDKKeychainItemWrapper : NSObject {
    NSMutableDictionary *keychainItemData;
    NSMutableDictionary *genericPasswordQuery;
    NSString *_identifier;
}
@property (nonatomic, strong) NSMutableDictionary *keychainItemData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;


- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;
- (void)resetKeychainItem;



@end

NS_ASSUME_NONNULL_END
