//
//  PIAffineTransform.m
//  Photo Inpaint
//
//  Created by tangj on 15/6/30.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "PIAffineTransform.h"

@implementation PIAffineTransform
{
    NSAffineTransform *_transform;
    NSSize _canvasSize;
    NSSize _imageSize;
    PITransformType _transformType;
}
@synthesize canvasSize = _canvasSize;
@synthesize imageSize  = _imageSize;
@synthesize transformType = _transformType;
+ (PIAffineTransform *)shareAffineTransform
{
    static PIAffineTransform *pitransform = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        pitransform = [[PIAffineTransform alloc] init];
    });
    return pitransform;
}
- (void)createTransformBy:(NSSize)canvasSize with:(NSSize)imageSize withType:(PITransformType)type
{
    [self setCanvasSize:canvasSize];
    [self setImageSize:imageSize];
    [self setTransformType:type];
}

- (void)setCanvasSize:(NSSize)canvasSize
{
    if (!NSEqualSizes(self.canvasSize, canvasSize)) {
        _canvasSize = canvasSize;
        [self updateTransform];
    }
}

- (NSSize)canvasSize
{
    return _canvasSize;
}

- (void)setImageSize:(NSSize)imageSize
{
    if (!NSEqualSizes(self.imageSize, imageSize)) {
        _imageSize = imageSize;
        [self updateTransform];
    }
}

- (NSSize)imageSize
{
    return _imageSize;
}

- (void)setTransformType:(PITransformType)transformType
{
    if (self.transformType != transformType) {
        _transformType = transformType;
        [self updateTransform];
    }
}

- (PITransformType)transformType
{
    return _transformType;
}

- (void)updateTransform
{
    if (_transform) {
        [_transform release];
        _transform = nil;
    }
    
    _transform = [[self transformationWithCanvasSize:self.canvasSize withOriginSize:self.imageSize withChangedType:self.transformType] retain];
}

- (NSAffineTransform *)transformationWithCanvasSize:(NSSize)canvasSz  withOriginSize:(NSSize)originSz withChangedType:(PITransformType)type
{
    CGFloat vScalingRatio = 1.0;
    CGFloat hScalingRatio = 1.0;
    CGFloat vTraslate = 0.0;
    CGFloat hTraslate = 0.0;
    switch (type) {
        case transformType_strech:
        {
            vScalingRatio = canvasSz.height*1.0 / originSz.height;
            hScalingRatio = canvasSz.width*1.0 / originSz.width;
        }
            break;
        case transformType_crop:
        {
            hScalingRatio = fmax(canvasSz.width/originSz.width, canvasSz.height/originSz.height);
            vScalingRatio = hScalingRatio;
            if (canvasSz.height*originSz.width <= canvasSz.width*originSz.height) {
                vTraslate = (canvasSz.height - hScalingRatio*originSz.height)/2.0;
                hTraslate = 0;
            }else{
                hTraslate = (canvasSz.width - vScalingRatio*originSz.width)/2.0f;
                vTraslate = 0;
            }
        }
            break;
        case transformType_fill:
        {
            vScalingRatio = fmin(canvasSz.width/originSz.width, canvasSz.height/originSz.height);
            hScalingRatio = vScalingRatio;
            if (canvasSz.height*originSz.width <= canvasSz.width*originSz.height) {
                hTraslate = (canvasSz.width - originSz.width*hScalingRatio) / 2.0f;
                vTraslate = 0;
            }else{
                vTraslate = (canvasSz.height - originSz.height*vScalingRatio) / 2.0f;
                hTraslate = 0;
            }
        }
            break;
        default:
            break;
    }
    
    NSAffineTransform *transform = [NSAffineTransform transform];
    NSAffineTransform *tTrans = [NSAffineTransform transform];
    [tTrans scaleXBy:hScalingRatio yBy:vScalingRatio];
    [transform appendTransform:tTrans];
    tTrans = [NSAffineTransform transform];
    [tTrans translateXBy:hTraslate yBy:vTraslate];
    [transform appendTransform:tTrans];
    return transform;
}


- (NSRect)transformRect:(NSRect)inRect
{
    NSRect tempRect = NSZeroRect;
    if (_transform) {
        tempRect.origin = [_transform transformPoint:inRect.origin];
        tempRect.size   = [_transform transformSize:inRect.size];
    }
    return tempRect;
}
- (NSRect)invertTransformRect:(NSRect)inRect
{
    NSRect tempRect = NSZeroRect;
    if (_transform) {
         NSAffineTransform *transform = [[NSAffineTransform alloc] initWithTransform:_transform];
        [transform invert];
        tempRect.origin = [transform transformPoint:inRect.origin];
        tempRect.size   = [transform transformSize:inRect.size];
        [transform release];
    }
    return tempRect;
}

- (NSBezierPath *)transformBezierPath:(NSBezierPath *)path
{
    if (path && _transform) {
        NSBezierPath *bezierPath = [_transform transformBezierPath:path];
        return bezierPath;
    }
    return nil;
}

- (NSBezierPath *)invertTransformBezierPath:(NSBezierPath *)path
{
    if (_transform && path) {
        NSAffineTransform *tempTransform = [[NSAffineTransform alloc] initWithTransform:_transform];
        [tempTransform invert];
        NSBezierPath *tempPath = [tempTransform transformBezierPath:path];
        [tempTransform release];
        return tempPath;
    }
    return nil;
}

- (void)dealloc
{
    [super dealloc];
    if (_transform) {
        [_transform release];
        _transform = nil;
    }
}
@end
