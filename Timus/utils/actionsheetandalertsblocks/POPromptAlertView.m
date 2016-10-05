//
//  POPromptAlertView.m
//  Timus
//
//  Created by Pedro Oliveira on 7/31/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "POPromptAlertView.h"
#import "POPromptButton.h"

@interface POAlertView ()

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation POPromptAlertView

#pragma mark - View Lifecycle

-(id)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title];
    if (self) {
        self.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    return self;
}

- (instancetype) initWithTitle:(NSString *)aTitle andMessage:(NSString*)aMessage
{
    self = [super initWithTitle:aTitle
                     andMessage:aMessage];
    if (self) {
        self.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    return self;
}

#pragma mark - Methods

- (void) addButtonWithTitle:(NSString*) title andAction:(void (^)(NSString*))action
{
    POPromptButton *btn = [[POPromptButton alloc] initWithTitle:title
                                                    andAction:action];
    NSNumber *index = @([[self.buttons allKeys] count]);
    (self.buttons)[index] = btn;
}

#pragma mark - UIAlertViewDeleagate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == self.alertView.cancelButtonIndex) {
        if (self.cancelButton.action != NULL) {
            self.cancelButton.action();
        }
    }
    
    NSArray *buttonsKeys = [self.buttons allKeys];
    if (buttonIndex < [buttonsKeys count]) {
        id key = buttonsKeys[buttonIndex];
        id obj = (self.buttons)[key];
        if ([obj isMemberOfClass:[POActionSheetButton class]]) {
            POActionSheetButton *btn = (POActionSheetButton*)obj;
            if (btn.action != NULL) {
                btn.action();
            }
        }
        if ([obj isMemberOfClass:[POPromptButton class]]) {
            POPromptButton *btn = (POPromptButton *)obj;
            if (btn.action != NULL) {
                btn.action([[alertView textFieldAtIndex:0] text]);
            }
        }
        
    }
    
}

@end
