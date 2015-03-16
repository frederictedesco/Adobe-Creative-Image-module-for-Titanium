//
//  AdobePhotoEditorController.m
//  Photo Editor Adobe
//
//  Created by Lionel Schinckus on 26/02/15.
//
//

#import "AdobePhotoEditorController.h"
#import "ComDcodePhotoeditorAdobeModule.h"
#import <TiApp.h>

@interface AdobePhotoEditorController ()

@property (nonatomic, retain) AdobeUXImageEditorViewController *editorController;

@end

@implementation AdobePhotoEditorController

- (instancetype)initFromActionSheet:(UIActionSheet*)actionSheet
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    self.editorController = [[AdobeUXImageEditorViewController alloc] initWithImage:imageToEdit];
    _editorController.delegate = self;
    [[TiApp app] showModalController:_editorController animated:YES];
}

#pragma mark - Delegate

#define view_parentViewController(_view_) (([_view_ parentViewController] != nil || ![_view_ respondsToSelector:@selector(presentingViewController)]) ? [_view_ parentViewController] : [_view_ presentingViewController])


- (void)photoEditor:(AdobeUXImageEditorViewController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    [[NSNotificationCenter defaultCenter] postNotificationName:@"avEditorFinished" object:image];
    
    [self dismissModalStack:editor];
}

- (void)photoEditorCanceled:(AdobeUXImageEditorViewController *)editor
{
    // Handle cancellation here
    [[NSNotificationCenter defaultCenter] postNotificationName:@"avEditorCancel" object:nil];
    
    if([editor respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [[TiApp app] hideModalController:editor animated:NO];
    } else {
        NSLog(@"[ERROR] Oooops, what system is this ?!!! - should never see this !");
    }
}

-(void)dismissModalStack:(UIViewController*)masterVC {
    UIViewController *vc = masterVC.presentingViewController;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:NULL];
}

@end
