////  NWFCustomAFNetHTTPSessionMgr.m
//  AFNetworking
//
//  Created on 2019/8/15.
//  
//

#import "NWFCustomAFNetHTTPSessionMgr.h"

@implementation NWFCustomAFNetHTTPSessionMgr

+ (instancetype)manager{
    NWFCustomAFNetHTTPSessionMgr *manager = [super manager];
    // 1. XML - if sever back XML data,set AFNetworking serializer style
    //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    // 2. not Json/XML
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/xhtml+xml", @"application/xml", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"video/mp4", @"text/plain",@"charset=utf-8",nil];
    manager.requestSerializer.timeoutInterval = 60.f;
    return manager;
}

@end
