//
//  PhotoCameraViewController.m
//  Photo Editor Adobe
//
//  Created by Lionel Schinckus on 3/03/15.
//
//

#import "PhotoCameraViewController.h"
#import "LLSimpleCamera.h"
#import "ViewUtils.h"
#import "UIImage+Resize.h"

#import "AdobePhotoEditorController.h"
#import "PhotoPickerController.h"
#import "ComDcodePhotoeditorAdobeModule.h"

#import <TiApp.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoCameraViewController ()

@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *crossButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *cameraRollButton;
@property (strong, nonatomic) AdobePhotoEditorController* editorViewController;
@property (strong, nonatomic) PhotoPickerController* photoPickerController;
@property (copy, nonatomic) UIImage* latestPhoto;

@end

@implementation PhotoCameraViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Instantiate Controller
    self.editorViewController = [[AdobePhotoEditorController alloc] init];
    self.photoPickerController = [[PhotoPickerController alloc] initWith:self.editorViewController];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // ----- initialize camera -------- //
    
    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:CameraQualityPhoto andPosition:CameraPositionBack];
    
    self.camera.useDeviceOrientation = YES;
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.width)];
    
    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = YES;
    
    // take the required actions on a device change
    __weak PhotoCameraViewController* weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
        
        weakSelf.flashButton.selected = NO;
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"[ERROR] Camera error: %@", error);
    }];
    
    // ----- camera buttons -------- //
    
    // snap button to capture image
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.frame = CGRectMake(0, 0, 80.0f, 80.0f);
    self.snapButton.clipsToBounds = YES;
    [self.snapButton setImage:[UIImage imageWithContentsOfFile:[ComDcodePhotoeditorAdobeModule getPathToModuleAsset:@"camera-hit.png"]] forState:UIControlStateNormal];
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    // button to toggle flash
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.frame = CGRectMake(0, 0, 40.0f + 20.0f, 28.0f + 20.0f);
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];
    
    // button to toggle camera positions
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.switchButton.frame = CGRectMake(0, 0, 32.0f + 20.0f, 32.0f + 20.0f);
    [self.switchButton setImage:[UIImage imageWithContentsOfFile:[ComDcodePhotoeditorAdobeModule getPathToModuleAsset:@"camera-switch.png"]] forState:UIControlStateNormal];
    self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.switchButton];
    
    // cross button to close
    self.crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.crossButton.frame = CGRectMake(8.0f, 8.0f, 32.0f, 32.0f);
    self.crossButton.clipsToBounds = YES;
    [self.crossButton setImage:[UIImage imageWithContentsOfFile:[ComDcodePhotoeditorAdobeModule getPathToModuleAsset:@"cross.png"] ] forState:UIControlStateNormal];
    [self.crossButton addTarget:self action:@selector(crossButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.crossButton];
    
    // button to show photo library
    self.cameraRollButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraRollButton.layer.masksToBounds = YES;
    self.cameraRollButton.layer.cornerRadius = 2.0f;
    self.cameraRollButton.frame = CGRectMake(0, 0, 50.0f, 50.0f);
    [self.cameraRollButton setImage:[UIImage imageWithContentsOfFile:[ComDcodePhotoeditorAdobeModule getPathToModuleAsset:@"camera-gallery.png"]] forState:UIControlStateNormal];
    [self.cameraRollButton addTarget:self action:@selector(cameraRollButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cameraRollButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    // start the camera
    [self.camera start];
    
    [self.camera updateFlashMode:CameraFlashOff];
    [self changeFlashButtonImage:self.camera.flash];

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        // The end of the enumeration is signaled by group == nil.
        if (group != nil) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        }
        if (group != nil && group.numberOfAssets > 0) {
            // Chooses the photo at the last index
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:([group numberOfAssets] - 1)] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                // The end of the enumeration is signaled by asset == nil.
                if (alAsset) {
                    self.latestPhoto = [UIImage imageWithCGImage:[alAsset thumbnail]];
                    UIImage* resizedImage = [self.latestPhoto resizedImageToFitInSize:CGSizeMake(50, 50) scaleIfSmaller:YES];
                     [self.cameraRollButton setImage:resizedImage forState:UIControlStateNormal];
                }
            }];
        }
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"[ERROR] No groups, %@",error);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // stop the camera
    [self.camera stop];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

/* camera buttons */
- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}

- (void)flashButtonPressed:(UIButton *)button {
    
    if(self.camera.flash == CameraFlashOff) {
        [self.camera updateFlashMode:CameraFlashAuto];
    } else if (self.camera.flash == CameraFlashOn) {
        [self.camera updateFlashMode:CameraFlashOff];
    } else {
        [self.camera updateFlashMode:CameraFlashOn];
    }
    
    [self changeFlashButtonImage:self.camera.flash];
}

- (void)changeFlashButtonImage:(CameraFlash)flash {
    if(self.camera.flash == CameraFlashOff) {
        [self.flashButton setImage:[UIImage imageWithContentsOfFile:[ComDcodePhotoeditorAdobeModule getPathToModuleAsset:@"camera-flash-off.png"]] forState:UIControlStateNormal];
    } else if (self.camera.flash == CameraFlashOn) {
        [self.flashButton setImage:[UIImage imageWithContentsOfFile:[ComDcodePhotoeditorAdobeModule getPathToModuleAsset:@"camera-flash-on.png"]] forState:UIControlStateNormal];
    } else {
        [self.flashButton setImage:[UIImage imageWithContentsOfFile:[ComDcodePhotoeditorAdobeModule getPathToModuleAsset:@"camera-flash-auto.png"]] forState:UIControlStateNormal];
    }
}

- (void)snapButtonPressed:(UIButton *)button {
    
    // capture
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            
            // we should stop the camera, since we don't need it anymore. We will open a new vc.
            // this very important, otherwise you may experience memory crashes
            [camera stop];
            
            // show the image
            [_editorViewController displayEditorForImage:image];
        }
    } exactSeenImage:YES];
}

- (void)cameraRollButtonPressed:(UIButton *)button {
    [[TiApp app] showModalController:self.photoPickerController animated:YES];
}

- (void)crossButtonPressed:(UIButton *)button {
    [[TiApp app] hideModalController:self animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cameraCancel" object:nil];
}

/* other lifecycle methods */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.camera.view.frame = self.view.contentBounds;
    
    self.snapButton.center = self.view.contentCenter;
    self.snapButton.bottom = self.view.height - 15;
    
    self.flashButton.right = self.view.width - 5.0f;
    self.flashButton.top = 5.0f;

    self.switchButton.center = self.view.contentCenter;
    self.switchButton.top = 5.0f;

    self.cameraRollButton.left = 8;
    self.cameraRollButton.bottom = self.view.height - 15;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
