//
//  ELAppDelegate.m
//  Timus
//
//  Created by Pedro Oliveira on 4/8/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELAppDelegate.h"
#import "CargoBay.h"

#define SCREENSHOT_ON_TAP DEBUG

#if SCREENSHOT_ON_TAP
#import "SDScreenshotCapture.h"
#endif

@interface ELAppDelegate ()

#if SCREENSHOT_ON_TAP // to avoid warnings on release compile
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGesture;
#endif

@end

@implementation ELAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[CargoBay sharedManager] setPaymentQueueUpdatedTransactionsBlock:^(SKPaymentQueue *queue, NSArray *transactions) {
        NSLog(@"Updated Transactions: %@", transactions);
    }];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[CargoBay sharedManager]];
    
#if SCREENSHOT_ON_TAP
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    tapGesture.numberOfTouchesRequired = 3;
#endif
    self.window.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#if SCREENSHOT_ON_TAP
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGesture
{
    [SDScreenshotCapture takeScreenshotToCameraRoll];
}
#endif

@end
