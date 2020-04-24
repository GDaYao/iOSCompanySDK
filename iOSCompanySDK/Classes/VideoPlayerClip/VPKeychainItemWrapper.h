////  VPKeychainItemWrapper.h



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VPKeychainItemWrapper : NSObject
{
    NSMutableDictionary *keychainItemData;
    NSMutableDictionary *genericPasswordQuery;
    NSString* _identifier;
}

@property (nonatomic, strong) NSMutableDictionary *keychainItemData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;


// init
- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;

// Initializes and resets the default generic keychain item data.
- (void)resetKeychainItem;



@end

NS_ASSUME_NONNULL_END
