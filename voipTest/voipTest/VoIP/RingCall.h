//
//  RingCall.h
//  AccessControl
//
//  
// 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RingCall : NSObject
+ (instancetype)sharedMCCall;
- (void)regsionPush;
@end

NS_ASSUME_NONNULL_END
