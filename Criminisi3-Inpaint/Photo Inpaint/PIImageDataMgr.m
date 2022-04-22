//
//  PIDataMgr.m
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/6/23.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "PIImageDataMgr.h"
@interface PIImageDataMgr()
@property (retain)  NSURL *imageUrl;
@property (retain) NSDictionary *imageMetaData;
@property (retain) NSString *imageType;
@end
@implementation PIImageDataMgr
+ (PIImageDataMgr *)shareDataMgr
{
    static PIImageDataMgr *dataMgr = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        dataMgr = [[PIImageDataMgr alloc] init];
    });
    return dataMgr;
}


- (BOOL)parseImageDataWith:(NSURL *)url
{
    CGImageSourceRef source = NULL;
    self.imageUrl = url;
    if (url) source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    
    //    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    if (source)
    {
        // get image properties (height, width, depth, metadata etc.) for display
        NSDictionary* props = (NSDictionary*) CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
        self.imageType = (NSString *)CGImageSourceGetType(source);
        CFRelease(source);
        if (props) {
            NSLog(@"metaData is %@",props);
            self.imageMetaData = props;
            [props release];
            return YES;
        }
    }
    return NO;
}

- (NSImage *)sourceImage
{
    CGImageRef image = [self CGImageCreateWithPath:[self.imageUrl path]];
    NSImage *srcimage = [[NSImage alloc] initWithCGImage:image size:NSMakeSize(CGImageGetWidth(image), CGImageGetHeight(image))];
    CGImageRelease(image);
    return [srcimage autorelease];
}

- (CGImageRef)CGImageCreateWithPath:(NSString *)path
{
    CFStringRef cfString =  CFStringCreateWithCString(NULL,[path UTF8String], kCFStringEncodingUTF8);
    CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                                     cfString,
                                                     kCFURLPOSIXPathStyle,
                                                     false);
    CFRelease(cfString);
    CGImageSourceRef source = CGImageSourceCreateWithURL(fileURL, NULL);
    
    if(source == NULL)
    {
        CFRelease( fileURL );
        return NULL;
    }
    
    CGImageRef image = CGImageSourceCreateImageAtIndex(source,0,NULL);
    CFRelease( fileURL );
    CFRelease(source);
    return image;
}

- (NSString *)fileType
{
    return self.imageType;
}

- (NSString *)fileName
{
    return [[[self.imageUrl path] lastPathComponent] stringByDeletingPathExtension];
}

- (NSDictionary *)metaData
{
    return self.imageMetaData;
}

- (NSArray *)supportFormats
{//@"hdr",@"jp2",@"jpc",@"sgi",@"psd”,
    return [NSArray arrayWithObjects:@"jpg",@"bmp",@"jpeg",@"gif",@"png",@"tiff",@"tif",/*@"pic",*/@"ico",@"icns",@"tga",@"hdr",@"jp2",@"jpc",@"sgi",@"psd", nil];
}
@end
