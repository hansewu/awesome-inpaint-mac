//
//  PCOutImageFormatAccessoryView.m
//  PhotoStudio
//
//  Created by Lion Mac OS on 9/25/13.
//  Copyright (c) 2013 Lion Mac OS. All rights reserved.
//

#import "PCOutImageFormatCtrl.h"


static NSString * const PCDefaultFilename=@"Untitled";
@interface PCOutImageFormatCtrl ()

@end

@implementation PCOutImageFormatCtrl
{
    NSString * _chooseFormat;
    NSString * _outFilename;
}

@synthesize supportFormats;
@synthesize chooseFormat=_chooseFormat;
@synthesize outFilename=_outFilename;
 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        PCOutImageFormat *imageFormats = [PCOutImageFormat outImageFormat];
        _chooseFormat = [imageFormats formatExtToDescription:[imageFormats defaultOutImageFormatExt]];
        _outFilename = PCDefaultFilename;
    }
    
    return self;
}

-(NSArray *)supportFormats
{
    return [[PCOutImageFormat outImageFormat] supportFormatDescription];
}

-(NSString *)outFilename
{
    [[self.view window] makeFirstResponder:nil];
    if(_outFilename == nil){
        return PCDefaultFilename;
    }else{
        return _outFilename;
    }
}

-(void)dealloc
{
    if (_chooseFormat) {
        [_chooseFormat release];
        _chooseFormat = nil;
    }
    
    if (_outFilename) {
        [_outFilename release];
        _outFilename = nil;
    }
    [super dealloc];
}
@end
