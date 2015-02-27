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

- (instancetype)initFromActionSheet:(ComDcodePhotoeditorAdobeActionSheet*)actionSheet
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
    AdobeUXImageEditorViewController *editorController = [[AdobeUXImageEditorViewController alloc] initWithImage:imageToEdit];
    editorController.delegate = self;
    [[TiApp app] showModalController: editorController animated: NO];
}

#pragma mark - Delegate

- (void)photoEditor:(AdobeUXImageEditorViewController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    NSLog(@"Image : %@",image);
    NSLog(@"avEditorFinished XCODE");
    [_actionSheet.proxy fireEvent:@"avEditorFinished" withObject:[ComDcodePhotoeditorAdobeModule convertResultDic:image]];
}

- (void)photoEditorCanceled:(AdobeUXImageEditorViewController *)editor
{
    // Handle cancellation here
    NSLog(@"You have cancelled photo editing");
    NSLog(@"avEditorCancel XCODE");
    [_actionSheet.proxy fireEvent:@"avEditorCancel" withObject:nil];
}

@end
