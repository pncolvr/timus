//
//  ELImagePicker.m
//  Timus
//
//  Created by Pedro Oliveira on 4/14/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELImagePicker.h"
#import "POActionSheet.h"
#import "UIImage+Resize.h"

@interface ELImagePicker ()
@property (nonatomic, strong) void (^imagePickedBlock)(UIImage *image);
@end

@interface ELImagePicker (Private);

@property (atomic, readonly) POActionSheet *actionSheet;
- (POActionSheet*) p_actionSheetWithAdditionalOptions:(BOOL)displayAdditionalOptions;
- (void) p_deletePhoto;
- (void) p_presentPhotoGallery;
- (void) p_presentCamera;
- (void) p_presentImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType) sourceType;
@end

@implementation ELImagePicker {
    UIViewController *_presentingViewController;
    UIImagePickerController *_imagePicker;
    POActionSheet *_actionSheet;
}

#pragma mark - View Lifecycle

- (instancetype) init
{
    self = [super init];
    if (self) {
        _imagePicker = [[UIImagePickerController alloc] init];
    }
    return self;
}

#pragma mark - Methods

-(void) presentInViewController:(UIViewController*)viewController
        targetImageViewHasImage:(BOOL)targetImageViewHasImage
      withImagePickedCompletion:(void (^)(UIImage *image)) completion
{
    _presentingViewController = viewController;
    self.imagePickedBlock = completion;
    
    POActionSheet *actionSheet = [self p_actionSheetWithAdditionalOptions:targetImageViewHasImage];
    actionSheet.presentingView = viewController;
    [actionSheet show];
}

- (void)presentInViewController:(UIViewController*)viewController
                   targetButton:(UIButton*)button
                andDefaultImage:(UIImage *)defaultImage
{
    UIImage *currentImage = [button imageForState:UIControlStateNormal];
    BOOL imageViewHasImage = (![currentImage isEqual:defaultImage] && currentImage != nil);
    [self presentInViewController:viewController
                  targetImageViewHasImage:imageViewHasImage
                withImagePickedCompletion:^(UIImage *image) {
                    UIImage *imageToApply = defaultImage;
                    if (image) imageToApply = image;
                    [button setImage:imageToApply
                            forState:UIControlStateNormal];
                }];

}

#pragma mark - Private Methods

- (POActionSheet*) p_actionSheetWithAdditionalOptions:(BOOL)displayAdditionalOptions
{
    __weak ELImagePicker *weakSelf = self;
    _actionSheet = [[POActionSheet alloc] initWithTitle:@""];
    [_actionSheet addCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"")
                                andAction:nil];
    if (!isSimulator) {
        [_actionSheet addButtonWithTitle:NSLocalizedString(@"Take Photo", @"")
                               andAction:^{
                                   [weakSelf p_presentCamera];
                               }];
    }

    [_actionSheet addButtonWithTitle:NSLocalizedString(@"Choose Photo", @"")
                          andAction:^{
                              [weakSelf p_presentPhotoGallery];
                          }];
    if (displayAdditionalOptions) {
        [_actionSheet addButtonWithTitle:NSLocalizedString(@"Delete Photo", @"")
                              andAction:^{
                                  [weakSelf p_deletePhoto];
                              }];
    }
    
    return _actionSheet;
}

- (void) p_deletePhoto
{
    if (self.imagePickedBlock) {
        self.imagePickedBlock(nil);
    }
}

- (void) p_presentPhotoGallery
{
    [self p_presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void) p_presentCamera
{
    [self p_presentImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void) p_presentImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType) sourceType
{
    _imagePicker.sourceType = sourceType;
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    [_presentingViewController presentViewController:_imagePicker
                                            animated:YES
                                          completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_presentingViewController dismissViewControllerAnimated:YES
                                                  completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (image && self.imagePickedBlock){
        UIImage *resizedImage = [image resizedImage:CGSizeMake(100, 100)
                               interpolationQuality:kCGInterpolationHigh];
        self.imagePickedBlock(resizedImage);
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_presentingViewController dismissViewControllerAnimated:YES
                                                  completion:nil];
}

@end
