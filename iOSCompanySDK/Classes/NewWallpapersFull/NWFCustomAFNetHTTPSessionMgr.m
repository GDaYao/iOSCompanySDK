////  NWFCustomAFNetHTTPSessionMgr.m


#import "NWFCustomAFNetHTTPSessionMgr.h"

@implementation NWFCustomAFNetHTTPSessionMgr

+ (instancetype)manager{
    NWFCustomAFNetHTTPSessionMgr *manager = [super manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/xhtml+xml", @"application/xml", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"video/mp4", @"text/plain",@"charset=utf-8",nil];
    manager.requestSerializer.timeoutInterval = 60.f;
    return manager;
}

@end
