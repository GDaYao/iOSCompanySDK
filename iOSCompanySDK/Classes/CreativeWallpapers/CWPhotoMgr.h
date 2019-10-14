

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWPhotoMgr : NSObject


+ (void)cwSelectPhotoFromAlbumWithVC:(UIViewController *)currentVC setPickerControllerDelegate:(id)delegate allowsEditing:(BOOL)allowsEditing;

+ (void)cwAddPhotoToAlbumWithImage:(UIImage *)currentImage completionTarget:(id)completionTarget completionSelector:(SEL)selector;






@end

NS_ASSUME_NONNULL_END
