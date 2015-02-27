//
//  PhotoPickerController.h
//  Photo Editor Adobe
//
//  Created by Lionel Schinckus on 26/02/15.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "AdobePhotoEditorController.h"

@interface PhotoPickerController : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (instancetype)initWith:(AdobePhotoEditorController*)photoEditorController;
- (BOOL)startCameraController;
- (BOOL)startPhotoPickerViewController;

@end
