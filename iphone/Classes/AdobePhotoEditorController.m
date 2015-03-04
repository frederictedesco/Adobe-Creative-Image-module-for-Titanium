//
//  AdobePhotoEditorController.m
//  Photo Editor Adobe
//
//  Created by Lionel Schinckus on 26/02/15.
//
//

#import "AdobePhotoEditorController.h"
#import "ComDcodePhotoeditorAdobeActionSheetView.h"
#import "ComDcodePhotoeditorAdobeModule.h"
#import <TiApp.h>

@interface AdobePhotoEditorController ()

@property (nonatomic, retain) AdobeUXImageEditorViewController *editorController;

@end

@implementation AdobePhotoEditorController

- (instancetype)initFromActionSheet:(ComDcodePhotoeditorAdobeActionSheetView*)actionSheet
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    NSLog(@"displayEditorForImage");
    self.editorController = [[AdobeUXImageEditorViewController alloc] initWithImage:imageToEdit];
    _editorController.delegate = self;
    [[TiApp app] showModalController:_editorController animated:YES];
}

#pragma mark - Delegate

#define view_parentViewController(_view_) (([_view_ parentViewController] != nil || ![_view_ respondsToSelector:@selector(presentingViewController)]) ? [_view_ parentViewController] : [_view_ presentingViewController])


- (void)photoEditor:(AdobeUXImageEditorViewController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    NSLog(@"Image : %@",image);
    NSLog(@"[INFO] avEditorFinished");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"avEditorFinished" object:image];

    [[TiApp app] hideModalController:editor animated:YES];
    
    if([view_parentViewController(editor) respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        NSLog(@"[INFO] Dismiss View using dismissViewControllerAnimated %@",editor.presentingViewController);
        [editor.presentingViewController dismissViewControllerAnimated:(NO) completion:nil];
    } else if([view_parentViewController(editor) respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        NSLog(@"[INFO] Dismiss View using dismissModalView %@",view_parentViewController(editor));
        [view_parentViewController(editor) dismissViewControllerAnimated:NO completion:nil];
    } else {
        NSLog(@"Oooops, what system is this ?!!! - should never see this !");
    }
}

- (void)photoEditorCanceled:(AdobeUXImageEditorViewController *)editor
{
    // Handle cancellation here
    NSLog(@"You have cancelled photo editing");
    NSLog(@"avEditorCancel XCODE");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"avEditorCancel" object:nil];
    
    [[TiApp app] hideModalController:editor animated:YES];
    
    if([view_parentViewController(editor) respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        NSLog(@"[INFO] Dismiss View using dismissViewControllerAnimated %@",editor.presentingViewController);
        [editor.presentingViewController dismissViewControllerAnimated:(NO) completion:nil];
    } else if([view_parentViewController(editor) respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        NSLog(@"[INFO] Dismiss View using dismissModalView %@",view_parentViewController(editor));
        [view_parentViewController(editor) dismissViewControllerAnimated:NO completion:nil];
    } else {
        NSLog(@"Oooops, what system is this ?!!! - should never see this !");
    }
}

@end
