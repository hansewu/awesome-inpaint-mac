//
//  PIInpaint.m
//  Photo Inpaint
//
//  Created by tangj on 15/6/30.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//
#include "criminisi_inpainter.h"
#include <opencv2/opencv.hpp>
#include "NSImage+OpenCV.h"
#import "PIInpaint.h"
NSString *const PIInpaintProgressNotification = @"PIInpaintProgressNotification";
struct ImageInfo {
    cv::Mat image;
    cv::Mat targetMask;
    cv::Mat sourceMask;
    cv::Mat displayImage;
    bool leftMouseDown;
    bool rightMouseDown;
    int patchSize;
};
@implementation PIInpaint
{
    Inpaint::CriminisiInpainter _inpainter;
    ImageInfo _imageInfo;
}
@synthesize delegate;
+ (PIInpaint *)shareInpaint
{
    static PIInpaint *inpaint = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        inpaint = [[PIInpaint alloc] init];
    });
    return inpaint;
}

- (id)init
{
    self = [super init];
    if (self) {
        _imageInfo.patchSize = 10;
    }
    return self;
}

- (void)setPatchSize:(int)patchSize
{
    if (_imageInfo.patchSize != patchSize) {
        _imageInfo.patchSize = patchSize;
    }
}

- (void)setSourceImageWith:(NSURL *)url
{
    _imageInfo.image.release();
    _imageInfo.image = cv::imread([[url path] UTF8String]);  //读取后变为3通道
    _imageInfo.displayImage = _imageInfo.image.clone();
}

- (void)setSourceImage:(NSImage *)image
{
    if (image) {
        cv::Mat source = [image CVMat];
        cv::cvtColor(source, _imageInfo.image, cv::COLOR_RGBA2RGB);  //将图片转为3通道
    }
}

- (void)setTargetMask:(NSImage *)targetMask
{
    cv::Mat matTargetMask = targetMask.CVMat;
    _imageInfo.targetMask.release();
    _imageInfo.targetMask = matTargetMask.clone();
}

- (void)createTargetMaskWith:(NSSize)size
{
    _imageInfo.targetMask.release();
    _imageInfo.targetMask.create(cv::Size(size.width,size.height), CV_8UC1);
    _imageInfo.targetMask.setTo(0);
}

- (void)configTargetMaskWithType:(configMaskType)type withPoint:(NSPoint)point
{
    cv::Mat &mask = _imageInfo.targetMask;
    switch (type) {
        case configMaskType_circle:
        {
            cv::circle(mask, cv::Point(point.x, point.y), self.radius, cv::Scalar(255), -1);;
        }
            break;
        case configMaskType_rectangle:
        {
            cv::rectangle(mask, cv::Point(point.x-self.radius,point.y-self.radius), cv::Point(point.x+self.radius,point.y+self.radius), cv::Scalar(255),-1);
        }
            break;
        default:
            break;
    }
//    cv::imshow("dd", mask);
}

- (void)startInpaint
{
    __block BOOL isInpainting = YES;
    if ([self readyToInpaint]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(imageInpaintWillStart:)]) {
                [self.delegate imageInpaintWillStart:self];
            }
            int progress = 0;
            while (isInpainting) {
                if (_inpainter.hasMoreSteps()) {
                    _inpainter.step();
                    if (progress >= 98) {
                        progress = 98;
                    }else{
                        progress ++;
                    }
    
                    [[NSNotificationCenter defaultCenter] postNotificationName:PIInpaintProgressNotification object:[NSNumber numberWithInt:progress]];
                } else {
                    _imageInfo.image = _inpainter.image().clone();
                    _imageInfo.targetMask = _inpainter.targetRegion().clone();
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(imageInpaintDidEnd:withFinalImage:)]) {
                        NSImage *image = [NSImage imageWithCVMat:_imageInfo.image];
                        [self.delegate imageInpaintDidEnd:self withFinalImage:image];
                    }
                    isInpainting = NO;
                }
            }
        });
    }
}

- (BOOL)readyToInpaint
{
    _inpainter.setSourceImage(_imageInfo.image);
    cv::Mat flipTargetMask;
    cv::flip(_imageInfo.targetMask, flipTargetMask, 0);
    _inpainter.setTargetMask(flipTargetMask);
//    _imageInfo.displayImage.setTo(cv::Scalar(0,250,0),flipTargetMask);
    _inpainter.setSourceMask(_imageInfo.sourceMask);
    _inpainter.setPatchSize(_imageInfo.patchSize);
    _inpainter.initialize();
    return YES;
}

- (void)dealloc
{
    [super dealloc];
    _imageInfo.image.release();
    _imageInfo.sourceMask.release();
    _imageInfo.targetMask.release();
    _imageInfo.displayImage.release();
}
@end
