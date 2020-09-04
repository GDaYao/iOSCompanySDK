////  AVSDKAssetAlphaJoinBgImgExportVideo.m
//  iOSCompanySDK
//
//  Created on 2020/9/3.
//  
//

#import "AVSDKAssetAlphaJoinBgImgExportVideo.h"

#import "AVSDKAssetFrameDecoder.h"
#import "AVSDKCGFrameBuffer.h"
#import "AVSDKAlphaImgMakeVideo.h"
#import "AVSDKAVFrame.h"

#import "AVSDKMovdata.h"


@interface AVSDKAssetAlphaJoinBgImgExportVideo ()

// 背景图位置point
@property (nonatomic,assign)CGPoint bgCoverImgPoint;
// 后面背景图
@property (nonatomic,strong)UIImage *bgCoverImg;



// movie rgb file path name
@property (nonatomic, copy) NSString *movieRGBFilename;

// alpha movie file path name
@property (nonatomic, copy) NSString *movieAlphaFilename;

// export video path,example: ~/xxx/xxx.mp4
@property (nonatomic, copy) NSString *outPath;

@end



@implementation AVSDKAssetAlphaJoinBgImgExportVideo



#pragma mark - obj init
+ (AVSDKAssetAlphaJoinBgImgExportVideo *)aVSDKAssetAlphaJoinBgImgExportVideo {
    AVSDKAssetAlphaJoinBgImgExportVideo *obj = [[AVSDKAssetAlphaJoinBgImgExportVideo alloc]init];
    return obj;
}

#pragma mark - load resources
- (void)loadAVAnimationResourcesWithMovieRGBFilePath:(NSString *)rgbFilePath movieAlphaFilePath:(NSString *)movieAlphaFilePath outPath:(NSString *)outPath bgCoverImg:(UIImage *)bgCoverImg bgCoverImgPoint:(CGPoint)bgCoverImgPoint {
    
    self.movieRGBFilename = rgbFilePath;
    self.movieAlphaFilename = movieAlphaFilePath;
    self.outPath = outPath;
    self.bgCoverImg = bgCoverImg;
    self.bgCoverImgPoint = bgCoverImgPoint;
    
    NSAssert(self.movieRGBFilename, @"movie rgb path is nil");
    NSAssert(self.movieAlphaFilename, @"movie alpha path is nil");
    NSAssert(self.outPath, @"movie out path is nil");
    
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *tmpBgCoverPath = [tmpDir stringByAppendingFormat:@"tmpBgCover.png"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:tmpBgCoverPath]) {
        [fm removeItemAtPath:tmpBgCoverPath error:nil];
    }
    NSData *data = [NSData dataWithData:UIImagePNGRepresentation(bgCoverImg)];
    [data writeToFile:tmpBgCoverPath atomically:YES];
    
    NSString *bgCoverImgPointStr = NSStringFromCGPoint(bgCoverImgPoint);
    
    NSArray *arr = [NSArray arrayWithObjects:self.movieRGBFilename,
                    self.movieAlphaFilename,
                    self.outPath,
                    tmpBgCoverPath,
                    bgCoverImgPointStr,
                    nil];
    //NSAssert([arr count] == 4, @"arr count is not enough 3");
    [NSThread detachNewThreadSelector:@selector(detachThreadLoadEntryPoint:) toTarget:self.class withObject:arr];
}


// detach thread start
+ (void)detachThreadLoadEntryPoint:(NSArray *)arr {
    
    @autoreleasepool {
        // pass some arguments
        NSString *rgbAssetPath = [arr objectAtIndex:0];
        NSString *alphaAssetPath = [arr objectAtIndex:1];
        NSString *outPath = [arr objectAtIndex:2];
        
        NSString *tmpBgCoverPath = [arr objectAtIndex:3];
        NSString *bgCoverImgPointStr = [arr objectAtIndex:4];
        CGPoint bgCoverImgPoint = CGPointFromString(bgCoverImgPointStr);
        
        [self joinRGBAlphaWithrgbPath:rgbAssetPath alphaPath:alphaAssetPath outPath:outPath tmpBgCoverPath:tmpBgCoverPath bgCoverImgPoint:bgCoverImgPoint];
        
    }
    
}

#pragma mark - add rgb+alpha path
+ (BOOL)joinRGBAlphaWithrgbPath:(NSString *)rgbPath alphaPath:(NSString *)alphaPath outPath:(NSString *)outPath tmpBgCoverPath:(NSString *)tmpBgCoverPath bgCoverImgPoint:(CGPoint)bgCoverImgPoint {
    
    // open both the rgb and alpha video src file.
    AVSDKAssetFrameDecoder *frameDecoderRGB = [AVSDKAssetFrameDecoder aVSDKAssetFrameDecoder];
    AVSDKAssetFrameDecoder *frameDecoderAlpha = [AVSDKAssetFrameDecoder aVSDKAssetFrameDecoder];
    
    BOOL worked;
    
     worked = [frameDecoderRGB openForReading:rgbPath];
    if (worked == FALSE) {
#ifdef DEBUG
        NSLog(@"log-error:cannot open rgb file-%@",rgbPath);
#endif
        return FALSE;
    }
    
    worked = [frameDecoderAlpha openForReading:alphaPath];
    if (worked == FALSE ) {
#ifdef DEBUG
        NSLog(@"log-error:cannot open alpha file-%@",alphaPath);
#endif
        return FALSE;
    }
    
    worked = [frameDecoderRGB allocateDecodeResources];
    if (worked == FALSE) {
#ifdef DEBUG
        NSLog(@"log-error:cannot allocate RGB decode resources  for filename-%@", alphaPath);
#endif
        return FALSE;
    }
    
    worked = [frameDecoderAlpha allocateDecodeResources];
    if (worked == FALSE) {
#ifdef DEBUG
        NSLog(@"log-error:cannot allocate ALPHA decode resources  for filename-%@", alphaPath);
#endif
        return FALSE;
    }
    
    
    // BPP for decoded asset is always 32 BPP
    
    // framerate
    NSTimeInterval frameRate = frameDecoderRGB.frameDuration;      // 获得RGB资源帧速率
    NSTimeInterval frameRateAlpha = frameDecoderAlpha.frameDuration; // 获取alpha资源帧速率
    if (frameRate != frameRateAlpha) {
        NSLog(@"error: RGB movie fps %.4f does not match alpha movie fps %.4f",
              1.0f/(float)frameRate, 1.0f/(float)frameRateAlpha);
        return FALSE;
    }
    
    // num frames
    
    NSUInteger numFrames = [frameDecoderRGB numFrames];
    NSUInteger numFramesAlpha = [frameDecoderAlpha numFrames];
    if (numFrames != numFramesAlpha) {
        NSLog(@"error: RGB movie numFrames %d does not match alpha movie numFrames %d", (int)numFrames, (int)numFramesAlpha);
        return FALSE;
    }
    
    // width x height
    
    int width  = (int) [frameDecoderRGB width];
    int height = (int) [frameDecoderRGB height];
    NSAssert(width > 0, @"width");
    NSAssert(height > 0, @"height");
    CGSize size = CGSizeMake(width, height);
    
    // Size of Alpha movie must match size of RGB movie
    CGSize alphaMovieSize;
    alphaMovieSize = CGSizeMake(frameDecoderAlpha.width, frameDecoderAlpha.height);
    if (CGSizeEqualToSize(size, alphaMovieSize) == FALSE) {
#ifdef DEBUG
        NSLog(@"error: RGB movie size (%d, %d) does not match alpha movie size (%d, %d)",
              (int)width, (int)height,
              (int)alphaMovieSize.width, (int)alphaMovieSize.height);
#endif
        return FALSE;
    }

    AVSDKCGFrameBuffer *combinedFrameBuffer = [AVSDKCGFrameBuffer avsdkCGFrameBufferWithBppDimensions:32 width:width height:height];
    // 像素转储用于将预期结果与iOS解码器硬件产生的实际结果进行比较
    
    
    // TODO: for 循环 -- 遍历所有帧，即处理所有帧
    BOOL isExecute = [self executeForLoop:numFrames frameDecoderRGB:frameDecoderRGB frameDecoderAlpha:frameDecoderAlpha combinedFrameBuffer:combinedFrameBuffer width:width height:height outPath:outPath tmpBgCoverPath:tmpBgCoverPath bgCoverImgPoint:bgCoverImgPoint];
    
    if (isExecute == FALSE) {
        return FALSE;
    }
    
    
    return TRUE;
}


// TODO: 执行for循环,拿出来使用
+ (BOOL)executeForLoop:(NSUInteger)numFrames  frameDecoderRGB:(AVSDKAssetFrameDecoder *)frameDecoderRGB frameDecoderAlpha:(AVSDKAssetFrameDecoder *)frameDecoderAlpha  combinedFrameBuffer:(AVSDKCGFrameBuffer *)combinedFrameBuffer width:(int)width height:(int)height outPath:(NSString *)outPath tmpBgCoverPath:(NSString *)tmpBgCoverPath bgCoverImgPoint:(CGPoint)bgCoverImgPoint  {
    
    //UIImage *bgCoverImg = [UIImage imageNamed:@"tmp-1.jpg"];
    // TODO: 底部背景图,从存储的文件中读取
    UIImage *bgCoverImg = [UIImage imageWithContentsOfFile:tmpBgCoverPath];
    AVSDKCGFrameBuffer *bgCoverFrameBuffer = [self getBgCoverImgFrameBufferWithCurrentImg:bgCoverImg newImgSize:CGSizeMake(width, 0)];
    
    AVSDKAlphaImgMakeVideo *movieMaker  = [self singlaImgToGenerateMOVWithNumFrames:numFrames VideoSize:CGSizeMake(width, height) frameTime:frameDecoderRGB.frameTime exportVideoPath:outPath];
    
    
    // 正序循环
    for (NSUInteger frameIndex = 0; frameIndex < numFrames; frameIndex++) @autoreleasepool {
        
#ifdef DEBUG

#if PROGRESS==1
        NSLog(@"log-joinRGBAndAlpha-reading frame %d", frameIndex);
#endif // LOGGING

#endif
        
        // 1. 读取RGB+alpha文件 ==> 此处耗时大概:在有frame.image2s-7s(模拟器);无frame.image:大概性能提升1-2s间。
        AVSDKAVFrame *frameRGB = [frameDecoderRGB advanceToFrame:frameIndex]; // AVAssetFrameDecoder 获取当前帧图像，包含在 frameRGB.image
        assert(frameRGB);
        
        AVSDKAVFrame *frameAlpha = [frameDecoderAlpha advanceToFrame:frameIndex];
        assert(frameAlpha);
        
#ifdef DEBUG
        // 去除了AVSDKAVFrame中image图像生成，直接为nil
        // 是否需要 -- 转储RGB和ALPHA帧的图像 TRUE/FALSE
        if (FALSE) {
//            // Dump images for the RGB and ALPHA frames
//            // Write image as PNG
//            NSString *tmpDir = NSTemporaryDirectory();
//            NSString *tmpPNGPath = [tmpDir stringByAppendingFormat:@"JoinAlpha_RGB_Frame%d.png", (int)(frameIndex + 1)];
//            NSData *data = [NSData dataWithData:UIImagePNGRepresentation(frameRGB.image)];
//            [data writeToFile:tmpPNGPath atomically:YES];
//            //NSLog(@"log-wrote %@", tmpPNGPath);
//
//            tmpPNGPath = [tmpDir stringByAppendingFormat:@"JoinAlpha_ALPHA_Frame%d.png", (int)(frameIndex + 1)];
//            data = [NSData dataWithData:UIImagePNGRepresentation(frameAlpha.image)];
//            [data writeToFile:tmpPNGPath atomically:YES];
//            //NSLog(@"log-wrote %@", tmpPNGPath);
        }
#endif
        
        
        // 在框架内释放UIImage ref，因为我们将直接对图像数据进行操作。
        // Release the UIImage ref inside the frame since we will operate on the image data directly.
        frameRGB.image = nil;   // 操作完成后释放image图像
        frameAlpha.image = nil;
        
        
        AVSDKCGFrameBuffer *cgFrameBufferRGB = frameRGB.cgFrameBuffer;
        NSAssert(cgFrameBufferRGB, @"cgFrameBufferRGB");
        
        AVSDKCGFrameBuffer *cgFrameBufferAlpha = frameAlpha.cgFrameBuffer;
        NSAssert(cgFrameBufferAlpha, @"cgFrameBufferAlpha");
        
        // sRGB
        if (frameIndex == 0) {
            combinedFrameBuffer.colorspace = cgFrameBufferRGB.colorspace;
        }
        
        // Join RGB and ALPHA
        uint32_t numPixels = width * height;  // 每张图片所包含像素数值
        uint32_t *combinedPixels = (uint32_t*)combinedFrameBuffer.pixels;
        uint32_t *rgbPixels = (uint32_t*)cgFrameBufferRGB.pixels;
        uint32_t *alphaPixels = (uint32_t*)cgFrameBufferAlpha.pixels;
        
        // RGB和alpha透明通道混合 -- 达到的结果是更新 combinedPixels 数值
        // 2. 此处耗时大概:5-6s
        [self combineRGBAndAlphaPixels:numPixels
                        combinedPixels:combinedPixels
                             rgbPixels:rgbPixels
                           alphaPixels:alphaPixels];
        
        
        
        // Write combined RGBA pixles as a keyframe, we do not attempt to calculate
        // frame diffs when processing on the device as that takes too long.
        // 将组合的RGBA像素写为关键帧，我们不会尝试计算各帧差异当在设备上处理时，那将占用很长时间。
        int numBytesInBuffer = (int) combinedFrameBuffer.numBytes;
        
        // 3. 合成所有image - 并保存. 耗时:1-2
        AVSDKAVFrame *disFrame = [AVSDKAVFrame avsdkAVFrame];
        disFrame.cgFrameBuffer = combinedFrameBuffer;  // 使用最新的 `combinedFrameBuffer` 生成最新的image。
        [disFrame makeImageFromFramebuffer];

        
        // 4. 需要的背景图+带alpha每一帧==>合成新的图片. 耗时:20-26s左右
        //UIImage *newImg = [self imageByCombiningImageNewImgSize:CGSizeMake(width, height) firstImage:bgCoverImg withImage:disFrame.image bgCoverPoint:bgCoverImgPoint];
        UIImage *newImg = disFrame.image; // 测试使用透明图片，导出的视频是否是透明的。

        
        // a. 添加到图片数组中，以便合成
        //[imgs addObject:newImg];
        // b.
        //NSData *newImgData = [NSData dataWithData:UIImagePNGRepresentation(newImg)];
        //[imgs addObject:newImgData];
        // c. 单个图片存储在mov buffer数据中
        // 4. 添加到视频中存储。耗时:20-30s
        [movieMaker createMovieAppenPixelBufferWithImage:newImg imgIndex:frameIndex];
        
        
        //  TODO: 使用完成释放需要释放
        frameRGB = nil;
        frameAlpha = nil;
        
        [cgFrameBufferRGB clear];
        [cgFrameBufferAlpha clear];
        
        numPixels = 0;
        combinedPixels = 0;
        rgbPixels = 0;
        alphaPixels = 0;
        
        
        disFrame.image = nil;
        disFrame = nil;
        
        newImg = nil;
        
        
#ifdef DEBUG
        // mEncodeData 是处理完、压缩完成的data数据
//        if (FALSE) {
//            NSString *tmpDir = NSTemporaryDirectory();
//            // png /jpg
//            NSString *disPNGPath = [tmpDir stringByAppendingFormat:@"JoinAlpha_RGBA_%d.jpg", (int)(frameIndex + 1)];
//
//            NSData *data = [NSData dataWithData:UIImagePNGRepresentation(newImg)];
//            NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(newImg, 0.5)];
//            [data writeToFile:disPNGPath atomically:YES];
//            UIImage *disImg = newImg;
//            NSLog(@"log-测试:%@",disPNGPath);
//        }
#endif
    }
    
    // 1. 全部图片统一生成mov
//    [self imagesToGenerateMOVWith:imgs videoSize:CGSizeMake(width, height) frameTime:frameDecoderRGB.frameTime writefinish:^(NSURL *fileURL) {
//        NSLog(@"log-生成视频路径地址:%@",fileURL.path);
//        NSLog(@"log-test");
//    }];
    
    // 2. 全部图片导入完成 ==> 开始生成
    [movieMaker createMovieFinishWithCompletion:^(NSURL * _Nonnull fileUrl) {
        NSLog(@"log-生成视频路径地址:%@",fileUrl.path);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kAlphaVideoCombineImgFinishNotification object:nil];
        
    }];
#pragma mark 合成完毕导出
    
    
    return TRUE;
}


// Join the RGB and Alpha components of two input framebuffers
// so that the final output result contains native premultiplied
// 32 BPP pixels.
// TODO: 更新pixels -- 连接两个输入帧缓冲区的RGB和Alpha分量，以便最终输出结果包含本机预乘的32 BPP像素。 -- 使用rgbPixels,alphaPixels，组合替换combinedPixels.
+ (void) combineRGBAndAlphaPixels:(uint32_t)numPixels
                   combinedPixels:(uint32_t*)combinedPixels
                        rgbPixels:(uint32_t*)rgbPixels
                      alphaPixels:(uint32_t*)alphaPixels
{
    
#ifdef DEBUG
//    NSMutableArray *alphaMuArr = [NSMutableArray array];
#endif
    
    // 一帧图像含有 numPixels 像素
    for (uint32_t pixeli = 0; pixeli < numPixels; pixeli++) {
        uint32_t pixelAlpha = alphaPixels[pixeli];
        uint32_t pixelRGB = rgbPixels[pixeli];
        
        // All 3 components of the ALPHA pixel should be the same in grayscale mode.
        // If these are not exactly the same, this is likely caused by limited precision
        // ranges in the hardware color conversion logic.
        // 在灰度模式下，alpha像素的所有3个分量都应该相同
        // 如果它们不完全相同，则可能是由于硬件颜色转换逻辑中的精度范围有限所致。
        uint32_t pixelAlphaRed = (pixelAlpha >> 16) & 0xFF; //  alpha pixel 应该都为255,255,255
        uint32_t pixelAlphaGreen = (pixelAlpha >> 8) & 0xFF;
        uint32_t pixelAlphaBlue = (pixelAlpha >> 0) & 0xFF;
        
        // 16进制色值使用
        // hexValue [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
        
#if defined(DEBUG)
        if (FALSE) {
            uint32_t pixelRed = (pixelRGB >> 16) & 0xFF;
            uint32_t pixelGreen = (pixelRGB >> 8) & 0xFF;
            uint32_t pixelBlue = (pixelRGB >> 0) & 0xFF;

            NSLog(@"log-输出每个像素-rgbA-processing pixeli %d : (%3d %3d %3d) : alpha grayscale %3d %3d %3d", pixeli, pixelRed, pixelGreen, pixelBlue, pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue);
        }
#endif // DEBUG
        
        //    if ((pixeli % 256) == 0) {
        //      NSLog(@"processing row %d", (pixeli / 256));
        //    }
        
        //    if ((pixeli >= (2 * 256)) && (pixeli < (3 * 256))) {
        //      // Third row
        //      combinedPixels[pixeli] = combinedPixels[pixeli];
        //    }
        
        
        // 进行判断alpha通道像素值，应该使用RGB中哪个数值。
        if (pixelAlphaRed != pixelAlphaGreen || pixelAlphaRed != pixelAlphaBlue) {
            //NSLog(@"Input Alpha MVID input movie R G B components (%d %d %d) do not match at pixel %d", pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue, pixeli);
            //return FALSE;
            
            uint32_t sum = pixelAlphaRed + pixelAlphaGreen + pixelAlphaBlue;
            if (sum == 1) {
                // If two values are 0 and the other is 1, then assume the alpha value is zero. The iOS h264
                // decoding hardware seems to emit (R=0 G=0 B=1) even when the input is a grayscale black pixel.
                pixelAlpha = 0;
            } else if (sum == 2 && (pixelAlphaRed == 0 && pixelAlphaGreen == 2 && pixelAlphaBlue == 0)) {
                // The h.264 decoder seems to generate (R=0 G=2 B=0) for black in some weird cases on ARM64.
                pixelAlpha = 0;
#if defined(__arm64__) && __arm64__
            } else if ((pixelAlphaRed == pixelAlphaBlue) && (pixelAlphaRed+1 == pixelAlphaGreen)) {
                // The h.264 decoder in newer ARM64 devices seems to decode the grayscale values (2 2 2) as
                // (1 2 1) in certain cases. Choose an output grayscale value of 2 in these cases only
                // for this specific hardware decoder.
                
                pixelAlpha = pixelAlphaGreen;
            } else if ((pixelAlphaRed == pixelAlphaBlue) && (pixelAlphaRed+2 == pixelAlphaGreen)) {
                // The h.264 decoder in newer ARM64 devices seems to decode the grayscale values (3 3 3) as
                // (2 4 2) in certain cases. Choose an output grayscale value of 3 in these cases only
                // for this specific hardware decoder.
                
                pixelAlpha = pixelAlphaRed + 1;
#endif // __arm64__
            } else if (pixelAlphaRed == pixelAlphaBlue) {
                // The R and B pixel values are equal but these two values are not the same as the G pixel.
                // This indicates that the grayscale conversion should have resulted in value between the
                // two numbers.
                //
                // R G B components
                //
                // (3 1 3)       -> 2   <- (2, 2, 2) (sim)
                // (2 0 2)       -> 1   <- (1, 1, 1) (sim)
                // (18 16 18)    -> 17  <- (17, 17, 17) (sim)
                // (219 218 219) -> 218 <- (218, 218, 218) (sim)
                //
                // Note that in some cases the original values (5, 5, 5) get decoded as (5, 4, 5) and that results in 4 as the
                // alpha value. These cases are few and we just ignore them because the alpha is very close.
                
                if (pixelAlphaRed == 0) {
                    pixelAlpha = 0;
                } else {
                    pixelAlpha = pixelAlphaRed - 1;
                }
                
                //NSLog(@"Input Alpha MVID input movie R G B components (%d %d %d) do not match at pixel %d in frame %d", pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue, pixeli, frameIndex);
                //NSLog(@"Using RED/BLUE Alpha level %d at pixel %d in frame %d", pixelAlpha, pixeli, frameIndex);
            } else if ((pixelAlphaRed == (pixelAlphaGreen + 1)) && (pixelAlphaRed == (pixelAlphaBlue - 1))) {
                // Common case seen in hardware decoder output, average is the middle value.
                //
                // R G B components
                // (62, 61, 63)    -> 62  <- (62, 62, 62) (sim)
                // (111, 110, 112) -> 111 <- (111, 111, 111) (sim)
                
                pixelAlpha = pixelAlphaRed;
                
                //NSLog(@"Input Alpha MVID input movie R G B components (%d %d %d) do not match at pixel %d in frame %d", pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue, pixeli, frameIndex);
                //NSLog(@"Using RED (easy ave) Alpha level %d at pixel %d in frame %d", pixelAlpha, pixeli, frameIndex);
            } else {
                // Output did not match one of the know common patterns seen coming from iOS H264 decoder hardware.
                // Since this branch does not seem to ever be executed, just use the red component which is
                // basically the same as the branch above.
                
                //pixelAlpha = sum / 3;
                pixelAlpha = pixelAlphaRed;
                
                //NSLog(@"Input Alpha MVID input movie R G B components (%d %d %d) do not match at pixel %d in frame %d", pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue, pixeli, frameIndex);
                //NSLog(@"Using AVE Alpha level %d at pixel %d in frame %d", pixelAlpha, pixeli, frameIndex);
            }
            
            //NSLog(@"will use pixelAlpha %d", pixelAlpha);
        } else {
            // All values are equal, does not matter which channel we use as the alpha value
            // 所有值都相等，与我们使用哪个通道作为Alpha值无关紧要
            pixelAlpha = pixelAlphaRed; // 255，带有透明通道，即alpha=1
        }
        
        // Automatically filter out zero pixel values, because there are just so many
        //if (pixelAlpha != 0) {
        //fprintf(fp, "A[%d][%d] = %d\n", frameIndex, pixeli, pixelAlpha);
        //fprintf(fp, "A[%d][%d] = %d <- (%d, %d, %d)\n", frameIndex, pixeli, pixelAlpha, pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue);
        //}
        
        // RGB componenets are 24 BPP non pre-multiplied values
        
        uint32_t pixelRed = (pixelRGB >> 16) & 0xFF;
        uint32_t pixelGreen = (pixelRGB >> 8) & 0xFF;
        uint32_t pixelBlue = (pixelRGB >> 0) & 0xFF;
        
#ifdef DEBUG
//        if (FALSE) {
//            if (pixelAlpha != 255 ) {
//                NSLog(@"log-当前rgb透明-alpha:%f",pixelAlpha/255.0);
//            }
//            // 记住移除
//            NSNumber *alphaNum = [NSNumber numberWithFloat:pixelAlpha/255.0];
//            [alphaMuArr addObject:alphaNum];
//        }
#endif
        
        // 预乘分量，组合像素
        uint32_t combinedPixel = premultiply_bgra_inline(pixelRed, pixelGreen, pixelBlue, pixelAlpha);

#ifdef DEBUG
        // 输出每个存储像素值
//            NSLog(@"output combinedPixel 0x%08X", combinedPixel);
#endif
        
        combinedPixels[pixeli] = combinedPixel;
        
    }
    
    return;
}



#pragma mark -
// 判断是否有透明通道
+ (BOOL)hasAlphaWithCurrentImg:(UIImage *)img {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(img.CGImage);
    return (alpha==kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
}

// 单张图片转换CGFrameBuffer属性 -- 主要用于背景图pixels获取
+ (AVSDKCGFrameBuffer *)getBgCoverImgFrameBufferWithCurrentImg:(UIImage *)currentImg newImgSize:(CGSize)newImgSize {
    float currentImgWidth = newImgSize.width;
    float widthRatio = currentImgWidth / currentImg.size.width;
    float currentImgHeight = currentImg.size.height *widthRatio;
    //[firstImage drawInRect:CGRectMake(0, bgCoverPoint.y, firstImageWidth, firstImgHeight)];
    AVSDKCGFrameBuffer *frameBuffer = [[AVSDKCGFrameBuffer alloc]initWithBppDimensions:24 width:currentImgWidth height:currentImgHeight];
    CGImageRef cgImgRef = currentImg.CGImage;
    [frameBuffer renderCGImage:cgImgRef];
    
    return frameBuffer;
}


// TODO: 两张图片合成一张图片
+ (UIImage*)imageByCombiningImageNewImgSize:(CGSize)newImgSize firstImage:(UIImage*)firstImage withImage:(UIImage*)secondImage bgCoverPoint:(CGPoint)bgCoverPoint {
    UIImage *image = nil;
    
    CGSize newImageSize = newImgSize;
    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    
    float screenHeightScle = [UIScreen mainScreen].bounds.size.height/667.0; //7屏幕适配高度比例系数
    float firstImageWidth = newImgSize.width;
    float widthRatio = firstImageWidth / firstImage.size.width;
    float firstImgHeight = firstImage.size.height *widthRatio;
    
    //[firstImage drawInRect:CGRectMake( 50 + (newImgSize.width-firstImage.size.width)/2.0, -100, firstImage.size.width,firstImage.size.height)];
    [firstImage drawInRect:CGRectMake(0, bgCoverPoint.y, firstImageWidth, firstImgHeight)];
    [secondImage drawInRect:CGRectMake(0, 0, newImgSize.width, newImgSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // 图片尺寸过大时处理
    //image = [self pressNewImgWithImg:image];
    //image = [self resetSizeOfImageData:image maxSize:50];
    
    return image;
}


#pragma mark - 单张图片生成视频
+ (AVSDKAlphaImgMakeVideo *)singlaImgToGenerateMOVWithNumFrames:(int)numFrames VideoSize:(CGSize)videoSize frameTime:(CMTime)frameTime exportVideoPath:(NSString *)exportVideoPath {
    
    int videoWidth = videoSize.width;
    int videoHeight = videoSize.height;
    while ( videoWidth % 16 != 0) {
        videoWidth = videoWidth - 1;
    }
    
    // 使用CEMovieMake实现视频生成
    if (@available(iOS 11.0, *)) {
        NSDictionary *settings = [AVSDKAlphaImgMakeVideo videoSettingsWithCodec:AVVideoCodecTypeH264 withWidth:videoWidth andHeight:videoHeight];
        AVSDKAlphaImgMakeVideo *movieMaker = [[AVSDKAlphaImgMakeVideo alloc] initWithSettings:settings exportVideoPath:exportVideoPath];
        Float64 seconds = frameTime.value/frameTime.timescale;
        int32_t timescale = numFrames/seconds;
        movieMaker.frameTime = CMTimeMake(1,timescale); // mean:1秒钟多少帧<==>1秒钟25帧
        
        // init singla image
        [movieMaker createMovieInitProperty];
        return movieMaker;
    } else {
        // Fallback on earlier versions
    }
    return nil;
}


/*
#pragma mark - 所有图片整合图片生成 视频
+ (void)imagesToGenerateMOVWith:(NSMutableArray *)imgs videoSize:(CGSize)videoSize frameTime:(CMTime)frameTime writefinish:(void(^)(NSURL *fileURL))writeFinish {
    
    int videoWidth = videoSize.width;
    int videoHeight = videoSize.height;
    while ( videoWidth % 16 != 0) {
        videoWidth = videoWidth - 1;
    }
    
    // 使用CEMovieMake实现视频生成
    if (@available(iOS 11.0, *)) {
        NSDictionary *settings = [AVSDKAlphaImgMakeVideo videoSettingsWithCodec:AVVideoCodecTypeH264 withWidth:videoWidth andHeight:videoHeight];
        AVSDKAlphaImgMakeVideo *movieMaker = [[AVSDKAlphaImgMakeVideo alloc] initWithSettings:settings];
        Float64 seconds = frameTime.value/frameTime.timescale;
        int32_t timescale = imgs.count/seconds;
        movieMaker.frameTime = CMTimeMake(1,timescale); // mean:1秒钟多少帧<==>1秒钟25帧
        
        [movieMaker createMovieFromImages:imgs withCompletion:^(NSURL *fileURL){
            writeFinish(fileURL);
        }];
    } else {
        // Fallback on earlier versions
    }
}
*/



/*
#pragma mark - 图片压缩算法 - 未使用
// 1. image压缩算法 使用压缩算法对图片进行相应的压缩处理
+ (UIImage *)pressNewImgWithImg:(UIImage *)currentImg {
    NSData *currentImgData = [NSData dataWithData:UIImagePNGRepresentation(currentImg)];
    NSUInteger imgSize = currentImgData.length;
    // 如果当前size>50KB
    while(imgSize/1000 > 55 ) {
        float pressRatio = 55.0/(imgSize/1000);
        NSData *tmpImgData = UIImageJPEGRepresentation(currentImg, pressRatio);
        currentImg = [UIImage imageWithData:tmpImgData];
        imgSize = tmpImgData.length;
    }
    return currentImg;
}

// 2. image压缩算法
+ (UIImage *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize {
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        UIImage *img = [UIImage imageWithData:finallImageData];
        return img;
    }
    
    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024/sourceImageAspectRatio);
    UIImage *newImage = [self newSizeImage:defaultSize image:sourceImage];
    
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    //
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    UIImage *img = [UIImage imageWithData:finallImageData];
    return img;
}
#pragma mark 调整图片分辨率/尺寸（等比例缩放）
+ (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark 二分法
+ (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        //NSLog(@"当前降到的质量：%ld KB", (unsigned long)sizeOriginKB);
        //NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}

*/






@end

