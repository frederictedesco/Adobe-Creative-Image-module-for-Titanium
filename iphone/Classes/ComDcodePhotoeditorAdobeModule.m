/**
 * Photo Editor Adobe
 *
 * Created by Your Name
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "ComDcodePhotoeditorAdobeModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"
#import <AdobeCreativeSDKFoundation/AdobeCreativeSDKFoundation.h>
#import "ComDcodePhotoeditorAdobeActionSheetView.h"

static NSString * const kAFAviaryAPIKey = @"3d8601432f3e4c65821c610c134e1457";
static NSString * const kAFAviarySecret = @"b9a7831e-340c-471b-82f7-2dbe08667c67";


@implementation ComDcodePhotoeditorAdobeModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"5191636b-cc39-4b9d-b0ec-771f9f70b2cc";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.dcode.photoeditor.adobe";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AdobeUXAuthManager sharedManager] setAuthenticationParametersWithClientID:kAFAviaryAPIKey withClientSecret:kAFAviarySecret];
    });
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}


+ (NSDictionary *)convertResultDic:(UIImage *)result
{
    TiBlob *blob = [[[TiBlob alloc]initWithImage:result]autorelease];
    NSDictionary *obj = [NSDictionary dictionaryWithObjectsAndKeys:blob,@"image",nil];
    return obj;
}

-(UIImage *)convertToUIImage:(id)param
{
    UIImage *source = nil;
    if ([param isKindOfClass:[TiBlob class]]){
        source = [param image];
    }else if ([param isKindOfClass:[UIImage class]]){
        source = param;
    }
    return source;
}

-(void)newEditorController:(UIImage *)source
{
    
    editorController = [[AFPhotoEditorController alloc] initWithImage:source];
    [editorController setDelegate:self];
    
    [[TiApp app] showModalController: editorController animated: NO];
}

-(NSMutableArray *)convertToRealToolsKey:(NSArray *)toolsKey
{
    NSMutableArray *tools = [[[NSMutableArray alloc]initWithCapacity:[toolsKey count]]autorelease];
    for (NSString *key in toolsKey){
        NSString *lowcase = [key lowercaseString];
        NSString *realKey = [lowcase substringFromIndex:3];
        if ([realKey isEqualToString: @"adjustments"]) {
            realKey = @"adjust";
        }
        [tools addObject:realKey];
    }
    return tools;
}

-(void)newEditorController:(UIImage *)source withTools:(NSArray *)toolKey
{
    
    NSArray *tools = [self convertToRealToolsKey:toolKey];
    editorController = [[AFPhotoEditorController alloc]
                        initWithImage:source
                        ];
    [AdobeImageEditorCustomization setToolOrder:tools];
    
    [editorController setDelegate:self];
    
    [[TiApp app] showModalController: editorController animated: NO];
}

#pragma Public APIs

-(void)newImageEditor
{
    ENSURE_UI_THREAD_0_ARGS
    
    NSLog(@"[INFO] newImageEditor Li",self);
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
    
    [[[[ComDcodePhotoeditorAdobeActionSheetView alloc] init] autorelease] show:nil];
}

-(void)newImageEditor:(id)params
{
    ENSURE_UI_THREAD_1_ARG(params);
    ENSURE_SINGLE_ARG(params, NSDictionary);
    
    NSLog(@"[INFO] Test Li",self);
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
    
    UIImage *source = [self convertToUIImage:[params objectForKey:@"image"]];
    NSArray *tools = [NSArray arrayWithArray:(NSArray *)[params objectForKey:@"tools"]];
    [self newEditorController:source withTools:tools];
}


#define view_parentViewController(_view_) (([_view_ parentViewController] != nil || ![_view_ respondsToSelector:@selector(presentingViewController)]) ? [_view_ parentViewController] : [_view_ presentingViewController])
// This is called when editcontroller done.
// Post edited image by notification.
-(void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    NSLog(@"avEditorFinished XCODE");
    [self fireEvent:@"avEditorFinished" withObject:[ComDcodePhotoeditorAdobeModule convertResultDic:image]];
    
    if([view_parentViewController(editor) respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        [editor.presentingViewController dismissViewControllerAnimated:(NO) completion:nil];
    else if([view_parentViewController(editor) respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
        [view_parentViewController(editor) dismissViewControllerAnimated:NO completion:nil];
    else
        NSLog(@"Oooops, what system is this ?!!! - should never see this !");
    
    [editor release];
}

// This is called when editcontroller cancel.
-(void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    
    
    NSLog(@"avEditorCancel XCODE");
    [self fireEvent:@"avEditorCancel" withObject:nil];
    
    if([view_parentViewController(editor) respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        [editor.presentingViewController dismissViewControllerAnimated:(NO) completion:nil];
    else if([view_parentViewController(editor) respondsToSelector:@selector(dismissModalViewControllerAnimated:)])
        [view_parentViewController(editor) dismissViewControllerAnimated:NO completion:nil];
    else
        NSLog(@"Oooops, what system is this ?!!! - should never see this !");
    
    [editor release];
}


@end
