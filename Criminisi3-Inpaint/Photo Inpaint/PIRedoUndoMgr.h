//
//  PIRedoUndoMgr.h
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/7/1.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    PIRedoUndoType_redo,
    PIRedoUndoType_undo,
}PIRedoUndoType;
@interface PIRedoUndoMgr : NSObject
@property (readonly) BOOL canRedo;
@property (readonly) BOOL canUndo;
+ (PIRedoUndoMgr *)shareRedoUndoMgr;
- (NSImage *)getImageBy:(PIRedoUndoType)type;
- (void)addImage:(NSImage *)image;
- (void)clear;
@end
