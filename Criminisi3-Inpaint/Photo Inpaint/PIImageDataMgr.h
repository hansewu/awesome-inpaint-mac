//
//  PIDataMgr.h
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/6/23.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIImageDataMgr : NSObject
+ (PIImageDataMgr *)shareDataMgr;
- (BOOL)parseImageDataWith:(NSURL *)url;
- (NSString *)fileName;
- (NSString *)fileType;
- (NSDictionary *)metaData;
- (NSImage *)sourceImage;
- (NSArray *)supportFormats;
@end
