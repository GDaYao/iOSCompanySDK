

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWKeychainItemWrapper : NSObject {
    NSMutableDictionary *keychainItemData;
    NSString* _identifier;
    NSMutableDictionary *genericPasswordQuery;
}


@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;
@property (nonatomic, strong) NSMutableDictionary *keychainItemData;


- (void)cwResetKeychainItem;

- (id)cwObjectForKey:(id)key;
- (id)initCWWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
- (void)cwSetObject:(id)inObject forKey:(id)key;


@end

NS_ASSUME_NONNULL_END
