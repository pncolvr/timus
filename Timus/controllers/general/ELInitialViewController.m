//
//  ELInitialViewController.m
//  Timus
//
//  Created by Pedro Oliveira on 7/12/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ClockView.h"
#import "ELAnimatedLabel.h"
#import "ELCoreDataStack.h"
#import "ELInitialViewController.h"

#pragma mark - Constants

#define kProjectCollectionSegue @"kProjectCollectionSegue"

@interface ELInitialViewController ()

- (void) p_coreDataDidLoad;
- (void) p_coreDataDidNotLoad;

@end

@implementation ELInitialViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[ELAppearanceManager sharedAppearanceManager] applyDefaultUserInterface];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_coreDataDidLoad)
                                                 name:kCoreDataDidLoadNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_coreDataDidNotLoad)
                                                 name:kCoreDataDidNotLoadNotification
                                               object:nil];
    [[ELCoreDataStack sharedCoreDataStack] loadPersistedObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void) p_coreDataDidLoad
{
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self performSegueWithIdentifier:kProjectCollectionSegue
                                  sender:self];
    });
    
}

- (void) p_coreDataDidNotLoad
{
    [[ELCoreDataStack sharedCoreDataStack] loadPersistedObjects];
}

@end
