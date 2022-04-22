//
//  PIContentView.h
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/6/23.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PIAffineTransform.h"
@class PIContentView;
@protocol PIContentViewDelegate<NSObject>
@optional
- (void)dragImageUrl:(NSURL *)url toContentView:(PIContentView *)contentView;
- (void)mouseDragTo:(NSPoint)point inContentView:(PIContentView *)contentView;
- (void)mouseDownAt:(NSPoint)point inContentView:(PIContentView *)contentView;
@end

@protocol PIContentViewDatasource <NSObject>
- (NSImage *)sourceImageOfContentView:(PIContentView *)contentView;
@end

@interface PIContentView : NSView
@property (assign) IBOutlet id<PIContentViewDelegate>delegate;
@property (assign) IBOutlet id<PIContentViewDatasource>datasource;
@end
