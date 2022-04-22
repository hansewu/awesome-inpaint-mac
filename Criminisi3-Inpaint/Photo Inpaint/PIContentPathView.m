//
//  PIContentPathView.m
//  Photo Inpaint
//
//  Created by tangj on 15/7/1.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "PIContentPathView.h"

@implementation PIContentPathView
{
    NSBezierPath *_drawPath;
}
@synthesize path;
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (_drawPath) {
        [[NSColor redColor] setFill];
        [_drawPath fill];
    }
    // Drawing code here.
}

- (void)awakeFromNib
{
    
}

- (void)clearPath
{
    if (_drawPath) {
        [_drawPath release];
        _drawPath = nil;
    }
    [self setNeedsDisplay:YES];
}

- (void)ensureCreateDrawPath
{
    if (!_drawPath) {
        _drawPath = [[NSBezierPath bezierPath] retain];
    }
}

- (void)setPath:(NSBezierPath *)elementPath
{
    
    if (elementPath) {
        [self ensureCreateDrawPath];
        [_drawPath appendBezierPath:elementPath];
    }
}

- (NSBezierPath *)path
{
    return _drawPath;
}

- (void)dealloc
{
    [super dealloc];
    [self clearPath];
}
@end
