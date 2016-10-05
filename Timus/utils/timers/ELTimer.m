//
//  BUTimer.m
//  BUCameraPlugin
//
//  Created by Pedro Oliveira on 3/6/13.
//
//

#import "ELTimer.h"

@interface ELTimer ()

@property (strong) NSTimer *internalTimer;
@property (strong) id userInfo;
@property (strong) void (^tickBlock)(ELTimer *timer, id userInfo);
@property (strong) void (^completionBlock)(ELTimer *timer, id userInfo);

@end

@interface ELTimer (PrivateMethods)

- (void) p_tick;

@end

@implementation ELTimer

#pragma mark - Timer Lifecycle

+ (ELTimer*) scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                   userInfo:(id) userInfo
                                    repeats:(BOOL)repeats
                                  tickBlock:(void (^)(ELTimer *timer, id userInfo)) tickBlock
                            completionBlock:(void (^)(ELTimer *timer, id userInfo)) completionBlock
{

    ELTimer *timer = [[ELTimer alloc] init];
    
    timer.userInfo = userInfo;
    timer.tickBlock = tickBlock;
    timer.completionBlock = completionBlock;
    
    timer.internalTimer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                                           target:timer
                                                         selector:@selector(p_tick)
                                                         userInfo:userInfo
                                                          repeats:repeats];
    
    return timer;
}

#pragma mark - Methods

- (void) invalidateAndExecuteCompletionBlock:(BOOL)executeCompletionBlock
{
    [self.internalTimer invalidate];
    if (executeCompletionBlock && self.completionBlock) {
        self.completionBlock(self,self.userInfo);
    }
}

#pragma mark - Private Methods

- (void) p_tick
{
    if (self.tickBlock) {
        self.tickBlock(self,self.userInfo);
    }
}


@end
