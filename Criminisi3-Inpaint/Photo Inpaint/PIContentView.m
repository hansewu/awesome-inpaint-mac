//
//  PIContentView.m
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/6/23.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "PIContentView.h"
#import "PIImageDataMgr.h"
@implementation PIContentView
{
    NSPoint _point;
    NSBezierPath *_path;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self drawBackground];
    
    
    NSImage *image = [self.datasource sourceImageOfContentView:self];
    NSRect drawFrame = NSMakeRect(0, 0, image.size.width, image.size.height);
    
    [[PIAffineTransform shareAffineTransform] createTransformBy:self.bounds.size with:image.size withType:transformType_fill];
    drawFrame = [[PIAffineTransform shareAffineTransform] transformRect:drawFrame];
    if (image) {
         [image drawInRect:drawFrame];
    }
}

- (void)drawBackground
{
    [[NSColor blackColor] setFill];
    NSRectFill(self.bounds);
}

- (void)awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSArray *images = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    if ([images count] != 1) {
        return NSDragOperationNone;
    }
    
    NSString *pathExt = [[[images objectAtIndex:0] pathExtension] lowercaseString];
    if ([[[PIImageDataMgr shareDataMgr] supportFormats] containsObject:pathExt]) {
       return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSArray *images = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    if ([images count] != 1) {
        return NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragImageUrl:toContentView:)]) {
        [self.delegate dragImageUrl:[NSURL fileURLWithPath:[images objectAtIndex:0]] toContentView:self];
    }
    return YES;
}

#pragma mark mouse action
- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint pt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mouseDragTo:inContentView:)]) {
        [self.delegate mouseDragTo:pt inContentView:self];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint pt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mouseDownAt:inContentView:)]) {
        [self.delegate mouseDownAt:pt inContentView:self];
    }
}
@end
