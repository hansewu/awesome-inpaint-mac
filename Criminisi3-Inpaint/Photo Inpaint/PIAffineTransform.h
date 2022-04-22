//
//  PIAffineTransform.h
//  Photo Inpaint
//
//  Created by tangj on 15/6/30.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef enum {
    transformType_fill,
    transformType_strech,
    transformType_crop,
}PITransformType;
@interface PIAffineTransform : NSObject
@property (assign) NSSize canvasSize;
@property (assign) NSSize imageSize;
@property (assign) PITransformType transformType;
+ (PIAffineTransform *)shareAffineTransform;
- (void)createTransformBy:(NSSize)canvasSize with:(NSSize)imageSize withType:(PITransformType)type;
- (NSRect)transformRect:(NSRect)inRect;
- (NSRect)invertTransformRect:(NSRect)inRect;
- (NSBezierPath *)transformBezierPath:(NSBezierPath *)path;
- (NSBezierPath *)invertTransformBezierPath:(NSBezierPath *)path;
@end
