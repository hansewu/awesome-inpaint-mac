//
//  PIBottomView.m
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/6/23.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "PIBottomView.h"

@implementation PIBottomView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [[NSColor grayColor] set];
    NSRectFill(self.bounds);
}

@end
