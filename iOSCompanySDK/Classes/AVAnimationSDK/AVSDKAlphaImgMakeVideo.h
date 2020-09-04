////  AVSDKAlphaImgMakeVideo.h
//  iOSCompanySDK
//
//  Created on 2020/9/3.
//  
//


/** func: 帧图片合成视频 工具类
 
 */

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

#if __has_feature(objc_generics) || __has_extension(objc_generics)
    #define AVSDK_GENERIC_URL <NSURL *>
    #define AVSDK_GENERIC_IMAGE <UIImage *>
#else
    #define AVSDK_GENERIC_URL
    #define AVSDK_GENERIC_IMAGE
#endif

typedef void(^avsdkAlphaImgMakeVideoCompletionBlock)(NSURL *fileUrl);


@interface AVSDKAlphaImgMakeVideo : NSObject

@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *writerInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *bufferAdapter;
@property (nonatomic, strong) NSDictionary *videoSettings;
@property (nonatomic, assign) CMTime frameTime;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic,copy)avsdkAlphaImgMakeVideoCompletionBlock makeCompletionBlock;


+ (NSDictionary *)videoSettingsWithCodec:(NSString *)codec withWidth:(CGFloat)width andHeight:(CGFloat)height;
- (instancetype)initWithSettings:(NSDictionary *)videoSettings exportVideoPath:(NSString *)exportVideoPath;


//  单个图片导入处理
// 初始化各参数
- (void)createMovieInitProperty;
- (void)createMovieAppenPixelBufferWithImage:(UIImage *)img imgIndex:(NSInteger)i;
// 全部图片导入完成
- (void)createMovieFinishWithCompletion:(avsdkAlphaImgMakeVideoCompletionBlock)completion;



@end

NS_ASSUME_NONNULL_END