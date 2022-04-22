//
//  LRHMSideBar.h
//  sidebar
//
//  Created by tangj on 15/6/19.
//  Copyright (c) 2015年 tangj. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LRHMSideBarItem.h"
@class LRHMSideBar;
@protocol LRHMSideBarDatasource<NSObject>
@optional
- (NSInteger)numberOfColumnsOfInSideBar:(LRHMSideBar *)sideBar;
- (NSInteger)numberOfItemsAtColumn:(NSInteger)column InSideBar:(LRHMSideBar *)sideBar;
@optional
- (NSImage *)iconOfItemAt:(NSInteger)index InSideBar:(LRHMSideBar *)sideBar;
- (NSString *)titleOfItemAt:(NSInteger)index InSideBar:(LRHMSideBar *)sideBar;
@end

@protocol LRHMSideBarDelegate <NSObject>
- (void)sideBar:(LRHMSideBar *)siderBar mouseDownInItem:(LRHMSideBarItem *)sideBarItem;
- (void)sideBar:(LRHMSideBar *)siderBar mouseUpInItem:(LRHMSideBarItem *)sideBarItem;

@end
@interface LRHMSideBar : NSView
{
    
    IBOutlet LRHMSideBarItem *_brushBarItem;
    IBOutlet LRHMSideBarItem *_redoBarItem;
    IBOutlet LRHMSideBarItem *_undoBarItem;
    IBOutlet LRHMSideBarItem *_saveBarItem;
}
@property (assign) IBOutlet id<LRHMSideBarDatasource> datasource;
@property (assign) IBOutlet id<LRHMSideBarDelegate> delegate;
@end
