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

@property (nonatomic, retain) ComDcodePhotoeditorAdobeActionSheetView* actionSheet;

@end

@implementation AdobePhotoEditorController

- (instancetype)initFromActionSheet:(ComDcodePhotoeditorAdobeActionSheetView*)actionSheet
{
    self = [super init];
    if (self) {
        self.actionSheet = actionSheet;
    }
    return self;
}

- (void)dealloc
{
    [_actionSheet release];
    [super dealloc];
}

- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    NSLog(@"displayEditorForImage");
    AdobeUXImageEditorViewController *editorController = [[AdobeUXImageEditorViewController alloc] initWithImage:imageToEdit];
    editorController.delegate = self;
    [[TiApp app] showModalController: editorController animated:YES];
}

#pragma mark - Delegate

- (void)photoEditor:(AdobeUXImageEditorViewController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    NSLog(@"Image : %@",image);
    NSLog(@"[INFO] avEditorFinished %@",_actionSheet.proxy);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"avEditorFinished" object:image];

    [[TiApp app] hideModalController:editor animated:YES];
}

- (void)photoEditorCanceled:(AdobeUXImageEditorViewController *)editor
{
    // Handle cancellation here
    NSLog(@"You have cancelled photo editing");
    NSLog(@"avEditorCancel XCODE");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"avEditorCancel" object:nil];
    [[TiApp app] hideModalController:editor animated:YES];
}

@end
