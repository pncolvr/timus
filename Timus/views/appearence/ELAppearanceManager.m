//
//  ELAppearanceManager.m
//  Timus
//
//  Created by Pedro Oliveira on 4/19/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "UIColor+Utils.h"

#define kDefaultBackgroundColor [UIColor colorWithRedValue:250.0f greenValue:250.0f blueValue:250.0f alpha:1.0f]
#define kDefaultTextColor [UIColor blackColor]

@interface ELAppearanceManager (Private)

- (void) p_applyPostIOS7Interface;
- (void) p_applyCommonInterfaceWithTextAttributes:(NSDictionary*)textAttributes;

@end

@implementation ELAppearanceManager

#pragma mark - Methods

+ (ELAppearanceManager *)sharedAppearanceManager
{
    static ELAppearanceManager *_singleton;
    if (!_singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _singleton = [ELAppearanceManager new];
        });
    }
    return _singleton;
}

- (void) applyDefaultUserInterface
{
    [self p_applyPostIOS7Interface];
}

#pragma mark - Private Methods

- (void) p_applyPostIOS7Interface
{
    NSDictionary *textAttributtes = @{NSForegroundColorAttributeName : kDefaultTextColor};
    
    [self p_applyCommonInterfaceWithTextAttributes:textAttributtes];
    
    [[UINavigationBar appearance] setBarTintColor:kDefaultBackgroundColor];
    [[UINavigationBar appearance] setTintColor:kDefaultTextColor];
    [[UIToolbar appearance] setBarTintColor:kDefaultBackgroundColor];
    [[UISearchBar appearance] setBarTintColor:[UIColor whiteColor]];
    
}

- (void) p_applyCommonInterfaceWithTextAttributes:(NSDictionary*)textAttributes
{
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes
                                                forState:UIControlStateNormal];
    
    [[UITableViewCell appearance] setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    [[UIToolbar appearance] setTintColor:kDefaultBackgroundColor];
    [[UISearchBar appearance] setBackgroundColor:kDefaultBackgroundColor];
}
@end
