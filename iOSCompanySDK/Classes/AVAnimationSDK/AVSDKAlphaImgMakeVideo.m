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
        
        _assetWriter = [[AVAssetWriter alloc] initWithURL:self.fileURL
                                                 fileType:AVFileTypeQuickTimeMovie error:&error];
        if (error) {
            NSLog(@"Error: %@", error.debugDescription);
        }
        NSParameterAssert(self.assetWriter);
        
        _videoSettings = videoSettings;
        _writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                          outputSettings:videoSettings];
        NSParameterAssert(self.writerInput);
        NSParameterAssert([self.assetWriter canAddInput:self.writerInput]);
        
        [self.assetWriter addInput:self.writerInput];
        
        NSDictionary *bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
        
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
                    CFRelease(sampleBuffer);
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
//
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
    
    // FIXME: 此处有修改，测试导出的透明视频
    // rgb色值
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB(); // 输出像素被视为隐式sRGB
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 4 * frameWidth,
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    // alpha 色值
//    CGColorSpaceRef alphaColorSpace = CGColorSpaceCreateDeviceGray();
//    CGContextRef context = CGBitmapContextCreate(pxdata,
//                                                 frameWidth,
//                                                 frameHeight,
//                                                 8,
//                                                 4 * frameWidth,
//                                                 alphaColorSpace,
//                                                 (CGBitmapInfo)kCGImageAlphaOnly);
    
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



@end


