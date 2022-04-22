//
//  PIProgressView.m
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/7/1.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "PIProgressView.h"

@implementation PIProgressView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRect:self.bounds];
    [[NSColor colorWithWhite:0.7 alpha:0.5] setFill];
    [bezierPath fill];

}


- (void)mouseUp:(NSEvent *)theEvent
{
    
}

- (void)mouseDown:(NSEvent *)theEvent
{
    
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    
}
@end
