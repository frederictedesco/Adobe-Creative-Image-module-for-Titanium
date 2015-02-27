//
//  ComExampleTestView.m
//  test
//
//  Created by Lionel Schinckus on 25/02/15.
//
//

#import "ComDcodePhotoeditorAdobeActionSheetView.h"
#import "TiUtils.h"
#import "TiApp.h"

#import "PhotoPickerController.h"
#import "AdobePhotoEditorController.h"

@interface ComDcodePhotoeditorAdobeActionSheetView ()

@property (nonatomic, retain) UIActionSheet* actionSheet;
@property (nonatomic, retain) PhotoPickerController* photoPickerController;
@property (nonatomic, retain) AdobePhotoEditorController* adobePhotoEditorController;

@end

@implementation ComDcodePhotoeditorAdobeActionSheetView

- (void)initializeState
{
    // Creates and keeps a reference to the view upon initialization
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a new photo", @"Choose a photo in my library", nil];
    self.adobePhotoEditorController = [[AdobePhotoEditorController alloc] init];
    self.photoPickerController = [[PhotoPickerController alloc] initWith:_adobePhotoEditorController];
    [super initializeState];
}

-(void)dealloc
{
    // Deallocates the view
    RELEASE_TO_NIL(_actionSheet);
    RELEASE_TO_NIL(_photoPickerController);
    RELEASE_TO_NIL(_adobePhotoEditorController);
    [super dealloc];
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    // Sets the size and position of the view
    [TiUtils setView:_actionSheet positionRect:bounds];
}

-(void)setColor_:(id)color
{
    // Assigns the view's background color
    _actionSheet.backgroundColor = [[TiUtils colorValue:color] _color];
}

- (void)showActionSheet:(id)args {
    NSLog(@"Show actionView");
    [_actionSheet showInView:[[TiApp app] topMostView]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"[INFO] ButtonIndex : %i",buttonIndex);

    if (buttonIndex == 0) {
        NSLog(@"[INFO] Take a photo");
        [_photoPickerController startCameraController];
    } else if (buttonIndex == 1) {
        NSLog(@"[INFO] Choose a photo from my library");
        [_photoPickerController startPhotoPickerViewController];
    } else {
        NSLog(@"[INFO] Cancel");
    }
}

@end
