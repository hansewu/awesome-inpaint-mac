//
//  PIDataVIewCtrl.m
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/6/26.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//
#import "PIImageDataMgr.h"
#import "PIDataViewCtrl.h"
#import "LRHMPopupBorderView.h"

@interface PIDataViewCtrl ()
{
}
@property (readwrite,copy) NSString *fileName;
@property (readwrite,copy) NSString *fileType;
@property (readwrite,copy) NSString *depth;
@property (readwrite,copy) NSString *dpiWidth;
@property (readwrite,copy) NSString *dpiHeight;
@property (readwrite,copy) NSString *orientation;
@property (readwrite,copy) NSString *pixelWidth;
@property (readwrite,copy) NSString *pixelHeight;
@property (readwrite,copy) NSString *profileName;
@property (readwrite,copy) NSString *colorModal;
@property (readwrite,copy) NSString *focalLength;
@property (readwrite,copy) NSString *isoSpeedRating;
@property (readwrite,copy) NSString *makeDevice;
@property (readwrite,copy) NSString *deviceModel;
@property (readwrite,copy) NSString *flash;
@property (readwrite,copy) NSString *exposureBias;
@property (readwrite,copy) NSString *whiteBalance;
@property (readwrite,copy) NSString *dateOriginal;
@property (readwrite,copy) NSString *dateDigitized;
@end

@implementation PIDataViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [(LRHMPopupBorderView *)self.view setPopupWndPosition:popupPosition_bottom];
    [self initDefualtData];
}

- (void)initDefualtData
{
    self.fileName = @"";
    self.fileType = @"";
    self.depth = @"";
    self.dpiHeight = @"";
    self.dpiWidth = @"";
    self.orientation = @"";
    self.pixelWidth = @"";
    self.pixelHeight = @"";
    self.profileName = @"";
    self.colorModal = @"";
    self.focalLength = @"";
    self.isoSpeedRating = @"";
    self.makeDevice = @"";
    self.deviceModel = @"";
    self.flash = @"";
    self.exposureBias = @"";
    self.whiteBalance = @"";
    self.dateOriginal = @"";
    self.dateDigitized = @"";
}

- (void)updateData
{
    NSDictionary *dic = [[PIImageDataMgr shareDataMgr] metaData];
    if (dic) {
        self.fileName = [[PIImageDataMgr shareDataMgr] fileName];
        self.fileType = [[PIImageDataMgr shareDataMgr] fileType];
        self.depth = [dic objectForKey:(NSString *)kCGImagePropertyDepth];
        self.dpiWidth = [dic objectForKey:(NSString *)kCGImagePropertyDPIWidth];
        self.dpiHeight = [dic objectForKey:(NSString *)kCGImagePropertyDPIHeight];
        self.orientation = [dic objectForKey:(NSString *)kCGImagePropertyOrientation];
        self.pixelWidth = [dic objectForKey:(NSString *)kCGImagePropertyPixelWidth];
        self.pixelHeight = [dic objectForKey:(NSString *)kCGImagePropertyPixelHeight];
        self.profileName = [dic objectForKey:(NSString *)kCGImagePropertyProfileName];
        self.colorModal = [dic objectForKey:(NSString *)kCGImagePropertyColorModel];
        
        NSDictionary *exif = [dic objectForKey:(NSString *)kCGImagePropertyExifDictionary];
        if (exif) {
            self.focalLength = [exif objectForKey:(NSString *)kCGImagePropertyExifFocalLength];
            id rate = [exif objectForKey:(NSString *)kCGImagePropertyExifISOSpeedRatings];
            self.isoSpeedRating = rate ? [rate objectAtIndex:0] : @"";
            self.flash = [exif objectForKey:(NSString *)kCGImagePropertyExifFlash];
            self.exposureBias = [exif objectForKey:(NSString *)kCGImagePropertyExifExposureBiasValue];
            self.whiteBalance = [exif objectForKey:(NSString *)kCGImagePropertyExifWhiteBalance];
            self.dateOriginal = [exif objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
            self.dateDigitized = [exif objectForKey:(NSString *)kCGImagePropertyExifDateTimeDigitized];
        }
        
        NSDictionary *tiff = [dic objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
        if (tiff) {
            self.makeDevice = [tiff objectForKey:(NSString *)kCGImagePropertyTIFFMake];
            self.deviceModel = [tiff objectForKey:(NSString *)kCGImagePropertyTIFFModel];
            
        }
    }
 
    
}

- (void)dealloc
{
    self.fileName = nil;
    self.fileType = nil;
    self.depth = nil;
    self.dpiHeight = nil;
    self.dpiWidth = nil;
    self.orientation = nil;
    self.pixelWidth = nil;
    self.pixelHeight = nil;
    self.profileName = nil;
    self.colorModal = nil;
    self.focalLength = nil;
    self.isoSpeedRating = nil;
    self.makeDevice = nil;
    self.deviceModel = nil;
    self.flash = nil;
    self.exposureBias = nil;
    self.whiteBalance = nil;
    self.dateOriginal = nil;
    self.dateDigitized = nil;
    [super dealloc];
}
@end
