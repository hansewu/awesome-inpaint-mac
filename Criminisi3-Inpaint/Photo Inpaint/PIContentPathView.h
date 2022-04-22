//
//  PIContentPathView.h
//  Photo Inpaint
//
//  Created by tangj on 15/7/1.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PIContentPathView : NSView
@property (retain) NSBezierPath *path;
- (void)clearPath;
@end
