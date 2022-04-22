//
//  LRHMTitleView.m
//  sidebar
//
//  Created by tangj on 15/6/19.
//  Copyright (c) 2015年 tangj. All rights reserved.
//

#import "LRHMTitleView.h"

@implementation LRHMTitleView
@synthesize font;
@synthesize color;
@synthesize title;

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:2 yRadius:2];
    [[NSColor whiteColor] setFill];
    [path fill];
    [[self displayTitle] drawInRect:self.bounds withAttributes:[self titleAttribute]];
}

- (void)awakeFromNib
{
    [self initDefaultData];
}

- (void)initDefaultData
{
    self.font = nil;
    self.color = nil;
    self.title = nil;
}

- (NSString *)defualtTitle
{
    return @"default name";
}

- (NSDictionary *)titleAttribute
{
    NSMutableParagraphStyle *mpstyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [mpstyle setLineBreakMode: NSLineBreakByTruncatingTail];
    [mpstyle setAlignment: NSCenterTextAlignment];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: mpstyle,NSParagraphStyleAttributeName,
                                                                          (self.font ? self.font : [NSFont systemFontOfSize:[NSFont smallSystemFontSize]]),NSFontAttributeName,
                                                                          (self.color ? self.color : [NSColor blackColor]), NSForegroundColorAttributeName,nil];
    return attributes;
}

- (NSString *)displayTitle
{
    return self.title ? self.title : [self defualtTitle];
}

- (void)dealloc
{
    self.font = nil;
    self.title = nil;
    self.color = nil;
    [super dealloc];
}
@end
