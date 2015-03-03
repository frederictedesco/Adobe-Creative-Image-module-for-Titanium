//
//  PhotoPickerController.m
//  Photo Editor Adobe
//
//  Created by Lionel Schinckus on 26/02/15.
//
//

#import "PhotoPickerController.h"
#import <TiApp.h>
#import <AdobeCreativeSDKImage/AdobeCreativeSDKImage.h>

@interface PhotoPickerController ()

@property (nonatomic, retain) AdobePhotoEditorController* photoEditorController;

@end

@implementation PhotoPickerController

- (instancetype)initWith:(AdobePhotoEditorController*)photoEditorController
{
    self = [super init];
    if (self) {
        self.photoEditorController = photoEditorController;
    }
    return self;
}

- (void)dealloc
{
    [_photoEditorController release];
    [super dealloc];
}

- (BOOL)startPhotoPickerViewController {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypePhotoLibrary] == NO))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    cameraUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = self;
    
    [[TiApp app] showModalController:cameraUI animated:YES];
    return YES;
}

#pragma mark - UIImagePickerViewController Delegate

// For responding to the user tapping Cancel.
- (void)imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    NSLog(@"imagePickerControllerDidCancel");
    [[TiApp app] hideModalController:picker animated:YES];
    [picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void)imagePickerController: (UIImagePickerController *) picker
didFinishPickingMediaWithInfo: (NSDictionary *) info {
    NSLog(@"imagePickerController didFinishPickingMediaWithInfo : %@", info);
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    
    editedImage = (UIImage *) [info objectForKey:
                               UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }
    
    [picker release];

    AdobeUXImageEditorViewController* editorViewController = [_photoEditorController editorForImage:imageToSave];
    //self.navigationController
}

@end
