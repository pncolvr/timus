//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "POActionSheet.h"

#define kDestructiveButtonIndex 0

@interface POActionSheet ()

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) POActionSheetButton *destructiveButton;

@end

@implementation POActionSheet

#pragma mark - View Lifecycle

- (instancetype) initWithTitle:(NSString*)aTitle
{
    self = [super initWithTitle:aTitle];
    
    if (self) {
        _actionSheetStyle = UIActionSheetStyleAutomatic;
    }
    
    return self;
    
}

#pragma mark - Methods

- (void) addDestructiveButtonWithTitle:(NSString*) aTitle andAction:(void (^)(void))action
{
    self.destructiveButton = [[POActionSheetButton alloc] initWithTitle:aTitle
                                                              andAction:action];
}

- (void) show
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:self.title
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                     destructiveButtonTitle:nil
                                          otherButtonTitles: nil];
    self.actionSheet.actionSheetStyle = self.actionSheetStyle;
    
    int incrementDestructiveButton = self.destructiveButton ? 1 : 0;
    
    if (self.destructiveButton) {
        [self.actionSheet addButtonWithTitle:self.destructiveButton.title];
        self.actionSheet.destructiveButtonIndex = kDestructiveButtonIndex;
    }
    
    for (id key in [self.buttons allKeys]) {
        [self.actionSheet addButtonWithTitle:[(self.buttons)[key] title]];
    }
    
    if (self.cancelButton) {
        [self.actionSheet addButtonWithTitle:self.cancelButton.title];
        NSUInteger numberOfButtons = [[self.buttons allKeys] count];
        self.actionSheet.cancelButtonIndex = numberOfButtons + incrementDestructiveButton;
    }
    
    self.actionSheet.delegate = self;
    [self.actionSheet showInView:self.presentingView.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    int incrementDestructiveButton = self.destructiveButton ? 1 : 0;
    NSArray *buttonsKeys = [self.buttons allKeys];
    if (buttonIndex == self.actionSheet.cancelButtonIndex) {
        if (self.cancelButton.action) {
            self.cancelButton.action();
        }
    } else if (buttonIndex == self.actionSheet.destructiveButtonIndex) {
        if (self.destructiveButton.action) {
            self.destructiveButton.action();
        }
    } else if (buttonIndex-incrementDestructiveButton < [buttonsKeys count]) {
        buttonIndex-=incrementDestructiveButton;//remove destructive button index (it adds one as it is always the first)
        id key = buttonsKeys[buttonIndex];
        POActionSheetButton * btn = (self.buttons)[key];
        if (btn.action) {
            btn.action();
        }
    }
}

@end
