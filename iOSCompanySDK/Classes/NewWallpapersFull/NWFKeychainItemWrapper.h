


#import <UIKit/UIKit.h>


@interface NWFKeychainItemWrapper: NSObject {
    NSMutableDictionary *keychainItemData;        // The actual keychain item data backing store.
    NSMutableDictionary *genericPasswordQuery;    // A placeholder for the generic keychain item query used to locate the item.
    NSString* _identifier;
}


@property (nonatomic, strong) NSMutableDictionary *keychainItemData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;

// Designated initializer.
- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;


- (void)resetKeychainItem;


@end
