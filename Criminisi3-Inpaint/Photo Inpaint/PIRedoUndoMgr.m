//
//  PIRedoUndoMgr.m
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/7/1.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import "PIRedoUndoMgr.h"
@interface PIRedoUndoMgr()
{
}
@property (assign) NSInteger currentImageIndex;
@end
@implementation PIRedoUndoMgr
{
    NSMutableArray *_imageMgr;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.currentImageIndex = -1;
    }
    return self;
}

+ (PIRedoUndoMgr *)shareRedoUndoMgr
{
    static dispatch_once_t onceToken = 0;
    static PIRedoUndoMgr *shareMgr = nil;
    dispatch_once(&onceToken, ^{
        shareMgr = [[PIRedoUndoMgr alloc] init];
    });
    return shareMgr;
}

- (void)ensureCreateImageMgr
{
    if (!_imageMgr) {
        _imageMgr = [[NSMutableArray alloc] init];
    }
}

- (NSImage *)getImageBy:(PIRedoUndoType)type
{
    switch (type) {
        case PIRedoUndoType_redo:
        {
            return [self nextImage];
        }
            break;
        case PIRedoUndoType_undo:
        {
            return [self preImage];
        }
            break;
        default:
            break;
    }
    return nil;
}


- (NSImage *)preImage
{
    self.currentImageIndex -= 1;
    return [self imageAt:self.currentImageIndex];
}

- (NSImage *)nextImage
{
    self.currentImageIndex += 1;
    return [self imageAt:self.currentImageIndex];
}

- (NSImage *)imageAt:(NSInteger)index
{
    if (index >= 0 && index < [_imageMgr count]) {
        return [_imageMgr objectAtIndex:index];
    }
    return nil;
}

- (BOOL)canRedo
{
    if (self.currentImageIndex >= [_imageMgr count]-1) {
        return NO;
    }
    return YES;
}

- (BOOL)canUndo
{
    if (self.currentImageIndex <= 0) {
        self.currentImageIndex = 0;
        return NO;
    }
    return YES;
}

- (void)addImage:(NSImage *)image
{
    [self ensureCreateImageMgr];
    [_imageMgr addObject:image];
    self.currentImageIndex = [_imageMgr count]-1;
}

- (void)clear
{
    if (_imageMgr) {
        [_imageMgr removeAllObjects];
        _imageMgr = nil;
    }
}
@end
