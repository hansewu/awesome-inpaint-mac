//
//  PIInpaint.h
//  Photo Inpaint
//
//  Created by tangj on 15/6/30.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//



#import <Foundation/Foundation.h>
extern NSString *const PIInpaintProgressNotification;
typedef enum{
    configMaskType_circle,
    configMaskType_rectangle,
}configMaskType;
@class PIInpaint;
@protocol PIInpaintDelegate<NSObject>
- (void)imageInpaintDidEnd:(PIInpaint *)inpaint withFinalImage:(NSImage *)image;
- (void)imageInpaintWillStart:(PIInpaint *)inpaint;
@end

@interface PIInpaint : NSObject
{
  
}
@property (assign) id<PIInpaintDelegate>delegate;
@property (assign) int radius;
+ (PIInpaint *)shareInpaint;
- (void)createTargetMaskWith:(NSSize)size;
- (void)setPatchSize:(int)patchSize;
- (void)setSourceImageWith:(NSURL *)url;
- (void)setSourceImage:(NSImage *)image;
- (void)setTargetMask:(NSImage *)targetMask;
- (void)configTargetMaskWithType:(configMaskType)type withPoint:(NSPoint)point;
- (void)startInpaint;


@end
