

#import "CWPhotoMgr.h"

@implementation CWPhotoMgr


+ (void)cwSelectPhotoFromAlbumWithVC:(UIViewController *)currentVC setPickerControllerDelegate:(id)delegate allowsEditing:(BOOL)allowsEditing {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = delegate;
    imagePickerController.allowsEditing = allowsEditing;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [currentVC presentViewController:imagePickerController animated:YES completion:nil];
}

+ (void)cwAddPhotoToAlbumWithImage:(UIImage *)currentImage completionTarget:(id)completionTarget completionSelector:(SEL)selector {
    UIImageWriteToSavedPhotosAlbum(currentImage, completionTarget, selector, NULL);
}

@end
