//
//  ComExampleTextViewProxy.m
//  test
//
//  Created by Lionel Schinckus on 25/02/15.
//
//

#import "ComDcodePhotoeditorAdobeActionSheetViewProxy.h"
#import "ComDcodePhotoeditorAdobeActionSheetView.h"
#import "TiUtils.h"

@implementation ComDcodePhotoeditorAdobeActionSheetViewProxy

- (void)showActionSheet:(id)args {
    NSLog(@"ComDcodePhotoeditorAdobeActionSheetViewProxy: Show actionSheet");
    [[self view] performSelectorOnMainThread:@selector(showActionSheet:) withObject:nil waitUntilDone:NO];
}

@end
