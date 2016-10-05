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


#import "POUserAction.h"

@implementation POUserAction

#pragma mark - View Lifecycle

- (instancetype) initWithTitle:(NSString*)aTitle
{
    self = [super init];
    
    if (self) {
        _title = aTitle;
        _buttons = [[NSMutableDictionary alloc] init];
    }
    
    return self;
    
}

#pragma mark - Methods

- (void) addButtonWithTitle:(NSString*) aTitle andAction:(void (^)(void))action
{
    POActionSheetButton *btn = [[POActionSheetButton alloc] initWithTitle:aTitle
                                                                andAction:action];
    NSNumber *index = [NSNumber numberWithUnsignedInteger:[[self.buttons allKeys] count]];
    (self.buttons)[index] = btn;
    
}

- (void) addCancelButtonWithTitle:(NSString*) aTitle andAction:(void (^)(void))action
{
    _cancelButton = [[POActionSheetButton alloc] initWithTitle:aTitle
                                                         andAction:action];
}

- (void) show
{
    ELLogCritical(@"This object does not know how to show itself, please subclass");
}

@end
