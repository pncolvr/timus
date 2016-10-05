//
//  UIViewController+Common.m
//  Timus
//
//  Created by Pedro Oliveira on 9/27/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "POAlertView.h"
#import "UIViewController+Common.h"

#define kDidSelctCancelSegue @"kDidSelctCancelSegue"

@import MessageUI.MFMailComposeViewController;

@interface UIViewController (Private) <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) POAlertView *mailAlertView;

@end

@implementation UIViewController (Common)

#pragma mark - Methods

- (void) presentMailWithSubject:(NSString*) subject attachmentString:(NSString*)attach andBody:(NSString*)body
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:subject];
        [controller setMessageBody:body
                            isHTML:YES];
        if (attach) {
            [controller addAttachmentData:[attach dataUsingEncoding:NSUTF8StringEncoding]
                                 mimeType:@"text/csv"
                                 fileName:NSLocalizedString(@"report.csv", @"")];
        }
        if (controller) {
            [self presentViewController:controller animated:YES completion:NULL];
        }
    } else {
        self.mailAlertView = [[POAlertView alloc] initWithTitle:NSLocalizedString(@"Please configure an email account.", @"")];
        [self.mailAlertView addButtonWithTitle:NSLocalizedString(@"Ok", @"")
                                     andAction:NULL];
        [self.mailAlertView show];
    }

}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        [self performSegueWithIdentifier:kDidSelctCancelSegue
                                  sender:self];
    } else {
        if (result == MFMailComposeResultFailed) {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            alertView.title = NSLocalizedString(@"Unable to send mail.", @"");
            [alertView addButtonWithTitle:NSLocalizedString(@"Ok", @"")];
            [alertView show];
            ELLogCritical(@"Unable to send mail: %@", [error description]);
        }
        [self dismissViewControllerAnimated:YES
                                 completion:NULL];
    }
}


@end
