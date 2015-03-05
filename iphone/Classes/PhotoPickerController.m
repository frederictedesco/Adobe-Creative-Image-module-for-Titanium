//
//  PhotoPickerController.m
//  Photo Editor Adobe
//
//  Created by Lionel Schinckus on 26/02/15.
//
//

#import "PhotoPickerController.h"
#import <TiApp.h>
#import "AdobePhotoEditorController.h"

@interface PhotoPickerController ()

@property (nonatomic, retain) AdobePhotoEditorController* photoEditorController;

@end

@implementation PhotoPickerController

- (instancetype)initWith:(AdobePhotoEditorController*)photoEditorController
{
    self = [super init];
    if (self) {
        self.photoEditorController = photoEditorController;
        
        // SourceType and MediaType (Image)
        self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.mediaTypes = @[(NSString*)kUTTypeImage];
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        self.allowsEditing = NO;
        
        self.delegate = self;
        
    }
    return self;
}

- (void)dealloc
{
    [_photoEditorController release];
    [super dealloc];
}

#pragma mark - UIImagePickerViewController Delegate

// For responding to the user tapping Cancel.
- (void)imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    NSLog(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:self completion:nil];
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

    [self.photoEditorController displayEditorForImage:imageToSave];
}

@end
