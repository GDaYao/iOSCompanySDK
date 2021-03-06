////  AVSDKAssetFrameDecoder.m
//  iOSCompanySDK
//
//  Created on 2020/9/3.
//  
//

#import "AVSDKAssetFrameDecoder.h"

#import "AVSDKCGFrameBuffer.h"
#import "AVSDKAVFrame.h"


typedef enum
{
  // Attempted to read from asset, but data was not available, retry. Note that this
  // code could be returned in the case where a sample buffer is read a nil. The
  // caller is expected to check that status flags on the asset reader in order
  // to determine if the asset reader is finished reading frames.
  FrameReadStatusNotReady,
  
  // Read the next frame from the asset successfully
  FrameReadStatusNextFrame,
  
  // Did not read the next frame because the previous frame data is duplicated
  // as a "nop frame"
  FrameReadStatusDup,
  
  // Reading a frame was successful, but the indicated display time is so early
  // that is too early to be decoded as the "next" frame. Ignore an odd frame
  // like this and continue to decode the next frame.
  FrameReadStatusTooEarly,
  
  // Done reading frames from the asset. Note that it is possible that frames
  // could have all been read but the final frame has a long "implicit" duration.
  FrameReadStatusDone
} FrameReadStatus;

@interface AVSDKAssetFrameDecoder ()

@property (nonatomic, copy) NSURL         *assetURL;

@property (nonatomic, strong) AVAssetReader *aVAssetReader;

@property (nonatomic, strong) AVAssetReaderOutput *aVAssetReaderOutput;

@property (nonatomic,strong)AVSDKCGFrameBuffer *currentFrameBuffer;

@property (nonatomic,strong) AVSDKAVFrame *lastFrame;

@end


@implementation AVSDKAssetFrameDecoder

@synthesize assetURL = m_assetURL;

@synthesize aVAssetReader = m_aVAssetReader;

@synthesize aVAssetReaderOutput = m_aVAssetReaderOutput;

@synthesize currentFrameBuffer = m_currentFrameBuffer;

@synthesize lastFrame = m_lastFrame;

@synthesize produceCoreVideoPixelBuffers = m_produceCoreVideoPixelBuffers;

@synthesize produceYUV420Buffers = m_produceYUV420Buffers;

@synthesize dropFrames = m_dropFrames;


#pragma mark - class init
+ (AVSDKAssetFrameDecoder *)aVSDKAssetFrameDecoder {
    AVSDKAssetFrameDecoder *obj = [[AVSDKAssetFrameDecoder alloc]init];
    obj->frameIndex = -1; // 使用指针指向操作，点语法在private修饰时，失效。
    obj.dropFrames = YES;
    return obj;
}

#pragma mark - 判断当前src文件是否可以被读取 | 并进行读取赋值
- (BOOL) openForReading:(NSString*)assetPath {
    BOOL worked;
    
    if (self->m_isOpen) {
        return FALSE;
    }
    
    NSAssert(self.aVAssetReader == nil, @"aVAssetReader must be nil");
    
    self.assetURL = [NSURL fileURLWithPath:assetPath];
    
    // 通过加载的两个资源文件解码成需要的AVAsset使用。
    worked = [self setupAsset];
    if (worked == FALSE) {
        return FALSE;
    }
    
    // Start reading as soon as asset is opened.
    NSAssert(m_isReading == FALSE, @"m_isReading");
    
    if (TRUE) {
        // Start reading from asset, this is only done when the first frame is read.
        // FIXME: it might be better to move this logic into the allocateDecodeResources method
        // 可能把这个逻辑移动到 allocateDecodeResources 方法中更好
        
        worked = [self startReadingAsset];
        if (worked == FALSE) {
            return FALSE;
        }
        
        prevFrameDisplayTime = 0.0;
        
        m_isReading = TRUE;
    }
    
    self->m_isOpen = TRUE;
    self->m_readingFinished = FALSE;
    return TRUE;
}


#pragma mark - 打开和准备解码视频帧 -- 存储定义某些属性
// This utility method will setup the asset so that it is opened and ready
// to decode frames of video data.
- (BOOL) setupAsset
{
    NSAssert(self.assetURL, @"assetURL");
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                        forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    AVURLAsset *avUrlAsset = [[AVURLAsset alloc] initWithURL:self.assetURL options:options];
//#if __has_feature(objc_arc)
//#else
//    avUrlAsset = [avUrlAsset autorelease];
//#endif // objc_arc
    NSAssert(avUrlAsset, @"AVURLAsset");
    
    // FIXME: return false error code if something goes wrong
    
    // Check for DRM protected content
    
    if (avUrlAsset.hasProtectedContent) {
        NSAssert(FALSE, @"DRM");
    }
    
    if ([avUrlAsset tracks] == 0) {
        NSAssert(FALSE, @"not tracks");
    }
    
    NSError *assetError = nil;
    self.aVAssetReader = [AVAssetReader assetReaderWithAsset:avUrlAsset error:&assetError];
    
    NSAssert(self.aVAssetReader, @"aVAssetReader");
    
    if (assetError) {
        NSAssert(FALSE, @"AVAssetReader");
    }
    
    // This video setting indicates that native 32 bit endian pixels with a leading
    // ignored alpha channel will be emitted by the decoding process.
    
    NSDictionary *videoSettings;
    
    if (self.produceYUV420Buffers == FALSE) {
        videoSettings = [NSDictionary dictionaryWithObject:
                         [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    } else {
        // YYYY (plane 0)
        // UV   (plane 1)
        
        videoSettings = [NSDictionary dictionaryWithObject:
                         [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    }
    
    NSArray *videoTracks = [avUrlAsset tracksWithMediaType:AVMediaTypeVideo];
    
    NSAssert([videoTracks count] == 1, @"only 1 video track can be decoded");
    
    AVAssetTrack *videoTrack = [videoTracks objectAtIndex:0];
    
#ifdef DEBUG
#ifdef LOGGING
    NSArray *availableMetadataFormats = videoTrack.availableMetadataFormats;
    NSLog(@"availableMetadataFormats %@", availableMetadataFormats);
#endif // LOGGING
#endif
    
    // track must be self contained
    
    NSAssert(videoTrack.isSelfContained, @"isSelfContained");
    
    // Query the width x height of the track now, otherwise this info would
    // not be available until the first frame is decoded. But, that would
    // be too late since it would mean we could not allocate an output
    // buffer of a known width and height until the first frame had been
    // decoded.
    
    CGSize naturalSize = videoTrack.naturalSize;
    
#ifdef DEBUG
#ifdef LOGGING
    float naturalWidth = naturalSize.width;
    float naturalHeight = naturalSize.height;
    NSLog(@"video track naturalSize w x h : %d x %d", (int)naturalWidth, (int)naturalHeight);
#endif // LOGGING
#endif
    
    detectedMovieSize = naturalSize;
    
    // playback framerate
    
    CMTimeRange timeRange = videoTrack.timeRange;
    
    float duration = (float)CMTimeGetSeconds(timeRange.duration);
    
    float nominalFrameRate = videoTrack.nominalFrameRate;
    
    CMTime minFrameDuration = videoTrack.minFrameDuration;
    
    // 获得帧速率
    self.frameTime = CMTimeMakeWithSeconds(duration, timeRange.duration.timescale);
    
    float frameDuration;
    
    if (self.dropFrames == TRUE) {
        // The default setting of dropFrames = TRUE means that some frames
        // could have been encodec out of order, calculate an estimated
        // number of frames from nominalFrameRate.
        
        frameDuration = 1.0 / nominalFrameRate;
    } else {
        if (CMTIME_IS_INVALID(minFrameDuration)) {
            frameDuration = 1.0 / nominalFrameRate;
        } else {
            // When self.dropFrames is set to FALSE then assume a frame duration
            // that is consistent and calculate the number of frames based on
            // the time divided into even duration intervals.
            
            frameDuration = CMTimeGetSeconds(minFrameDuration);
            nominalFrameRate = 1.0 / frameDuration;
        }
    }
    
    self->m_frameDuration = (NSTimeInterval)frameDuration;
    
    float numFramesFloat = duration / frameDuration;
    int numFrames = round( numFramesFloat );
    float durationForNumFrames = numFrames * frameDuration;
    float durationRemainder = duration - durationForNumFrames;
    float durationTenPercent = frameDuration * 0.10;
   
#ifdef DEBUG
#ifdef LOGGING
    NSLog(@"frame rate = %0.2f FPS", nominalFrameRate);  // 1秒钟25帧
    NSLog(@"frame duration = %0.4f FPS", frameDuration);
    NSLog(@"duration = %0.2f S", duration);
    NSLog(@"numFrames = %0.4f -> %d", numFramesFloat, numFrames);
    NSLog(@"durationRemainder = %0.4f", durationRemainder);
    NSLog(@"durationTenPercent = %0.4f", durationTenPercent);
#endif // LOGGING
#endif
    
    if (durationRemainder >= durationTenPercent) {
        NSLog(@"durationRemainder is larger than durationTenPercent");
        numFrames += 1;
    }
    
    self->m_numFrames = numFrames;
    
    AVAssetReaderTrackOutput *aVAssetReaderOutput = [[AVAssetReaderTrackOutput alloc]
                                                     initWithTrack:videoTrack outputSettings:videoSettings];
//#if __has_feature(objc_arc)
//#else
//    aVAssetReaderOutput = [aVAssetReaderOutput autorelease];
//#endif // objc_arc
    
    NSAssert(aVAssetReaderOutput, @"AVAssetReaderVideoCompositionOutput failed");
    
    // Optimize CoreVideo buffer usage by indicating that a framebuffer copy is not needed and that the
    // generated framebuffer will be treated as a readonly buffer. This reduces the mediaserverd CPU usage
    // from 30% to 20% on an iPad 2.
    
    aVAssetReaderOutput.alwaysCopiesSampleData = FALSE;
    
    // FIXME: If a frame decoder should decode only for a specific interval (segmented ranges)
    // then the following property could be used to limit the decoded frames range to a specific
    // set of frames.
    //
    //aVAssetReaderOutput.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(mSeekFrame / mFPS, 1), kCMTimePositiveInfinity);
    
    // Read video data from the inidicated tracks of video data
    
    [self.aVAssetReader addOutput:aVAssetReaderOutput];
    
    self.aVAssetReaderOutput = aVAssetReaderOutput;
    
    
    return TRUE;
}


// 把给定的2个资源文件转换为AVAsset后，此方法负责判断是否可读取。
- (BOOL) startReadingAsset
{
    BOOL worked;
    AVAssetReader *aVAssetReader = self.aVAssetReader;
    NSAssert(aVAssetReader, @"aVAssetReader");
    
    worked = [aVAssetReader startReading];
    
    if (worked == FALSE) {
        AVAssetReaderStatus status = aVAssetReader.status;
        NSError *error = aVAssetReader.error;
        
        NSLog(@"status = %d", (int)status);
        NSLog(@"error = %@", [error description]);
        
        return FALSE;
    } else {
        return TRUE;
    }
}

// 重启解码器，资产读取似乎想要读取数据一次。 -- 播放完毕，即销毁。
- (BOOL) restart
{
#ifdef LOGGING
    NSLog(@"restart");
#endif // LOGGING
    
    [self close];
    
    BOOL worked;
    
    worked = [self openForReading:[self.assetURL path]];
    
    if (worked == FALSE) {
        return FALSE;
    }
    
    return TRUE;
}

- (void) close
{
    AVAssetReader *aVAssetReader = self.aVAssetReader;
    // Note that this aVAssetReader can be nil
    [aVAssetReader cancelReading];
    self.aVAssetReaderOutput = nil;
    self.aVAssetReader = nil;
    
    self->frameIndex = -1;
    self.currentFrameBuffer = nil;
    self.lastFrame = nil;
    
    self->m_isOpen = FALSE;
    self->m_isReading = FALSE;
    self->m_readingFinished = TRUE;
    
    return;
}

- (void) rewind
{
    if (!self->m_isOpen) {
        return;
    }
    
    self->frameIndex = -1;
    self.currentFrameBuffer = nil;
    self.lastFrame = nil;
    
    [self restart];
}


/*
//#pragma mark - 获取帧图片+得到帧pixels
- (AVSDKAVFrame *)getPixelsFromEachFrame:(NSUInteger)newFrameIndex {
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
//    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    [gen generateCGImagesAsynchronouslyForTimes:nil completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
//    }];
//    [asset release];
//    gen.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 600); // 使用CMTime获取
//    NSError *error = nil;
//    CMTime actualTime;
//    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    UIImage *img = [[[UIImage alloc] initWithCGImage:image] autorelease];
//    CGImageRelease(image);
//    [gen release];
//    return img;
    return nil;
}

*/


#pragma mark - index 每一帧
- (AVSDKAVFrame *)advanceToFrame:(NSUInteger)newFrameIndex {
    
#ifdef LOGGING
    NSLog(@"advanceToFrame : from %d to %d", (int)frameIndex, (int)newFrameIndex);
#endif // LOGGING
    
    // Check for case of restarting the decoder after it decoded all frames (looping)
    // 检查所有帧,解码后重新启动解码器的情况（循环）
#ifdef LOGGING
    AVAssetReaderStatus status = self.aVAssetReader.status;
    switch (status) {
        case AVAssetReaderStatusUnknown:
            NSLog(@"AVAssetReaderStatusUnknown");
            break;
        case AVAssetReaderStatusReading:
            NSLog(@"AVAssetReaderStatusReading");
            break;
        case AVAssetReaderStatusCompleted:
            NSLog(@"AVAssetReaderStatusCompleted");
            break;
        case AVAssetReaderStatusFailed:
            NSLog(@"AVAssetReaderStatusFailed");
            break;
        case AVAssetReaderStatusCancelled:
            NSLog(@"AVAssetReaderStatusCancelled");
            break;
        default:
            break;
    }
#endif // LOGGING
    
    
#ifdef LOGGING
    NSLog(@"testing restart condition, frameIndex %d, readingFinished %d", frameIndex, m_readingFinished);
#endif // LOGGING
    
    //if ((status == AVAssetReaderStatusCompleted) && (frameIndex == -1))
    
    if ((frameIndex == -1) && self->m_readingFinished) {
        // Previous round of decoding got to the end of the asset, it should be
        // possible to start asset decoding over now.
        
#ifdef LOGGING
        NSLog(@"RESTART condition when reading was finished found with frameIndex %d", (int)self.frameIndex);
#endif // LOGGING
        
        // Query the asset reader object again because it could have been changed
        // by a restart above.
        [self restart];
    }
    
    // aVAssetReader -- 在setUpAsset中已读取完成。
    AVAssetReader *aVAssetReader = self.aVAssetReader;
    NSAssert(aVAssetReader, @"asset should be open already");
    
    NSAssert(m_isReading == TRUE, @"asset should be reading already");
    
    //  NSLog(@"advanceToFrame : current %d, new %d", (frameIndex + 1), newFrameIndex);
    
    // Examine the frame number we should advance to. Currently, the implementation
    // is limited to advancing to the next frame only.
    // 兼容判断各帧情况
    if ((frameIndex != -1) && (newFrameIndex == frameIndex)) {
        NSAssert(FALSE, @"cannot advance to same frame");
    } else if ((frameIndex != -1) && (newFrameIndex < frameIndex)) {
        // movie frame index can only go forward via advanceToFrame
        // 视频帧索引只能通过advanceToFrame前进
        NSAssert(FALSE, @"%@: %d -> %d",
                 @"can't advance to frame before current frameIndex",
                 frameIndex,
                 (int)newFrameIndex);
    }
    
    // 跳过头部的帧
    BOOL skippingAhead = (frameIndex + 1) < newFrameIndex;
    int skippingOverNumFrames = (int)(newFrameIndex - (frameIndex + 1));
    if (skippingAhead) {
#ifdef LOGGING
        NSLog(@"skipping ahead : current %d, new %d, skip %d", (int)(frameIndex + 1), (int)newFrameIndex, (int)skippingOverNumFrames);
#endif
    }
    
    // Make sure we do not advance past the last frame
    // 确保我们不超过最后一帧
    
    int numFrames = (int) [self numFrames];
    
    if (newFrameIndex >= numFrames) {
        NSAssert(FALSE, @"%@: %d", @"can't advance past last frame", (int)newFrameIndex);
    }
    
    // Decode the frame into a framebuffer. -- 解码帧图像到frameBuffer中。
    
    BOOL changeFrameData = FALSE;
    //BOOL writeFailed = FALSE;
    BOOL doneReadingFrames = FALSE;
    
    //const int newFrameIndexSigned = (int) newFrameIndex;
    
    //     Note that this asset frame decoder assumes that only one framebuffer
    //     will be in use at any one time, so this logic always drops the ref
    //     to the previous frame object which should drop the ref to the image.
    //     Also note that this logic does not drop a ref to a cvBuffer ref
    //     because it is possible that the optimized execution path could
    //     result in an OpenGL renderer that is holding on to a texture
    //     via the cvBufferRef.
    /*
     请注意，此资产帧解码器假定在任何时候都只使用一个帧缓冲区，因此此逻辑始终将ref丢弃到前一帧对象，而前一帧对象应将ref丢弃到图像。
     另请注意，此逻辑不会将ref丢弃到cvBuffer ref，因为优化的执行路径可能会导致OpenGL渲染器通过cvBufferRef保留纹理。
     */
    
    self.lastFrame.image = nil;
    self.lastFrame.cgFrameBuffer = nil;
    //self.lastFrame.cvBufferRef = NULL;
    self.lastFrame = nil;
    
    // This framebuffer object will be the destination of a render operation
    // for a given frame. Multiple frames must always be the same size,
    // so a common render buffer will be allocated.
    // 该帧缓冲区对象将成为给定帧的渲染操作的目标,多个帧必须总是设定为同一尺寸，所以普通的渲染缓冲区将被释放。
    
    
    AVSDKCGFrameBuffer *frameBuffer;
    CVImageBufferRef cvBufferRef = NULL; // 将会存储一帧图下所有像素值。
    
    if (self.produceCoreVideoPixelBuffers) {
        frameBuffer = nil;
    } else {
        frameBuffer = self.currentFrameBuffer;
    }
    
    // 图像缓冲区
    CVImageBufferRef skipAheadLastGoodBufferRef = NULL;
    // while 循环判断是否读取到帧，并未多多次循环
    while (doneReadingFrames == FALSE) @autoreleasepool {
        FrameReadStatus frameReadStatus;
        
        if (cvBufferRef) {
            // Previous loop returned a buffer ref, release it before decoding the next one
            CFRelease(cvBufferRef);
            cvBufferRef = NULL;
        }
        frameReadStatus = [self blockingDecodeReadFrame:&frameBuffer cvBufferRefPtr:&cvBufferRef];
        
        if (frameReadStatus == FrameReadStatusNextFrame) {
            // Read the next frame of data, return as
            
#ifdef LOGGING
            NSLog(@"FrameReadStatusNextFrame");
#endif // LOGGING
            
            if (self.produceCoreVideoPixelBuffers) {
                NSAssert(cvBufferRef, @"cvBufferRef must be returned with FrameReadStatusNextFrame status");
            }
            
            frameIndex++;
            changeFrameData = TRUE;
            doneReadingFrames = TRUE;
            
            if (skippingAhead) {
                // Skipping over frames means that the frame is decoded but then we
                // ignore it. The asset frame decoder does not provide a way to advance
                // to a specific time, so this kind of hackey way to skip ahead is
                // required.
                
#ifdef LOGGING
                NSLog(@"skip over frame condition found for frame %d", frameIndex);
#endif // LOGGING
                
                // A really weird case comes up with skip ahead where the decoder tries to
                // skip ahead but then the last frame comes back as done. In this edge case
                // the decoder needs to hold on to the previous buffer in case skipping
                // ahead returns done.
                
                if (skipAheadLastGoodBufferRef) {
                    CFRelease(skipAheadLastGoodBufferRef);
                    skipAheadLastGoodBufferRef = NULL;
                }
                if (skippingAhead) {
                    skipAheadLastGoodBufferRef = cvBufferRef;
                    if (skipAheadLastGoodBufferRef) {
                        CFRetain(skipAheadLastGoodBufferRef);
                    }
                }
                
                doneReadingFrames = FALSE;
                
                skippingOverNumFrames -= 1;
                if (skippingOverNumFrames == 0) {
                    skippingAhead = FALSE;
                }
            }
        } else if (frameReadStatus == FrameReadStatusDup) {
#ifdef LOGGING
            NSLog(@"FrameReadStatusDup");
#endif // LOGGING
            
            frameIndex++;
            changeFrameData = FALSE;
            doneReadingFrames = TRUE;
        } else if (frameReadStatus == FrameReadStatusTooEarly) {
            // Skip writing of frame that would be displayed too early
            
#ifdef LOGGING
            NSLog(@"FrameReadStatusTooEarly");
#endif // LOGGING
        } else if (frameReadStatus == FrameReadStatusNotReady) {
            // Input was not ready at this point, continue to read
            
#ifdef LOGGING
            NSLog(@"FrameReadStatusNotReady");
#endif // LOGGING
        } else if (frameReadStatus == FrameReadStatusDone) {
            // Reader has returned a status code indicating that no more
            // frames are available.
#ifdef LOGGING
            NSLog(@"FrameReadStatusDone");
#endif // LOGGING
            
            doneReadingFrames = TRUE;
            m_readingFinished = TRUE;
            
#ifdef LOGGING
            NSLog(@"done status : %p : %p", skipAheadLastGoodBufferRef, cvBufferRef);
#endif // LOGGING
            
            if (skipAheadLastGoodBufferRef && (cvBufferRef == nil)) {
                // Skipped over a frame, but then the next frame returned DONE
                cvBufferRef = skipAheadLastGoodBufferRef;
                skipAheadLastGoodBufferRef = NULL;
            }
        } else {
            NSAssert(FALSE, @"unmatched frame status %d", frameReadStatus);
        }
    } // while-loop
    
    if (m_readingFinished == FALSE) {
        NSAssert(frameIndex == newFrameIndex, @"frameIndex != newFrameIndex, %d != %d", frameIndex, (int)newFrameIndex);
    }
    
    if ((m_readingFinished == FALSE) && (newFrameIndex == (numFrames - 1))) {
#ifdef LOGGING
        NSLog(@"advanced normally to last frame %d", (numFrames - 1));
#endif // LOGGING
        
        self->m_readingFinished = TRUE;
    }
    
    if (skipAheadLastGoodBufferRef) {
#ifdef LOGGING
        NSLog(@"cleaned up skipAheadLastGoodBufferRef from skip ahead case");
#endif // LOGGING
        
        CFRelease(skipAheadLastGoodBufferRef);
        skipAheadLastGoodBufferRef = NULL;
    }
    
    // Note that we do not release the frameBuffer because it is held as
    // the self.currentFrameBuffer property
    
    AVSDKAVFrame *retFrame = nil;
    
    if (!changeFrameData) {
#ifdef LOGGING
        NSLog(@"no change in frame data");
#endif // LOGGING
        
        // When no change from previous frame is found, return a new AVFrame object
        // but make sure to return the same image object as was returned in the last frame.
        
        retFrame = [AVSDKAVFrame avsdkAVFrame];
        NSAssert(retFrame, @"AVFrame is nil");
        
        // The image from the previous rendered frame is returned. Note that it is possible
        // that memory resources could not be mapped and in that case the previous frame
        // could be nil. Return either the last image or nil in this case.
        
        if (self.produceCoreVideoPixelBuffers) {
            // In the case of a duplicate frame in the optimized path, report the dup with
            // an AVFrame object but there is no ref to a CoreVideo path. The optimal path
            // should simply return instead of rendering into the view in this case so that
            // the previous contents of the view would continue to be shown.
        } else {
            // Copy image and cgFrameBuffer from prev frame
            id lastFrameImage = self.lastFrame.image;
            retFrame.image = lastFrameImage;
            
            AVSDKCGFrameBuffer *cgFrameBuffer = self.currentFrameBuffer;
            retFrame.cgFrameBuffer = cgFrameBuffer;
        }
        
        retFrame.isDuplicate = TRUE;
    } else {
#ifdef LOGGING
        NSLog(@"change in frame data, sending updated AVFame");
#endif // LOGGING
        
        // Delete ref to previous frame to be sure that image ref to framebuffer
        // is dropped before a new one is created.
        
        self.lastFrame = nil;
        
        retFrame = [AVSDKAVFrame avsdkAVFrame];
        NSAssert(retFrame, @"AVFrame is nil");
        
        if (self.produceCoreVideoPixelBuffers) {
            NSAssert(cvBufferRef, @"cvBufferRef is NULL");
            retFrame.cvBufferRef = cvBufferRef;
        } else {
            // Return a CGImage wrapped in a AVFrame
            AVSDKCGFrameBuffer *cgFrameBuffer = self.currentFrameBuffer;
            retFrame.cgFrameBuffer = cgFrameBuffer;
            // TODO: 使用AVFrame，传入frame buffer，转成UIImage -- 已关闭UIImage生成
#ifdef DEBUG
//            [retFrame makeImageFromFramebuffer];
#endif
        }
        
        self.lastFrame = retFrame;
    }
    
    if (cvBufferRef) {
        CFRelease(cvBufferRef);
    }
    
    // It should not be possible for both cgFrameBuffer and cvBufferRef to be nil
    
    if (retFrame.isDuplicate == FALSE) {
        if ((retFrame.cgFrameBuffer == nil) && (retFrame.cvBufferRef == NULL)) {
            NSAssert(FALSE, @"both buffer refs are nil");
        }
    }
    
    return retFrame;
}


#pragma mark 读取下一帧缓冲区SamleBuffer和状态码，去表示发生了什么。 invoke -2
// Attempt to read next frame and return a status code to inidcate what
// happened.
- (FrameReadStatus)blockingDecodeReadFrame:(AVSDKCGFrameBuffer**)frameBufferPtr
                             cvBufferRefPtr:(CVImageBufferRef*)cvBufferRefPtr
{
    BOOL worked;
    
    AVAssetReader *aVAssetReader = self.aVAssetReader;
    
    //  AVAssetReaderStatus status = aVAssetReader.status;
    //
    //  if ((status == AVAssetReaderStatusCompleted) && (frameIndex == -1)) {
    //    // Previous round of decoding got to the end of the asset, it should be
    //    // possible to start asset decoding over now.
    //
    //#ifdef LOGGING
    //    NSLog(@"RESTART condition found with frameIndex %d", self.frameIndex);
    //#endif // LOGGING
    //
    //    [self restart];
    //  }
    
    float frameDurationTooEarly = (self.frameDuration * 0.90);
    
    int frameNum = (int)self.frameIndex + 1;
    
#ifdef LOGGING
    NSLog(@"READING frame %d", frameNum);
#endif // LOGGING
    
    // This logic supports "reading" nop frames that appear after an actual frame.
    
    if (numTrailingNopFrames) {
        numTrailingNopFrames--;
        return FrameReadStatusDup;
    }
    
    // This logic used to be stop the frame reading loop as soon as the asset
    // was no longer in a reading state. Commented out because it no longer
    // appears to be needed, but left here just in case.
    
    //if ([aVAssetReader status] != AVAssetReaderStatusReading) {
    //  return FrameReadStatusDone;
    //}
    
    CMSampleBufferRef sampleBuffer = NULL;
    // TODO: 同步复制下一个样本缓冲区 ，此处"是否" 可以替换成同时使用rgb+alpha复制，加快效率
    sampleBuffer = [self.aVAssetReaderOutput copyNextSampleBuffer];
    // buffer 帧数据存在时。
    if (sampleBuffer) {
        if (self.produceCoreVideoPixelBuffers) {
            assert(cvBufferRefPtr);
            
            // Extract CoreVideo generic buffere ref (it is typically a CVPixelBufferRef)
            CVImageBufferRef imageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer);
            assert(imageBufferRef);
            // This code must retain a ref to the CVImageBufferRef (actually a CVPixelBuffer)
            // so that it can be returned to the caller.
            CFRetain(imageBufferRef);
            *cvBufferRefPtr = imageBufferRef;
        } else {
            worked = [self renderCMSampleBufferRefIntoFramebuffer:sampleBuffer frameBuffer:frameBufferPtr];
            NSAssert(worked, @"renderIntoFramebuffer worked");
        }
        
        // If the delay between the previous frame and the current frame is more
        // than would be needed for one frame, then emit nop frames.
        
        // If a sample would be displayed for one frame, then the next one should
        // be displayed right away. But, in the case where a sample duration is
        // longer than one frame, emit repeated frames as no-op frames.
        
        CMTime presentationTimeStamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        
        CFRelease(sampleBuffer);
        
        float frameDisplayTime = (float) CMTimeGetSeconds(presentationTimeStamp);
        
        float expectedFrameDisplayTime = frameNum * self.frameDuration;
        
#ifdef LOGGING
        NSLog(@"frame presentation time = %0.4f", frameDisplayTime);
        NSLog(@"expected frame presentation time = %0.4f", expectedFrameDisplayTime);
        NSLog(@"prev frame presentation time = %0.4f", prevFrameDisplayTime);
#endif // LOGGING
        
        // Check for display time clock drift. This is caused by a frame that has
        // a frame display time that is so early that it is almost a whole frame
        // early. The decoder can't deal with this case because we have to maintain
        // an absolute display delta between frames. To fix the problem, we have
        // to drop a frame to let actual display time catch up to the expected
        // frame display time. We have already calculated the total number of frames
        // based on the reported duration of the whole movie, so this logic has the
        // effect of keeping the total duration consistent once the data is stored
        // in equally spaced frames.
        
        float frameDisplayEarly = 0.0;
        if (frameDisplayTime < expectedFrameDisplayTime) {
            frameDisplayEarly = expectedFrameDisplayTime - frameDisplayTime;
        }
        if (self.dropFrames && (frameDisplayEarly > frameDurationTooEarly)) {
            // The actual presentation time has drifted too far from the expected presentation time
            
#ifdef LOGGING
            NSLog(@"frame presentation drifted too early = %0.4f", frameDisplayEarly);
#endif // LOGGING
            
            // Drop the frame, meaning we do not write it to the .mvid file. Instead, let
            // processing continue with the next frame which will display at about the
            // right expected time. The frame number stays the same since no output
            // buffer was written. Note that we need to reset the prevFrameDisplayTime so
            // that no trailing nop frame is emitted in the normal case.
            
            prevFrameDisplayTime = expectedFrameDisplayTime;
            return FrameReadStatusTooEarly;
        }
        
        float delta = frameDisplayTime - prevFrameDisplayTime;
        
#ifdef LOGGING
        NSLog(@"frame display delta %0.4f", delta);
#endif // LOGGING
        
        prevFrameDisplayTime = frameDisplayTime;
        
        
        // FIXME:去除flag
        // Store the number of trailing frames that appear after this frame
//        Class cl = AVMvidFileWriter.class;
//        numTrailingNopFrames = [cl countTrailingNopFrames:delta frameDuration:self.frameDuration];
        // 修改
        numTrailingNopFrames = round(delta / self.frameDuration);
        if (numTrailingNopFrames > 1) {
          numTrailingNopFrames = numTrailingNopFrames - 1;
        } else {
          numTrailingNopFrames = 0;
        }
        
#ifdef LOGGING
        if (numTrailingNopFrames > 0) {
            NSLog(@"Found %d trailing NOP frames after frame %d", numTrailingNopFrames, (frameNum - 1));
        }
#endif // LOGGING
        
#ifdef LOGGING
        NSLog(@"DONE READING frame %d", frameNum);
#endif // LOGGING
        
        // Note that the frameBuffer object is explicitly retained so that it can
        // be used in each loop iteration.
        
        if (self.produceCoreVideoPixelBuffers == FALSE) {
            [self blockingDecodeVerifySize:*frameBufferPtr];
        }
        
        return FrameReadStatusNextFrame; //  从asset成功读取下一帧
    } else if ([aVAssetReader status] == AVAssetReaderStatusReading) {
        AVAssetReaderStatus status = aVAssetReader.status;
        NSError *error = aVAssetReader.error;
        
        NSLog(@"AVAssetReaderStatusReading");
        NSLog(@"status = %d", (int)status);
        NSLog(@"error = %@", [error description]);
    } else {
        // The copyNextSampleBuffer returned nil, so we seem to be done reading from
        // the asset. Check for the special case where a previous frame was displayed
        // at a specific time, but now there are no more frames after that frame.
        // Need to detect the case where 1 to N trailing nop frames appear after
        // the last frame we decoded. There does not apear to be a way to detect the
        // duration of a frame until the next one is decoded, so this is needed
        // to properly handle assets that end with nop frames. Also, it is unclear how
        // a H264 video that include a dup frame like this can be generated, so
        // this code appears to be untested.
        
        float finalFrameExpectedTime = self.numFrames * self.frameDuration;
        float delta = finalFrameExpectedTime - prevFrameDisplayTime;
        
        
         // FIXME:去除flag
        // Store the number of trailing frames that appear after this frame
//        Class cl = AVMvidFileWriter.class;
//        numTrailingNopFrames = [cl countTrailingNopFrames:delta frameDuration:self.frameDuration];
        // 修改
        numTrailingNopFrames = round(delta / self.frameDuration);
        if (numTrailingNopFrames > 1) {
          numTrailingNopFrames = numTrailingNopFrames - 1;
        } else {
          numTrailingNopFrames = 0;
        }
        
        if (numTrailingNopFrames > 0) {
            return FrameReadStatusDup;
        }
        
        // FIXME: should [self close] be called in this case ? Or can we at least mark the asset reader with cancelReading ?
        
        return FrameReadStatusDone;
    }
    
    return FrameReadStatusNotReady;
}

#pragma mark 渲染sample buffer到平面的CGFrameBuffer - invoke 3
// Render sample buffer into flat CGFrameBuffer. We can't read the samples
// directly out of the CVImageBufferRef because the rows of the image
// have some funky padding going on, likely "planar" data from YUV colorspace.
// The caller of this method should provide a location where a single
// frameBuffer can be stored so that multiple calls to this render function
// will make use of the same buffer. Note that the returned frameBuffer
// object is placed in the autorelease pool implicitly.
//  CMSampleBufferRef ==> CVImageBufferRef,从视频的AVAsset中获得sampleBuffer，直接获得到图片
- (BOOL) renderCMSampleBufferRefIntoFramebuffer:(CMSampleBufferRef)sampleBuffer frameBuffer:(AVSDKCGFrameBuffer**)frameBufferPtr
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
#ifdef DEBUG
    //[self imageFromRGBImageBuffer:imageBuffer];
#endif
    
    return [self renderCVImageBufferRefIntoFramebuffer:imageBuffer frameBuffer:frameBufferPtr];
}

#pragma mark 决定是否需要转换 - invoke 4
// This method will determine if a CoreVideo image buffer contains YUV or BGRX video data and
// convert from YUV to BGRX if needed.
// 此方法决定如果需要CoreVideo 图像缓冲区包含YUV 或 RGBA 视频数据和从YUV转换为RGBA
- (BOOL)renderCVImageBufferRefIntoFramebuffer:(CVImageBufferRef)imageBuffer frameBuffer:(AVSDKCGFrameBuffer**)frameBufferPtr {
    
    // 判断素的存储方式是Planar或Chunky
    //BOOL isPlanar =  CVPixelBufferIsPlanar(imageBuffer);
    // 若是Planar，则通过CVPixelBufferGetPlaneCount获取YUV Plane数量。
    
    // 得到像素缓冲区平面数量，返回PixelBuffer的平面数。对于非平面的CVPixelBufferRefs，返回0。
    int numPlanes = (int) CVPixelBufferGetPlaneCount(imageBuffer);
    
    if (numPlanes <= 1) {
        // BGRA contents
        return [self renderCVBGRAImageBufferRefIntoFramebuffer:imageBuffer frameBuffer:frameBufferPtr];
    } else {
        // YUV
        return [self renderCVYUVImageBufferRefIntoFramebuffer:imageBuffer frameBuffer:frameBufferPtr];
    }
    
}

#pragma mark YUV使用-使用CVImageBufferRef(YUV)生成image图像  invoke 5
- (BOOL) renderCVYUVImageBufferRefIntoFramebuffer:(CVImageBufferRef)imageBuffer frameBuffer:(AVSDKCGFrameBuffer**)frameBufferPtr
{
#if TARGET_IPHONE_SIMULATOR
  // CoreImage does not support yuv420 pixels
  assert(0);
#else
  CIContext *context = [CIContext contextWithOptions:nil];
  NSAssert(context, @"CIContext");
  
  CIImage *image = [CIImage imageWithCVPixelBuffer:imageBuffer];
  
  CIImage* outputImage = image;
  
  CGRect extent = [outputImage extent];
  
  CGSize size = extent.size;
  CVPixelBufferRef conversionBuffer = NULL;
  CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                        size.width,
                                        size.height,
                                        kCVPixelFormatType_32BGRA,
                                        (__bridge CFDictionaryRef) @{
                                                                     (__bridge NSString *)kCVPixelBufferIOSurfacePropertiesKey: @{},
                                                                     (__bridge NSString *)kCVPixelFormatOpenGLESCompatibility : @(YES),
                                                                     },
                                        &conversionBuffer);
  
  if (status == kCVReturnSuccess) {
    [context render:image toCVPixelBuffer:conversionBuffer];
  }
  
  BOOL worked = [self renderCVBGRAImageBufferRefIntoFramebuffer:conversionBuffer frameBuffer:frameBufferPtr];
  
  CVPixelBufferRelease(conversionBuffer);
  
  return worked;
#endif // TARGET_IPHONE_SIMULATOR
}

#pragma mark 赋值给currentFrameBuffer后面使用生成image，主要生成frameBuffer pixels存储 - invoke 5
// TODO:此处大概耗时1-2s，未做优化处理，最大耗时不在这里。
// Render BGRA pixels in a CoreVideo image buffer as a flat BGRA framebuffer
// 在CoreVideo核心框架图像缓冲区，渲染RGBA像素，作为平面的RGBA缓冲区。 -- 使用CVImageBufferRef(RGB)生成image图像
- (BOOL) renderCVBGRAImageBufferRefIntoFramebuffer:(CVImageBufferRef)imageBuffer frameBuffer:(AVSDKCGFrameBuffer**)frameBufferPtr
{
    AVSDKCGFrameBuffer *frameBuffer = *frameBufferPtr;
    // TODO: 1. 把CVImageBufferRef(CVPixelBufferRef)转为UIImage处理方法
#if defined(DEBUG)
    int numPlanes = (int) CVPixelBufferGetPlaneCount(imageBuffer);
    assert(numPlanes <= 1);
#endif // DEBUG
    // 解码后的数据不能直接给CPU访问，需要先用CVPixelBufferLockBaseAddress锁定地址才能从主存访问
    // 否则调用CVPixelBufferGetBaseAddressOfPlane等函数则返回NULL或无效值。然而，用CVImageBuffer -> CIImage -> UIImage则无需显式调用锁定基地址函数。
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); // 图像数据一行多少个字节bytes
    
    size_t width = CVPixelBufferGetWidth(imageBuffer); // 返回像素图像宽度
    
    size_t height = CVPixelBufferGetHeight(imageBuffer); // 返回像素图像高度
    
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer); // 返回PixelBuffer的基地址。
    
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer); // 获得图像缓冲区占用大小
    
    if (FALSE) {
        size_t left, right, top, bottom;
        CVPixelBufferGetExtendedPixels(imageBuffer, &left, &right, &top, &bottom);
        NSLog(@"extended pixels : left %d right %d top %d bottom %d", (int)left, (int)right, (int)top, (int)bottom);
        
        NSLog(@"buffer size = %d (bpr %d), row bytes (%d) * height (%d) = %d", (int)bufferSize, (int)(bufferSize/height), (int)bytesPerRow, (int)height, (int)(bytesPerRow * height));
    }
    
    // Under iOS, the output pixels are implicitly treated as sRGB when using the device
    // colorspace. Under MacOSX, explicitly set the output colorspace to sRGB.
    // 在iOS下，使用设备色彩空间时，输出像素被隐式视为sRGB。 在MacOSX下，将输出色彩空间显式设置为sRGB。
    CGColorSpaceRef colorSpace = NULL; // 创建一个颜色空间引用
#if TARGET_OS_IPHONE
    colorSpace = CGColorSpaceCreateDeviceRGB(); // 创建一个颜色空间引用
#else
    // MacOSX
    
    //colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
    colorSpace = CVImageBufferGetColorSpace(imageBuffer);
#endif // TARGET_OS_IPHONE
    NSAssert(colorSpace, @"colorSpace");
    
    // Create a Quartz direct-access data provider that uses data we supply.
    // 创建当前bufferSize所需要的所有空间地址。
    CGDataProviderRef dataProvider =
    CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32; // 每个字节32位
    
    // Input should be BGRA pixels represented as a word buffer
    // 构建出一个图像
    CGImageRef cgImageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow,
                                          colorSpace, kCGBitmapByteOrder32Host | kCGImageAlphaNoneSkipFirst,
                                          dataProvider, NULL, true, kCGRenderingIntentDefault);
    
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(dataProvider);
    
    // Render CoreGraphics image into a flat bitmap framebuffer. Note that this object is
    // not autoreleased, instead the caller must explicitly release the ref.
    // TODO: 2. 对AVSDKCGFrameBuffer处理，将会存储image数据和pixels数据
    if (frameBuffer == NULL) {
        frameBuffer = [[AVSDKCGFrameBuffer alloc] initWithBppDimensions:24 width:width height:height];
#if __has_feature(objc_arc)
#else
        frameBuffer = [frameBuffer autorelease];
#endif // objc_arc
        NSAssert(frameBuffer, @"frameBuffer");
        *frameBufferPtr = frameBuffer; // 把此frameBuffer缓冲区地址分配给外部已经初始化分配地址的对象，指针重新指向即可。
        
        // Also save allocated framebuffer as a property in the object - 还将分配的帧缓冲区另存为对象中的属性
        // TODO: 赋值当前frameBuffer
        self.currentFrameBuffer = frameBuffer;
        
        // Use sRGB by default on iOS. Explicitly set sRGB as colorspace on MacOSX.
        
#if TARGET_OS_IPHONE
        // No-op
#else
        // MacOSX
        colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
        frameBuffer.colorspace = colorSpace;
        CGColorSpaceRelease(colorSpace);
#endif // TARGET_OS_IPHONE
    }
    
    // FIXME: This render operation to flatten the input framebuffer into a known
    // framebuffer layout is 98% of the alpha frame decode time, so optimization
    // would need to start here. Simply not having to copy the buffer or invoke
    // a CG render rountine would likely save most of the execution time. Need
    // to validate the input pixel layout vs the expected layout to determine
    // if we could just memcopy directly and if that would be faster than
    // addressing the data with CG render logic.
    /**
     帧缓冲区的布局是alpha帧解码时间的98％，因此优化需要从此处开始。 只需不必复制缓冲区或调用CG渲染常规程序就可以节省大部分执行时间。 需要验证输入像素的布局与预期的布局，以确定我们是否仅可以直接进行内存复制，以及是否比使用CG渲染逻辑处理数据更快。
     */
    [frameBuffer renderCGImage:cgImageRef];  // 此方法调用会进行所有的pixels赋值。
    
    CGImageRelease(cgImageRef);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return TRUE;
}


// Verify width/height of frame being read from asset
- (void) blockingDecodeVerifySize:(AVSDKCGFrameBuffer*)frameBuffer
{
    size_t width = frameBuffer.width;
    size_t height = frameBuffer.height;
    
    NSAssert(width > 0, @"width");
    NSAssert(height > 0, @"height");
    
    if (detectedMovieSize.width == 0) {
        detectedMovieSize = CGSizeMake(width, height);
    } else {
        NSAssert(CGSizeEqualToSize(detectedMovieSize, CGSizeMake(width, height)), @"size");
    }
}


#pragma mark - allocateDecodeResources
// nop, since opening the asset allocates resources
- (BOOL) allocateDecodeResources {
    return TRUE;
}


#pragma mark - getter

- (NSUInteger) numFrames
{
  return self->m_numFrames;
}

- (NSInteger) frameIndex
{
  return self->frameIndex;
}
// Time each frame shold be displayed
- (NSTimeInterval)frameDuration {
    float frameDuration = self->m_frameDuration;
    return frameDuration;
}

- (NSUInteger) width
{
  return detectedMovieSize.width;
}

- (NSUInteger) height
{
  return detectedMovieSize.height;
}


@end
