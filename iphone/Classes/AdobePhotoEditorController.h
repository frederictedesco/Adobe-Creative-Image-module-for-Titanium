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

@interface AdobePhotoEditorController : AdobeUXImageEditorViewController <AdobeUXImageEditorViewControllerDelegate>

- (instancetype)initWithImage:(UIImage *)image;

@end
