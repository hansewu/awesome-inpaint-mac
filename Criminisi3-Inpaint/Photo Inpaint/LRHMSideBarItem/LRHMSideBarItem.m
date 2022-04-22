//
//  LRHMSideBarItem.m
//  sidebar
//
//  Created by tangj on 15/6/19.
//  Copyright (c) 2015年 tangj. All rights reserved.
//

#import "LRHMSideBarItem.h"
#import "LRHMTitleView.h"

#define icon_width_scaling  0.5
#define icon_height_scaling 0.5
#define title_width_scaling 0.8
#define title_height_scaling 0.2
#define space_scaling 0.1
@interface LRHMSideBarItem ()
{
    NSImageView *_iconView;
    LRHMTitleView *_titleView;
}
@end

@implementation LRHMSideBarItem
@dynamic icon;
@dynamic title;
@dynamic titleColor;
@dynamic titleFont;

@synthesize isSelection;

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:5 yRadius:5];
    if (self.isSelection) {
        [[NSColor blueColor] setFill];
    }else{
        [[NSColor cyanColor] setFill];
    }
    [path fill];
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self initSideBarItemInfo];
    }
    return self;
}

- (void)awakeFromNib
{
    self.isSelection = NO;
    [self initSideBarItemInfo];
}
#pragma mark init
- (void)initSideBarItemInfo
{
    [self initIconView];
    [self initTitleView];
}

- (void)initIconView
{
    if (!_iconView) {
        _iconView = [[NSImageView alloc] initWithFrame:[self frameOfIconView]];
        [self addSubview:_iconView];
    }
}

- (void)initTitleView
{
    if (!_titleView) {
        _titleView = [[LRHMTitleView alloc] initWithFrame:[self frameOfTitleView]];
        [self addSubview:_titleView];
    }
    
}

- (NSRect)frameOfIconView
{
    NSSize size = self.frame.size;
    NSRect frame = NSZeroRect;
    frame.size.width = size.width * icon_width_scaling;
    frame.size.height = size.height * icon_height_scaling;
    frame.origin.y = size.height * (title_height_scaling + 2*space_scaling);
    frame.origin.x = (size.width - frame.size.width) * 0.5;
    return frame;
}

- (NSRect)frameOfTitleView
{
    NSSize size = self.frame.size;
    NSRect frame = NSZeroRect;
    frame.size.width = size.width * title_width_scaling;
    frame.size.height = size.height * title_height_scaling;
    frame.origin.y = size.height * space_scaling;
    frame.origin.x = (size.width - frame.size.width) * 0.5;
    return frame;
}

#pragma mark trackingArea
- (void)addTrackArea
{
    if (self.isFadeTitle) {
        NSTrackingArea *trackArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveInActiveApp| NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
        [self addTrackingArea:trackArea];
        [trackArea release];
    }
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (self.isFadeTitle) {
        for (NSTrackingArea *area in self.trackingAreas) {
            [self removeTrackingArea:area];
        }
        [self addTrackArea];
    }
}
#pragma mark set data
- (void)setIcon:(NSImage *)icon
{
    if (icon) {
        [_iconView setImage:icon];
    }
}

- (void)setTitle:(NSString *)title
{
    if (title) {
        [_titleView setTitle:title];
        [_titleView setNeedsDisplay:YES];
    }
}

- (void)setTitleColor:(NSColor *)titleColor
{
    if (titleColor) {
        [_titleView setColor:titleColor];
        [_titleView setNeedsDisplay:YES];
    }
}

- (void)setTitleFont:(NSFont *)titleFont
{
    if (titleFont) {
        [_titleView setFont:titleFont];
        [_titleView setNeedsDisplay:YES];
    }
}

#pragma mark mouse action
- (void)mouseDown:(NSEvent *)theEvent
{
    self.isSelection = !self.isSelection;
    if (self.delegate && [self.delegate respondsToSelector:@selector(mouseDownOfItem:)]) {
        [self.delegate mouseDownOfItem:self];
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mouseUpOfItem:)]) {
        [self.delegate mouseUpOfItem:self];
    }
}

#pragma mark release
- (void)dealloc
{
    [super dealloc];
    self.icon = nil;
}
@end
