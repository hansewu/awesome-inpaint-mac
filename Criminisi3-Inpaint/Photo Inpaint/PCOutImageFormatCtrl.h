//
//  PCOutImageFormatAccessoryView.h
//  PhotoStudio
//
//  Created by Lion Mac OS on 9/25/13.
//  Copyright (c) 2013 Lion Mac OS. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PCOutImageFormat.h"
@interface PCOutImageFormatCtrl : NSViewController

@property(readonly) NSArray * supportFormats;
@property(readonly) NSString * chooseFormat;
@property(readwrite, nonatomic,retain) NSString * outFilename;
@end
