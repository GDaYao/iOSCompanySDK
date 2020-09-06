////  AVSDKAlphaImgMakeVideo.m
//  iOSCompanySDK
//
//  Created on 2020/9/3.
//  
//

#import "AVSDKAlphaImgMakeVideo.h"


@implementation AVSDKAlphaImgMakeVideo

+ (NSDictionary *)videoSettingsWithCodec:(NSString *)codec withWidth:(CGFloat)width andHeight:(CGFloat)height
{

    
    if ((int)width % 16 != 0 ) {
        NSLog(@"Warning: video settings width must be divisible by 16.");
    }
    NSDictionary *videoSettings = @{AVVideoCodecKey : AVVideoCodecTypeH264,
                                    AVVideoWidthKey : [NSNumber numberWithInt:(int)width],
                                    AVVideoHeightKey : [NSNumber numberWithInt:(int)height]};
    
    return videoSettings;
}


#pragma mark - init with setting
- (instancetype)initWithSettings:(NSDictionary *)videoSettings exportVideoPath:(NSString *)exportVideoPath
{
    self = [self init];
    if (self) {
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths firstObject];
        //NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/export.mov"];
        
        if (exportVideoPath.length != 0 ) {
            _fileURL = [NSURL fileURLWithPath:exportVideoPath];

        }else{
            
            NSString *tempPath = [documentsDirectory stringByAppendingFormat:@"/export.mp4"];
            NSLog(@"log-movieSavePath:%@",tempPath);
            if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
                [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error];
                if (error) {
                    NSLog(@"Error: %@", error.debugDescription);
                }
            }
            _fileURL = [NSURL fileURLWithPath:tempPath];
        }
        // AVFileTypeMPEG4  AVFileTypeQuickTimeMovie
        _assetWriter = [[AVAssetWriter alloc] initWithURL:self.fileURL
                                                 fileType:AVFileTypeMPEG4 error:&error];
        if (error) {
            NSLog(@"Error: %@", error.debugDescription);
        }
        NSParameterAssert(self.assetWriter);
        
        _videoSettings = videoSettings;
        _writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                          outputSettings:videoSettings];
        NSParameterAssert(self.writerInput);
        NSParameterAssert([self.assetWriter canAddInput:self.writerInput]);
        
        // 添加图片
        [self.assetWriter addInput:self.writerInput];
        // TODO: 添加音频轨道
        
        // 像素格式类型kCVPixelBufferPixelFormatTypeKey/pixelFormatType,需设置成kCVPixelFormatType_32BGRA,不能使用kCVPixelFormatType_32ARGB。
        // 此主要和appendPixelBuffer中传入buffer-bitmapInfo对应，表示像素格式类型，位图像素分布
        NSDictionary *bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                                           nil];
        
        _bufferAdapter = [[AVAssetWriterInputPixelBufferAdaptor alloc] initWithAssetWriterInput:self.writerInput sourcePixelBufferAttributes:bufferAttributes];
        // default frame time -- CMTime
        _frameTime = CMTimeMake(1, 60);
    }
    return self;
}


#pragma mark - creat method

// 使用图片处理
- (void) createMovieFromImages:(NSArray AVSDK_GENERIC_IMAGE *)images withCompletion:(avsdkAlphaImgMakeVideoCompletionBlock)completion;
{
    [self createMovieFromSource:images withCompletion:completion];
}

// 传入images数组处理所有图片导出数组。
- (void) createMovieFromSource:(NSArray *)images withCompletion:(avsdkAlphaImgMakeVideoCompletionBlock)completion
{
    self.makeCompletionBlock = completion;
    
    [self.assetWriter startWriting];
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    
    __block NSInteger i = 0;
    
    NSInteger frameNumber = [images count];
    
    [self.writerInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^{
        while (YES){
            if (i >= frameNumber) {
                break;
            }
            if ([self.writerInput isReadyForMoreMediaData]) {
                
                CVPixelBufferRef sampleBuffer;
                @autoreleasepool {
                    NSLog(@"log-export index:%d",i);
                    
                    //UIImage* img = extractor([images objectAtIndex:i]);
                    UIImage *img = (UIImage *)[images objectAtIndex:i];
                    if (img == nil) {
                        i++;
                        NSLog(@"Warning: could not extract one of the frames");
                        continue;
                    }
                    sampleBuffer = [self newPixelBufferFromCGImage:[img CGImage]];
                }
                if (sampleBuffer) {
                    if (i == 0) {
                        [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:kCMTimeZero];
                    }else{
                        CMTime lastTime = CMTimeMake(i-1, self.frameTime.timescale);
                        CMTime presentTime = CMTimeAdd(lastTime, self.frameTime);
                        if ( CMTIME_IS_NUMERIC(presentTime) ) {
                            [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:presentTime];
                        }
                    }
                    //CFRelease(sampleBuffer);
                    i++;
                }
            }
        }
        
        [self.writerInput markAsFinished];
        [self.assetWriter finishWritingWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.makeCompletionBlock(self.fileURL);
            });
        }];
        
        CVPixelBufferPoolRelease(self.bufferAdapter.pixelBufferPool);
    }];
}

#pragma mark - 单个图片导入处理
// 初始化各参数
- (void)createMovieInitProperty {
    
    [self.assetWriter startWriting];
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    
}

// 3. use pixels array ==> CVPixelsBufferRef ==>
- (void)usePixelsArrayWithPixelWidth:(size_t)pixelWidth pixelHeight:(size_t)pixelHeight pixelNum:(NSUInteger)pixelsNum charPixels:(char*[])pixels completion:(avsdkAlphaImgMakeVideoCompletionBlock)makeCompletionBlock
{
    
    self.pixelWidth = pixelWidth;
    self.pixelHeight = pixelHeight;
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    
    __block NSInteger i = 0;
    
    NSInteger frameNumber = pixelsNum;
    
    [self.writerInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^{
        while (YES){
            if (i >= frameNumber) {
                break;
            }
            if ([self.writerInput isReadyForMoreMediaData]) {
                
//                @autoreleasepool {
                    CVPixelBufferRef sampleBuffer  = [self getCVPixelBufferRefFromBytesWithPixels:pixels[i] ];
                    
                    if (sampleBuffer) {
                        if (i == 0) {
                            [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:kCMTimeZero];
                        }else{
                            CMTime lastTime = CMTimeMake(i-1, self.frameTime.timescale);
                            CMTime presentTime = CMTimeAdd(lastTime, self.frameTime);
                            if ( CMTIME_IS_NUMERIC(presentTime) ) {
                                [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:presentTime];
                            }else{
                                NSLog(@"log-MakeVideo-无效时间");
                            }
                        }
                        //CFRelease(sampleBuffer);
                    } //
                    i++;
//                }
            }else{
                NSLog(@"log-MakeVideo-写入未准备好");
            }
            
        }
        
        [self.writerInput markAsFinished];
        [self.assetWriter finishWritingWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                makeCompletionBlock(self.fileURL);
            });
        }];
        
        CVPixelBufferPoolRelease(self.bufferAdapter.pixelBufferPool);
        
    }];
    
}


// 2. use sampleBuffer
/* 此处传入原始的CVPixelBufferRef可能需要处理成需要的CVPixelBufferRef,可能缺少NV12数据 */
- (void)useSamplBufferCreateMovieAppenPixelBufferWithCVPixelBufferRef:(CVPixelBufferRef)sampleBuffer imgIndex:(NSInteger)frameIndex  {
    
    if (self.mediaInputQueue == nil ) {
        self.mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    }
    
    //dispatch_async(self.mediaInputQueue, ^{
       
        // 这是一个键值观察属性，它会经常地异步地在NO和YES之间变换，来标识现在缓冲区中的数据是否已经处理完成。
        if ([self.writerInput isReadyForMoreMediaData]) {
            
            //@autoreleasepool {
            if (sampleBuffer) {
                if (frameIndex == 0) {
                    
                    // 它是一个缓冲区，作为assetWriter的输入，用于把缓冲池中的像素打包追加到视频样本上
                    // 返回结果只是代表添加pixel buffer成功，并未代表处理完成。
                    [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:kCMTimeZero];
                    
                }else{
                    CMTime lastTime = CMTimeMake(frameIndex-1, self.frameTime.timescale);
                    CMTime presentTime = CMTimeAdd(lastTime, self.frameTime);
                    if ( CMTIME_IS_NUMERIC(presentTime) ) {
                        [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:presentTime];
                    }else{
                        NSLog(@"log-MakeVideo-无效时间");
                    }
                }
            }
            //}
        }
        
        
        //根据appendPixelBuffer定义描述，使用期间不能改变CVPixelBufferRef。
        // 所以必须等待处理完成,才能释放CVPixelBufferRef。
        BOOL isReadyLoopFlag = YES;
        while(isReadyLoopFlag == YES){
            if(self.bufferAdapter.assetWriterInput.isReadyForMoreMediaData == YES){
                
                //UIImage *bgCoverImg = [UIImage imageNamed:@"tmp-1.jpg"];
                //UIImage *bgCoverImg = nil;
                //UIImageP NGRepresentation(self.bgCoverImg);
                
                // 查看当前添加的image。
                //            CVPixelBufferRef newPixelBuffer = NULL;
                //            CVPixelBufferPoolCreatePixelBuffer(NULL, self.bufferAdapter.pixelBufferPool, &newPixelBuffer);
                
#ifdef DEBUG
                //测试导入的CVPixelBufferRef==>UIImage
                if (FALSE) {
                    // 测试此pixelBuffer生成image是否正常
                    UIImage *newImg = [self imageFromRGBImageBuffer:sampleBuffer];
                    //UIImagePNGRepresentation(newImg);
                }
#endif
                
                CVPixelBufferRelease(sampleBuffer);
                isReadyLoopFlag = NO;
                break;
            }else{
                //NSLog(@"log-MakeVideo-下一帧-写入未准备好-%ld",(long)frameIndex);
            }
        } //
        
    //});
    
}


// 1. use image ==> CVPixelBufferRef
- (void)createMovieAppenPixelBufferWithImage:(UIImage *)img imgIndex:(NSInteger)i {
    if ([self.writerInput isReadyForMoreMediaData]) {
        
        CVPixelBufferRef sampleBuffer;
        @autoreleasepool {
#ifdef DEBUG
#ifdef LOGGING
            NSLog(@"log-export index:%d",i);
#endif // LOGGING
#endif
            
            //UIImage* img = extractor([images objectAtIndex:i]);
            if (img == nil) {
                //i++;
                NSLog(@"Warning: could not extract one of the frames");
                //continue;
                return;
            }
            sampleBuffer = [self newPixelBufferFromCGImage:[img CGImage]];
        }
        if (sampleBuffer) {
            if (i == 0) {
                [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:kCMTimeZero];
            }else{
                CMTime lastTime = CMTimeMake(i-1, self.frameTime.timescale);
                CMTime presentTime = CMTimeAdd(lastTime, self.frameTime);
                if ( CMTIME_IS_NUMERIC(presentTime) ) {
                    [self.bufferAdapter appendPixelBuffer:sampleBuffer withPresentationTime:presentTime];
                }
            }
            CFRelease(sampleBuffer);
            //i++;
        }
    }else{
        NSLog(@"log-MakeVideo-写入未准备好-%ld",(long)i);
    }
}

// 全部图片导入完成
- (void)createMovieFinishWithCompletion:(avsdkAlphaImgMakeVideoCompletionBlock)completion {
    self.makeCompletionBlock = completion;
    
    [self.writerInput markAsFinished];
    [self.assetWriter finishWritingWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.makeCompletionBlock(self.fileURL);
        });
    }];
    
    CVPixelBufferPoolRelease(self.bufferAdapter.pixelBufferPool);
}


#pragma mark - bytes array covert to CVPixelBufferRef
- (CVPixelBufferRef)getCVPixelBufferRefFromBytesWithPixels:(char *)pixels
{
    // 使用pixels数组直接生成需要的CVPixelBufferRef
    CVPixelBufferRef pixelBuffer = NULL;
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault, self.pixelWidth, self.pixelHeight, kCVPixelFormatType_32BGRA,pixels, 4*self.pixelWidth, NULL, NULL, NULL,&pixelBuffer);
    return pixelBuffer;
}


#pragma mark -
// *** 1. UIImage 转换为 CVPixelBufferRef(RGB)
- (CVPixelBufferRef)newPixelBufferFromCGImage:(CGImageRef)image
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = [[self.videoSettings objectForKey:AVVideoWidthKey] floatValue];
    CGFloat frameHeight = [[self.videoSettings objectForKey:AVVideoHeightKey] floatValue];
    
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    // rgb色值
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB(); // 输出像素被视为隐式sRGB
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 4 * frameWidth,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    // 这里确定绘制区域
    // 1. 使用frame * UIScreen Scale
    //CGContextDrawImage(context, CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)),image);
    // use image width*height
    CGContextDrawImage(context, CGRectMake(0,0,frameWidth,frameHeight),image);
    
    CGColorSpaceRelease(rgbColorSpace);
    
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

// 2. UIImage转为CVPixelBufferRef(YUV)
- (CVPixelBufferRef)imageToYUVPixelBuffer:(UIImage *)image {
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image.CGImage), CGImageGetHeight(image.CGImage));
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width, frameSize.height,kCVPixelFormatType_420YpCbCr8BiPlanarFullRange, (__bridge CFDictionaryRef)options,&pxbuffer);
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddressOfPlane(pxbuffer,0);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width, frameSize.height,8,CVPixelBufferGetBytesPerRowOfPlane(pxbuffer, 0),colorSpace,kCGImageAlphaNone);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image.CGImage),CGImageGetHeight(image.CGImage)), image.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}


// CVImageBufferRef (RGB)转为UIImage
- (UIImage *)imageFromRGBImageBuffer:(CVImageBufferRef)imageBuffer {
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    CGImageRelease(quartzImage);
    return (image);
}



@end


