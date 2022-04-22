//
//  AppDelegate.m
//  Photo Inpaint
//
//  Created by 蓝锐黑梦 on 15/6/17.
//  Copyright (c) 2015年 lanruiheimeng. All rights reserved.
//
#import "NSImage+OpenCV.h"
#import "PIInpaint.h"
#import "PIImageDataMgr.h"
#import "AppDelegate.h"
#import "LRHMSideBar.h"
#import "PIContentView.h"
#import "PIDataViewCtrl.h"
#import "ATPopupWindow.h"
#import "PIBottomView.h"
#import "PIContentPathView.h"
#import "PCOutImageFormatCtrl.h"
#import "PIProgressViewCtrl.h"
#import "PIRedoUndoMgr.h"
#import "NSButton+TextColor.h"
@interface AppDelegate ()<NSAnimationDelegate,PIInpaintDelegate>
{
    IBOutlet NSView *_brushView;
    IBOutlet PIContentView *_contentView;
    IBOutlet NSView *_sideBar;
    IBOutlet NSButton *_brushBtn;
    IBOutlet PIBottomView  *_bottomView;
    IBOutlet PIContentPathView *_contentPathView;

    PIProgressViewCtrl *_progressViewCtrl;
    PIDataViewCtrl *_imageDataViewCtrl;
    ATPopupWindow  *_popupWindow;
    PCOutImageFormatCtrl *_outImageFormatCtrl;
    
    IBOutlet NSButton  * _checkBtn;
}
@property IBOutlet NSWindow *window;
@property (assign) NSString *brushSizeStr;
@property (retain,nonatomic) NSImage *sourceImage;
@property (assign) configMaskType maskType;
@property (assign) int radius;
@property (assign) NSSize brushViewSize;
@property (assign) BOOL isHideToolBar;
@property (assign) NSInteger brushType;
@property (assign) BOOL isEnableStartAndMetaDataBtn;
@property (assign) BOOL isCanRedo;
@property (assign) BOOL isCanUndo;
@property (assign) BOOL isCanBrush;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    [self initSideBarItem];
//    [[PIImageDataMgr shareDataMgr] parseImageDataWith:[NSURL fileURLWithPath:@"/Users/lrhm/Desktop/image/lanbo.jpg"]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)awakeFromNib
{
    [self setDefaultBrushView];
    [[PIInpaint shareInpaint] setDelegate:self];
    self.radius = 5;
    self.isHideToolBar = NO;
    self.maskType = configMaskType_circle;
    self.isEnableStartAndMetaDataBtn = NO;
    [self configContentPathView];
    [self configProgressView];
    
    self.isCanRedo = NO;
    self.isCanUndo = NO;
    self.isCanBrush = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inpaintProgress:) name:PIInpaintProgressNotification object:nil];
    
    [_checkBtn setTextColor:[NSColor whiteColor]];
}

- (void)inpaintProgress:(NSNotification *)notification
{
    [_progressViewCtrl setProgress:[[notification object] intValue]];
}

- (void)ensureCreateProgressViewCtrl
{
    if (!_progressViewCtrl) {
        _progressViewCtrl = [[PIProgressViewCtrl alloc] initWithNibName:@"PIProgressViewCtrl" bundle:nil];
    }
}

- (void)configProgressView
{
    [self ensureCreateProgressViewCtrl];
    if (_progressViewCtrl) {
        [_contentView addSubview:_progressViewCtrl.view positioned:NSWindowAbove relativeTo:_contentPathView];
        [_progressViewCtrl.view setFrame:[_contentPathView bounds]];
        [_progressViewCtrl.view setHidden:YES];
    }
}

- (void)configContentPathView
{
    if (_contentView) {
        [_contentPathView setFrame:[_contentView bounds]];
        [_contentView addSubview:_contentPathView];
    }
}

- (void)setDefaultBrushView
{
    [_contentView addSubview:_brushView];
    self.brushViewSize = _brushView.frame.size;
    [_brushView setFrame:[self collapseFrame]];
    [_brushView setHidden:YES];
    
    self.sourceImage = [NSImage imageNamed:@"leadPhoto"];
}

- (PIDataViewCtrl *)imageDataViewCtrl
{
    if (!_imageDataViewCtrl) {
        _imageDataViewCtrl = [[PIDataViewCtrl alloc] initWithNibName:@"PIDataViewCtrl" bundle:nil];
    }
    return _imageDataViewCtrl;
}

- (NSRect)expandFrame
{
    NSRect frame = NSZeroRect;
    NSRect brushItemFrame = [_brushBtn frame];
    NSRect sideBarFrame = [_sideBar frame];
    frame.origin.x = NSMaxX(sideBarFrame);
    frame.origin.y = NSMinY(sideBarFrame) + NSMinY(brushItemFrame);
    frame.size = self.brushViewSize;
    return frame;
}

- (NSRect)collapseFrame
{
    NSRect frame = NSZeroRect;
    NSRect brushItemFrame = [_brushBtn frame];
    NSRect sideBarFrame = [_sideBar frame];
    
    frame.origin.y = NSMinY(sideBarFrame) + NSMinY(brushItemFrame);
    frame.origin.x = NSMinX(sideBarFrame) + NSMinX(brushItemFrame);
    frame.size = brushItemFrame.size;
    return frame;
}

- (void)setBrushType:(NSInteger)brushType
{
    self.maskType = (configMaskType)brushType;
}

- (NSInteger)brushType
{
    return self.maskType;
}
#pragma mark action
- (IBAction)toolBarAction:(id)sender
{
    NSString *identifier = [sender identifier];
    if ([identifier isEqualToString:@"StartInpaint"]) {
        [[PIInpaint shareInpaint] startInpaint];
    }else if([identifier isEqualToString:@"BrushTool"]){
        [self openOrCloseBrushToolBar];
    }else if([identifier isEqualToString:@"Undo"]){
        self.sourceImage = [[PIRedoUndoMgr shareRedoUndoMgr] getImageBy:PIRedoUndoType_undo];
        [[PIInpaint shareInpaint] createTargetMaskWith:self.sourceImage.size];
        [[PIInpaint shareInpaint] setSourceImage:self.sourceImage];
        [_contentView setNeedsDisplay:YES];
    }else if([identifier isEqualToString:@"Redo"]){
        self.sourceImage = [[PIRedoUndoMgr shareRedoUndoMgr] getImageBy:PIRedoUndoType_redo];
        [[PIInpaint shareInpaint] createTargetMaskWith:self.sourceImage.size];
        [[PIInpaint shareInpaint] setSourceImage:self.sourceImage];
        [_contentView setNeedsDisplay:YES];
    }else if([identifier isEqualToString:@"Save"]){
        [self savePhoto:nil];
    }
    self.isCanUndo = [[PIRedoUndoMgr shareRedoUndoMgr] canUndo];
    self.isCanRedo = [[PIRedoUndoMgr shareRedoUndoMgr] canRedo];
}

- (void)openOrCloseBrushToolBar
{
    if ([_brushView isHidden]) {
        [_brushView setHidden:NO];
        [[_brushView animator] setFrame:[self expandFrame]];
    }else{
        [[_brushView animator] setFrame:[self collapseFrame]];
        [_brushView setHidden:YES];
    }
}

- (IBAction)showImageMetaData:(id)sender
{
    if ([[sender identifier] isEqualToString:@"showMetadata"]) {
        [sender setIdentifier:@"hideMetadata"];
        
        NSRect forScreenFrame = [self.window convertRectToScreen:[sender frame]];
        
        [self popUpMetaWindowAtScreenPosition:forScreenFrame];
    }else{
        [sender setIdentifier:@"showMetadata"];
        [_popupWindow close];
    }
}

- (IBAction)hideToolBarAction:(id)sender
{
    if ([(NSButton *)sender state] == NSOnState) {
        self.isHideToolBar = NO;
    }else{
        self.isHideToolBar = YES;
    }
}

- (IBAction)openFile:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[[PIImageDataMgr shareDataMgr] supportFormats]];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseDirectories:NO];
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            NSURL *url = [openPanel URL];
            [self dragImageUrl:url toContentView:_contentView];
        }
    }];
}
#pragma mark popup metaDataView
- (void)createPopupWindowIfNeed
{
    if (_popupWindow == nil) {
        NSRect viewFrame = [self imageDataViewCtrl].view.frame;
        // Create and setup our window
        _popupWindow = [[ATPopupWindow alloc] initWithContentRect:viewFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
        [_popupWindow setReleasedWhenClosed:NO];
        [_popupWindow setLevel:NSPopUpMenuWindowLevel];
        [_popupWindow setHasShadow:YES];
        [[_popupWindow contentView] addSubview:[self imageDataViewCtrl].view];
        [_popupWindow makeFirstResponder:[self imageDataViewCtrl].view];
        // Make the window have a clear color and be non-opaque for our pop-up animation
        [_popupWindow setBackgroundColor:[NSColor clearColor]];
        [_popupWindow setOpaque:NO];
    }
}

- (void)popUpMetaWindowAtScreenPosition:(NSRect)rect
{
    [self createPopupWindowIfNeed];
    [[self imageDataViewCtrl] updateData];
    NSPoint origin = rect.origin;
    NSRect windowFrame = [_popupWindow frame];
    origin.y = NSMaxY(rect);
    origin.x -= floor(NSWidth(windowFrame) / 2.0);
    origin.x += floor(NSWidth(rect) / 2.0);
    
    
    [_popupWindow setFrameOrigin:origin];
//    [_popupWindow orderFront:nil];
    [_popupWindow popup];
}

#pragma mark contentView delegate datasource
- (void)dragImageUrl:(NSURL *)url toContentView:(PIContentView *)contentView
{
    [[PIImageDataMgr shareDataMgr] parseImageDataWith:url];
    [[PIInpaint shareInpaint] createTargetMaskWith:[[PIImageDataMgr shareDataMgr] sourceImage].size];
    self.sourceImage = [[PIImageDataMgr shareDataMgr] sourceImage];
    [[PIInpaint shareInpaint] setSourceImage:self.sourceImage];
    self.isEnableStartAndMetaDataBtn = YES;
    
    
    [_contentView setNeedsDisplay:YES];
    [_contentPathView clearPath];
    
    [[PIRedoUndoMgr shareRedoUndoMgr] clear];
    [[PIRedoUndoMgr shareRedoUndoMgr] addImage:self.sourceImage];
    self.isCanBrush = YES;
}

- (void)setRadius:(int)radius
{
    [[PIInpaint shareInpaint] setRadius:radius];
    self.brushSizeStr = [NSString stringWithFormat:@"%d",radius];
}

- (int)radius
{
   return [[PIInpaint shareInpaint] radius];
}

- (void)mouseDragTo:(NSPoint)point inContentView:(PIContentView *)contentView
{
        [self configInpainerInfoWith:point];
   
}

- (void)mouseDownAt:(NSPoint)point inContentView:(PIContentView *)contentView
{
    
    [self configInpainerInfoWith:point];
}

- (void)configInpainerInfoWith:(NSPoint)point
{
    if (self.isCanBrush) {
        NSPoint pointToImage = [[PIAffineTransform shareAffineTransform] invertTransformRect:NSMakeRect(point.x, point.y, 0, 0)].origin;
        if (NSPointInRect(pointToImage, NSMakeRect(0, 0, self.sourceImage.size.width, self.sourceImage.size.height))) {
            [self configInpainterMaskWith:point];
            [self configContentDrawPathWith:point];
        }
    }
}

- (void)configInpainterMaskWith:(NSPoint)point
{
    [[PIInpaint shareInpaint] configTargetMaskWithType:self.maskType withPoint:[[PIAffineTransform shareAffineTransform] invertTransformRect:NSMakeRect(point.x, point.y, 0, 0)].origin];
}

- (void)configContentDrawPathWith:(NSPoint)point
{
    NSBezierPath *path = nil;
    NSRect rect = NSMakeRect(point.x-self.radius, point.y-self.radius, 2*self.radius, 2*self.radius);
    if (self.maskType == configMaskType_rectangle) {
        path = [NSBezierPath bezierPathWithRect:rect];
    }else{
        path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:self.radius yRadius:self.radius];
    }
    
    [_contentPathView setPath:path];
    
    [_contentPathView setNeedsDisplay:YES];
}

- (NSImage *)sourceImageOfContentView:(PIContentView *)contentView
{
    return self.sourceImage;
}

#pragma mark inpaint delegate
- (void)imageInpaintDidEnd:(PIInpaint *)inpaint withFinalImage:(NSImage *)image
{
    self.sourceImage = image;
    [[PIRedoUndoMgr shareRedoUndoMgr] addImage:self.sourceImage];
    self.isCanUndo = [[PIRedoUndoMgr shareRedoUndoMgr] canUndo];
    self.isCanRedo = [[PIRedoUndoMgr shareRedoUndoMgr] canRedo];
    [_progressViewCtrl setProgress:100];
    [_contentPathView clearPath];
    [_contentView setNeedsDisplay:YES];
    [_progressViewCtrl.view setHidden:YES];
}

- (void)imageInpaintWillStart:(PIInpaint *)inpaint
{
    [_progressViewCtrl.view setHidden:NO];
}

#pragma mark save photo
-(PCOutImageFormatCtrl *)outImageFormatCtrl
{
    if(_outImageFormatCtrl == nil){
        _outImageFormatCtrl = [[PCOutImageFormatCtrl alloc] initWithNibName:@"PCOutImageFormat" bundle:[NSBundle mainBundle]];
    }
    return _outImageFormatCtrl;
}

- (IBAction)savePhoto:(id)sender
{
    
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    [openPanel setAccessoryView:[self outImageFormatCtrl].view];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanCreateDirectories:YES];
    [openPanel setPrompt:@"Save"];
    [openPanel beginSheetModalForWindow:[NSApp keyWindow] completionHandler:^(NSInteger result) {
        
        if( result == NSFileHandlingPanelOKButton)
        {
            NSString *path = [[openPanel URL] path];
            NSString *finalOutfile = [path stringByAppendingPathComponent:[self outImageFormatCtrl].outFilename];
            NSString *fileExt = [[PCOutImageFormat outImageFormat] formatExtFromDescription:[self outImageFormatCtrl].chooseFormat];
            NSImage * timage = self.sourceImage;
            if([self saveImage:timage toDisk:[finalOutfile stringByAppendingPathExtension:fileExt]
                   usingFormat:[self outImageFormatCtrl].chooseFormat])
            {
                [self viewFileAtFinder:[finalOutfile stringByAppendingPathExtension:fileExt]];
            }else{
                //
            }
        }
    }];
}

-(void)viewFileAtFinder:(NSString *)fileName
{
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    NSURL *url = [NSURL fileURLWithPath:fileName];
    [workspace activateFileViewerSelectingURLs:[NSArray arrayWithObject:url]];
}


-(BOOL)saveImage:(NSImage *)img toDisk:(NSString *)savePath usingFormat:(NSString *)fmtDescription
{
    if (img != nil) {
        NSBitmapImageFileType type = [[PCOutImageFormat outImageFormat] formatTypeWithDescription:fmtDescription];
        NSImage *image = [self disposeImageData:img withType:type];
        NSData *imageData = [image TIFFRepresentation];
        NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
        NSData *outData = [imageRep representationUsingType:type
                                                 properties:nil];
        [outData writeToURL:[NSURL fileURLWithPath:savePath] atomically:YES];
        
        return YES;
    }
    return NO;
}



-(NSImage *)disposeImageData:(NSImage *)originImage withType:(NSBitmapImageFileType)bmpType
{
    NSImage *image = originImage;
    if (bmpType == NSBMPFileType || bmpType == NSJPEGFileType) {
        image = [[[NSImage alloc] initWithSize:originImage.size] autorelease];
        [image lockFocus];
        [[NSColor whiteColor] set];
        NSRectFill(NSMakeRect(0, 0, originImage.size.width, originImage.size.height));
        [originImage drawInRect:NSMakeRect(0, 0, originImage.size.width, originImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
        [image unlockFocus];
    }
    return image;
}
@end
