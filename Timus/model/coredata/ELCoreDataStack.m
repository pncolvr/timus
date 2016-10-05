//
//  ELCoreDataStack.m
//  Timus
//
//  Created by Pedro Oliveira on 4/8/13.
//  Copyright (c) 2013 Timus. All rights reserved.
//

#import "ELCoreDataStack.h"
#import "UIManagedDocument+Customization.h"

@interface ELCoreDataStack (Private)

@property (nonatomic, readonly) UIManagedDocument *managedDocument;

- (NSUInteger) p_numberOfObjectsForEntity:(Class) entity;
- (void) p_applicationDidEnterBackground:(NSNotification*) note;
- (void) p_storesWillChange:(NSNotification*) note;
- (void) p_storesDidChange:(NSNotification*) note;
- (void) p_didImport:(NSNotification*) note;

@end

@implementation ELCoreDataStack {
    UIManagedDocument *_managedDocument;
}

#pragma mark - Init Methods

+ (ELCoreDataStack*) sharedCoreDataStack
{
    static ELCoreDataStack *__singleton;
    if (!__singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __singleton = [[ELCoreDataStack alloc] init];
        });
    }
    
    return __singleton;
}

-(id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(p_applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

#pragma mark - Dynamic Properties

- (NSManagedObjectContext *) managedObjectContext
{
    return self.managedDocument.managedObjectContext;
}

#pragma mark - Core Data Stack

- (void) loadPersistedObjects
{
    // we just need to load the managed document
    [self managedDocument];
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(UIManagedDocument *)managedDocument
{
    if (!_managedDocument)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSURL *bdURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                   inDomains:NSUserDomainMask] lastObject];
            bdURL = [bdURL URLByAppendingPathComponent:@"database"];
            _managedDocument = [[UIManagedDocument alloc] initWithFileURL:bdURL];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:[bdURL path]])
            {
                [_managedDocument saveToURL:bdURL
                           forSaveOperation:UIDocumentSaveForCreating
                          completionHandler:^(BOOL success) {
                              if (success) {
                                  [[NSNotificationCenter defaultCenter] postNotificationName:kCoreDataDidLoadNotification
                                                                                      object:nil];
                              } else {
                                  ELLogCritical(@"Unable to create UIManagedDocument");
                              }
                          }];
            } else if (_managedDocument.documentState == UIDocumentStateClosed)
            {
                [_managedDocument openWithCompletionHandler:^(BOOL success) {
                    if (success) { //kCoreDataDidLoadNotification
                        [[NSNotificationCenter defaultCenter] postNotificationName:kCoreDataDidLoadNotification
                                                                            object:nil];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kCoreDataDidNotLoadNotification
                                                                            object:nil];
                    }
                }];
            }
        });
        [_managedDocument setupPersistentStoreOptions];
    }
    
    return _managedDocument;
}

#pragma mark - Private Methods

- (void) p_applicationDidEnterBackground:(NSNotification*) note
{
    [self.managedDocument updateChangeCount:UIDocumentChangeDone];
}

#pragma mark - Object Lifecycle

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
