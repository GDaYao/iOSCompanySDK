////  AVSDKAssetAlphaJoinBgImgExportVideo.h
//  iOSCompanySDK
//
//  Created on 2020/9/3.
//  
//

/** func:
 带透明通道视频+底部图像 ==> 导出新的视频。

*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kAlphaVideoCombineImgFinishNotification @"AlphaVideoCombineImgFinishNotification"


@interface AVSDKAssetAlphaJoinBgImgExportVideo : NSObject


//
+ (AVSDKAssetAlphaJoinBgImgExportVideo *)aVSDKAssetAlphaJoinBgImgExportVideo;



//  load resources
- (void)loadAVAnimationResourcesWithMovieRGBFilePath:(NSString *)rgbFilePath movieAlphaFilePath:(NSString *)movieAlphaFilePath outPath:(NSString *)outPath bgCoverImg:(UIImage *)bgCoverImg bgCoverImgPoint:(CGPoint)bgCoverImgPoint;



@end

NS_ASSUME_NONNULL_END
