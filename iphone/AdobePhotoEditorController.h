//
//  AdobePhotoEditorController.h
//  Photo Editor Adobe
//
//  Created by Lionel Schinckus on 26/02/15.
//
//

#import <Foundation/Foundation.h>

#import <AdobeCreativeSDKImage/AdobeCreativeSDKImage.h>
@class ComDcodePhotoeditorAdobeActionSheet;

@interface AdobePhotoEditorController : NSObject <AdobeUXImageEditorViewControllerDelegate>

- (instancetype)initFromActionSheet:(ComDcodePhotoeditorAdobeActionSheet*)actionSheet;
- (void)displayEditorForImage:(UIImage *)imageToEdit;

@end
