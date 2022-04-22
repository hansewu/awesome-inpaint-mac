/*
     File: ATBorderView.m
 Abstract: A simple NSView subclass that draws a round-rect border with a small triangle pointing towards something.
 
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 */

#import "LRHMPopupBorderView.h"
#define _triangleSize_  15.0
#define _cornerRadius_  10.0
@implementation LRHMPopupBorderView

- (BOOL)isOpaque {
    return NO;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Some constants that easily could be changed to meet your needs
//    [self popupWndBottom];
    switch (self.popupWndPosition) {
        case popupPosition_top:
        {
            [self popupWndTop];
        }
            break;
        case popupPosition_bottom:
        {
            [self popupWndBottom];
        }
            break;
        default:
            break;
    }
}

- (void)popupWndTop
{
    NSRect bounds = self.bounds;
    bounds.size.height -= _triangleSize_;
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:_cornerRadius_ yRadius:_cornerRadius_];
    
    // Draw a triangle at the top. We are not flipped (the default), so our origin is the bottom left.
    NSPoint point =NSMakePoint(floor(NSMidX(bounds) - _triangleSize_), NSMaxY(bounds));
    [borderPath moveToPoint:point];
    point.x += _triangleSize_;
    point.y += _triangleSize_;
    [borderPath lineToPoint:point];
    point.x += _triangleSize_;
    point.y -= _triangleSize_;
    [borderPath lineToPoint:point];
    
    // And fill
    [[NSColor windowBackgroundColor] setFill];
    [borderPath fill];
}

- (void)popupWndBottom
{
    NSRect bounds = self.bounds;
    bounds.size.height -= _triangleSize_;
    bounds.origin.y += _triangleSize_;
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:_cornerRadius_ yRadius:_cornerRadius_];
    
    // Draw a triangle at the top. We are not flipped (the default), so our origin is the bottom left.
    NSPoint point =NSMakePoint(floor(NSMidX(bounds) - _triangleSize_), NSMinY(bounds));
    [borderPath moveToPoint:point];
    point.x += _triangleSize_;
    point.y -= _triangleSize_;
    [borderPath lineToPoint:point];
    point.x += _triangleSize_;
    point.y += _triangleSize_;
    [borderPath lineToPoint:point];
    
    // And fill
    [[NSColor colorWithWhite:0.5 alpha:0.7] setFill];
    [borderPath fill];
}
@end
