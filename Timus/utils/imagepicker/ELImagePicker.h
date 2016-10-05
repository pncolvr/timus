//
//  ELImagePicker.h
//  Timus
//
//  Created by Pedro Oliveira on 4/14/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

@import Foundation;

@interface ELImagePicker : NSObject <UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

#pragma mark - Methods

/*
 When image picked is nil the user has decided to remove the image
 */
- (void) presentInViewController:(UIViewController*)viewController
         targetImageViewHasImage:(BOOL)targetImageViewHasImage
       withImagePickedCompletion:(void (^)(UIImage *image)) completion;

- (void)presentInViewController:(UIViewController*)viewController
                   targetButton:(UIButton*)button
                andDefaultImage:(UIImage*)defaultImage;


@end
