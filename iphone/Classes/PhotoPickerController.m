//
//  PhotoPickerController.m
//  Photo Editor Adobe
//
//  Created by Lionel Schinckus on 26/02/15.
//
//

#import "PhotoPickerController.h"
#import <TiApp.h>

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

- (BOOL)startCameraController {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = self;
    
    [[TiApp app] showModalController:cameraUI animated:YES];
    return YES;
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
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [[TiApp app] hideModalController:picker animated:YES];
    [picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void)imagePickerController: (UIImagePickerController *) picker
didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        [_photoEditorController displayEditorForImage:imageToSave];
    }
    
    // Handle a movie capture
    /*if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
     == kCFCompareEqualTo) {
     
     NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
     
     if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
     UISaveVideoAtPathToSavedPhotosAlbum (
     moviePath, nil, nil, nil);
     }
     }*/
    
    [[TiApp app] hideModalController:picker animated:YES];
    [picker release];
}

@end
