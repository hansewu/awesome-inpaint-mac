//
//  PCOutImageFormat.h
//  PhotoStudio
//
//  Created by Lion Mac OS on 9/25/13.
//  Copyright (c) 2013 Lion Mac OS. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PCOutImageFormat : NSObject

+(PCOutImageFormat *)outImageFormat;
-(NSString *)defaultOutImageFormatExt;
-(NSArray *)supportFormatExt;
-(NSArray *)supportFormatDescription;
-(NSString *)formatExtFromDescription:(NSString *)description;
-(NSString *)formatExtToDescription:(NSString *)ext;
-(NSBitmapImageFileType)formatTypeWithExt:(NSString *)ext;
-(NSBitmapImageFileType)formatTypeWithDescription:(NSString *)description;
-(CFStringRef)formatUTIWithExt:(NSString *)ext;
-(CFStringRef)formatUTIWithDescription:(NSString *)description;
@end
