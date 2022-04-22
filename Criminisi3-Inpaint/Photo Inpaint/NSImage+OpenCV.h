//
//  NSImage+OpenCV.h
//  hh
//
//  Created by tangj on 15/6/15.
//  Copyright (c) 2015年 tangj. All rights reserved.
//
#include <opencv2/highgui.hpp>
#import <Cocoa/Cocoa.h>
//#import <opencv2/opencv.hpp>

@interface NSImage (OpenCV)
+(NSImage*)imageWithCVMat:(const cv::Mat&)cvMat;
-(id)initWithCVMat:(const cv::Mat&)cvMat;

@property(nonatomic, readonly) cv::Mat CVMat;
@property(nonatomic, readonly) cv::Mat CVGrayscaleMat;
@end
