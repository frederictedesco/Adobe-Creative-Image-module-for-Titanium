/**
 * Photo Editor Adobe
 *
 * Created by Your Name
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "TiModule.h"
#import <AdobeCreativeSDKImage/AdobeCreativeSDKImage.h>

@interface ComDcodePhotoeditorAdobeModule : TiModule <AdobeUXImageEditorViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    AdobeUXImageEditorViewController *editorController;
}

@end
