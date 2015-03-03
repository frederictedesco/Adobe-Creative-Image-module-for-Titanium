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

@end

@implementation AdobePhotoEditorController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - Delegate

- (void)photoEditor:(AdobeUXImageEditorViewController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    NSLog(@"Image : %@",image);
    NSLog(@"[INFO] avEditorFinished");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"avEditorFinished" object:image];

    [[TiApp app] hideModalController:self.navigationController animated:YES];
}

- (void)photoEditorCanceled:(AdobeUXImageEditorViewController *)editor
{
    // Handle cancellation here
    NSLog(@"You have cancelled photo editing");
    NSLog(@"avEditorCancel XCODE");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"avEditorCancel" object:nil];
    [[TiApp app] hideModalController:self.navigationController animated:YES];
}

@end
