//
//  PIProgressViewCtrl.m
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/7/1.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "PIProgressViewCtrl.h"

@interface PIProgressViewCtrl ()
{
    IBOutlet NSProgressIndicator *_progressIndicator;
}
@property (assign) NSString *progressStr;
@end

@implementation PIProgressViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [_progressIndicator startAnimation:nil];
}


- (void)setProgress:(int)progress
{
    self.progressStr = [NSString stringWithFormat:@"%d%@",progress,@"%"];
}
@end
