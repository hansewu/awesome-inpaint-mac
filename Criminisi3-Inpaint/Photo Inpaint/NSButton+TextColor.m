//
//  NSButton+TextColor.m
//  VideoEdit
//
//  Created by Duen Yuen on 8/21/14.
//  Copyright (c) 2014 Jorn Dan. All rights reserved.
//

#import "NSButton+TextColor.h"

@implementation NSButton (TextColor)
- (NSColor *)textColor
{
    NSAttributedString *attrTitle = [self attributedTitle];
    int len       = (int)[attrTitle length];
    NSRange range = NSMakeRange(0, MIN(len, 1));
    NSDictionary *attrs = [attrTitle fontAttributesInRange:range];
    NSColor *textColor = [NSColor controlTextColor];
    if (attrs) {
        textColor = [attrs objectForKey:NSForegroundColorAttributeName];
    }
    return textColor;
}

- (void)setTextColor:(NSColor *)textColor
{
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                            initWithAttributedString:[self attributedTitle]];
    int len = (int)[attrTitle length];
    NSRange range = NSMakeRange(0, len);
    [attrTitle addAttribute:NSForegroundColorAttributeName
                      value:textColor
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    [attrTitle release];
}

@end
