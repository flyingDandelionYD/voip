//
//  RingCall.h
//  AccessControl
//
//  Created by 柏永东 on 2019/2/16.
//  Copyright © 2019 smile. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RingCall : NSObject
+ (instancetype)sharedMCCall;
- (void)regsionPush;
@end

NS_ASSUME_NONNULL_END
