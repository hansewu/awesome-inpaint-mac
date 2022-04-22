//
//  LRHMSideBarItem.h
//  sidebar
//
//  Created by tangj on 15/6/19.
//  Copyright (c) 2015年 tangj. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LRHMSideBarItem;
@protocol LRHMSideBarItemDelegate<NSObject>
- (void)mouseDownOfItem:(LRHMSideBarItem *)sideBarItem;
- (void)mouseUpOfItem:(LRHMSideBarItem *)sideBarItem;
@end
@interface LRHMSideBarItem : NSView
@property (assign) id<LRHMSideBarItemDelegate>delegate;

@property (assign,nonatomic) NSImage *icon;
@property (assign,nonatomic) NSString *title;
@property (assign,nonatomic) NSFont *titleFont;
@property (assign,nonatomic) NSColor *titleColor;

@property (assign,nonatomic) BOOL isSelection;
@property (assign,nonatomic) BOOL isFadeTitle;
@end
