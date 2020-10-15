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


// 输出flag
#define NeedLogging 0
#define NeedProgress 0

// 打印日志
#if NeedLogging==1

//#define LOGGING

#endif

// 打印生成进程
#if NeedProgress==1

//#define PROGRESS 1

#endif




#define kAlphaVideoCombineImgFinishNotification @"AlphaVideoCombineImgFinishNotification"


//  模板定制 - 两个资源文件名称
#define kVideoColorStr @"mvRGB.mp4"
#define kVideoMaskStr @"mvAlpha.mp4"
#define kVideoJsonStr @"mvJson.json"

 
@interface AVSDKAssetAlphaJoinBgImgExportVideo : NSObject


//
+ (AVSDKAssetAlphaJoinBgImgExportVideo *)aVSDKAssetAlphaJoinBgImgExportVideo;



//  load resources
/// use method
/// @param rgbFilePath rgb 视频文件
/// @param movieAlphaFilePath alpha灰度图文件
/// @param outPath 输出文件路径
/// @param bgCoverImg 替换背景图片UIImage
/// @param bgCoverImgPoint 给定替换背景图片坐标（在视频本身画布坐标系）
/// @param needCoverImgSize 给定替换背景图片大小(在视频本身画布坐标系)
- (void)loadAVAnimationResourcesWithMovieRGBFilePath:(NSString *)rgbFilePath movieAlphaFilePath:(NSString *)movieAlphaFilePath outPath:(NSString *)outPath bgCoverImg:(UIImage *)bgCoverImg bgCoverImgPoint:(CGPoint)bgCoverImgPoint needCoverImgSize:(CGSize)needCoverImgSize;



@end

NS_ASSUME_NONNULL_END


/*  动态壁纸主包模板--开发改进体验方案:
 
** 视频的每帧是不会带透明通道的。只有使用两个视频进行素材处理像素合成 **

方案1. 开发使用解决AVAnimator导致的问题。 --> 查看详细逻辑和原理。
    方案1：目标-加快读取速度，减小mvid体积。
    * 使用MovieMaker，Check，mvid的生成速度。
    * 测试生成mvid的包大小，以及代码 -- 先期查看mvid包那么大的原因，然后择机更改。
    * 加快mvid的播放速度以及效果质量。
    * 减小mvid体积，最后在进行一次7zip压缩处理。
    * 加快速度使用多线程处理。
    * 查看，并按照，原先使用的压缩flag处理。
    
方案2：  目标-直接生成新的视频直接播放即可。不要在再去存储各个字节了。
    * 使用导出的image，与后面的image合成新的image。 //使用对应的需要alpha=1.0，地方，使用选择的图片的rgb像素代替。
    * 处理每张图片的image，保证imagedata很小，在去合成视频。
    * 处理所有的image，然后生成一个新的mp4视频。

    * 优化所需要的代码，不要的代码移除，加快速度。
    * 1. 优化生成像素处理速度。 2. 使用多线程优化图片buffer生成速度。
    * 处理图片放置位置，使用json定位。 （后期是否可以直接使用像素替换，alpha！=255时判断处理，然后每个位置对应处理。）

    * 没有声音，导出的视频需要合成声音。
    * 最后可支持导出 实况照片。


方案3:
    提前loading资源，存储image对象。需要生成时在操作。


// 方案4:
    *  直接使用 带透明通道视频，合成。 -- 此方案不可用，因为合成需要layer，而layer不可为透明。

    
2. 查看具体FFmpeg/GPUImage 使用处理，图片和视频整合。 -- 更换使用GPUImage，直播代码实现。

3. 使用视频分解成1s30帧图片，解析图片，在生成组合成新的视频。

4. 使用 SpriteKit ，替代third libary,
 https://stackoverflow.com/questions/19652246/play-the-transparent-video-on-top-of-uiview
 
5. 使用破解“熊猫动态壁纸” 应用方式查看其使用方式。

 
*/
