//
//  LRHMSideBar.m
//  sidebar
//
//  Created by tangj on 15/6/19.
//  Copyright (c) 2015年 tangj. All rights reserved.
//

#import "LRHMSideBar.h"
#import "LRHMSideBarItem.h"
@interface LRHMSideBar()<LRHMSideBarItemDelegate>
@end
@implementation LRHMSideBar

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:5 yRadius:5];
    [[NSColor colorWithDeviceWhite:0.7 alpha:0.5] setFill];
    [path fill];
    [self initSideBarItem];
}


- (void)awakeFromNib
{
//    [self initSideBarItem];
}

- (void)initSideBarItem
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [_brushBarItem setIcon:[NSImage imageNamed:@"brush"]];
        [_brushBarItem setDelegate:self];
        [_brushBarItem setTitle:@"Brush"];
        
        [_redoBarItem setIcon:[NSImage imageNamed:@"redo"]];
        [_redoBarItem setDelegate:self];
        [_redoBarItem setTitle:@"Redo"];
        
        [_undoBarItem setIcon:[NSImage imageNamed:@"undo"]];
        [_undoBarItem setDelegate:self];
        [_undoBarItem setTitle:@"Undo"];
        
        [_saveBarItem setIcon:[NSImage imageNamed:@"save"]];
        [_saveBarItem setDelegate:self];
        [_saveBarItem setTitle:@"Save"];
    });

}

- (void)mouseDownOfItem:(LRHMSideBarItem *)sideBarItem
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBar:mouseDownInItem:)]) {
        [self.delegate sideBar:self mouseDownInItem:sideBarItem];
    }
}

- (void)mouseUpOfItem:(LRHMSideBarItem *)sideBarItem
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideBar:mouseUpInItem:)]) {
        [self.delegate sideBar:self mouseUpInItem:sideBarItem];
    }
}
@end
