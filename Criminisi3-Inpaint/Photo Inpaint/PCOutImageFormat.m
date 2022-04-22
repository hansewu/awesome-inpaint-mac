//
//  PCOutImageFormat.m
//  PhotoStudio
//
//  Created by Lion Mac OS on 9/25/13.
//  Copyright (c) 2013 Lion Mac OS. All rights reserved.
//

#import "PCOutImageFormat.h"

static NSString * const PCOutImageFormatJPGExt=@"jpeg";
static NSString * const PCOutImageFormatJPEGExt=@"jp2";
static NSString * const PCOutImageFormatPNGExt=@"png";
static NSString * const PCOutImageFormatBMPExt=@"bmp";
static NSString * const PCOutImageFormatTIFFExt=@"tiff";
static NSString * const PCOutImageFormatGIFExt=@"gif";

@implementation PCOutImageFormat


+(PCOutImageFormat *)outImageFormat
{
    static PCOutImageFormat * gOutImageFormat=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gOutImageFormat=[[PCOutImageFormat alloc] init];
    });
    return gOutImageFormat;
}

-(id)init
{
    self = [super init];
    if(self){
        //_defaultOutFormatExt = PCOutImageFormatPNGExt;
    }
    return self;
}

-(NSArray *)supportFormatExt
{
    return [NSArray arrayWithObjects:PCOutImageFormatJPGExt,
            PCOutImageFormatJPEGExt, PCOutImageFormatPNGExt,
            PCOutImageFormatBMPExt, PCOutImageFormatTIFFExt,
            PCOutImageFormatGIFExt, nil];
}

-(NSString *)defaultOutImageFormatExt
{
    return PCOutImageFormatBMPExt;
}

-(NSArray *)supportFormatDescription
{
    return [NSArray arrayWithObjects:@"JPEG", @"JPEG-2000", @"PNG", @"Bitmap", @"TIFF", @"GIF", nil];
}

-(NSString *)formatExtFromDescription:(NSString *)description
{
    NSUInteger index = [[self supportFormatDescription] indexOfObject:description];
    if(index == NSNotFound){
        return [self defaultOutImageFormatExt];
    }else{
        return [[self supportFormatExt] objectAtIndex:index];
    }
}

-(NSString *)formatExtToDescription:(NSString *)ext
{
    NSUInteger index = [[self supportFormatExt] indexOfObject:ext];
    if(index == NSNotFound){
        return [self formatExtToDescription:[self defaultOutImageFormatExt]];
    }else{
        return [[self supportFormatDescription] objectAtIndex:index];
    }
}

-(NSBitmapImageFileType)formatTypeWithExt:(NSString *)ext
{
    if([ext isEqualToString:PCOutImageFormatBMPExt]){
        return NSBMPFileType;
    }else if([ext isEqualToString:PCOutImageFormatGIFExt]){
        return NSGIFFileType;
    }else if([ext isEqualToString:PCOutImageFormatJPEGExt]){
        return NSJPEG2000FileType;
    }else if([ext isEqualToString:PCOutImageFormatJPGExt]){
        return NSJPEGFileType;
    }else if([ext isEqualToString:PCOutImageFormatPNGExt]){
        return NSPNGFileType;
    }else if([ext isEqualToString:PCOutImageFormatTIFFExt]){
        return NSTIFFFileType;
    }else{
        return [self formatTypeWithExt:[self defaultOutImageFormatExt]];
    }
}

-(NSBitmapImageFileType)formatTypeWithDescription:(NSString *)description
{
    return [self formatTypeWithExt:[self formatExtFromDescription:description]];
}

-(CFStringRef)formatUTIWithExt:(NSString *)ext
{
    if([ext isEqualToString:PCOutImageFormatBMPExt]){
        return kUTTypeBMP;
    }else if([ext isEqualToString:PCOutImageFormatGIFExt]){
        return kUTTypeGIF;
    }else if([ext isEqualToString:PCOutImageFormatJPEGExt]){
        return kUTTypeJPEG2000;
    }else if([ext isEqualToString:PCOutImageFormatJPGExt]){
        return kUTTypeJPEG;
    }else if([ext isEqualToString:PCOutImageFormatPNGExt]){
        return kUTTypePNG;
    }else if([ext isEqualToString:PCOutImageFormatTIFFExt]){
        return kUTTypeTIFF;
    }else{
        return [self formatUTIWithExt:[self defaultOutImageFormatExt]];
    }
}

-(CFStringRef)formatUTIWithDescription:(NSString *)description
{
    return [self formatUTIWithExt:[self formatExtFromDescription:description]];
}
@end
