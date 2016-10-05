//
//  BUTimer.h
//  BUCameraPlugin
//
//  Created by Pedro Oliveira on 3/6/13.
//
//

@import Foundation;

@interface ELTimer : NSObject

#pragma mark - Methods

+ (ELTimer*) scheduledTimerWithTimeInterval:(NSTimeInterval)seconds
                                   userInfo:(id) userInfo
                                    repeats:(BOOL)repeats
                                  tickBlock:(void (^)(ELTimer *timer, id userInfo)) tickBlock
                            completionBlock:(void (^)(ELTimer *timer, id userInfo)) completionBlock;

- (void) invalidateAndExecuteCompletionBlock:(BOOL)executeCompletionBlock;

@end
