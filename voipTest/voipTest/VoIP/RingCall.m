//
//  RingCall.m
//  AccessControl
//
//
//
//

#import "RingCall.h"
#import "TalkVideoManager.h"
#import <UserNotifications/UserNotifications.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RingCall ()<VideoCallbackDelegate>{
    UILocalNotification *callNotification;
    UNNotificationRequest *request;//ios 10
    NSTimer *_vibrationTimer;
}
@end

@implementation RingCall
+ (instancetype)sharedMCCall {
    static  RingCall *callInstane;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (callInstane == nil) {
            callInstane = [[RingCall alloc] init];
            [[TalkVideoManager sharedClient] setDelegate:callInstane];
        }
    });
    return callInstane;
}

- (void)regsionPush {
    //iOS 10
    if(@available(iOS 10.0, *)){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"%@",settings);
        }];
    }
}


#pragma mark-VideoCallbackDelegate
- (void)onCallRing:(NSString *)CallerName withInfo:(NSDictionary *)info{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.body =[NSString localizedUserNotificationStringForKey:[NSString
                                                                       stringWithFormat:@"%@%@", CallerName,
                                                                       @"邀请你进行通话。。。。"] arguments:nil];
        content.userInfo = info;
        UNNotificationSound *customSound = [UNNotificationSound soundNamed:@"weixin.m4a"];
        content.sound = customSound;
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:1 repeats:NO];
        request = [UNNotificationRequest requestWithIdentifier:@"Voip_Push"
                                                       content:content trigger:trigger];
        [self playShake];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }else {
        
        callNotification = [[UILocalNotification alloc] init];
        callNotification.userInfo = info;
        callNotification.alertBody = [NSString
                                      stringWithFormat:@"%@%@", CallerName,
                                      @"邀请你进行通话。。。。"];
        callNotification.soundName = @"weixin.m4a";
        [self playShake];
        [[UIApplication sharedApplication] presentLocalNotificationNow:callNotification];
        
    }
    
}

- (void)onCancelRing {
    //取消通知栏
    if (@available(iOS 10.0, *)) {
        NSMutableArray *arraylist = [[NSMutableArray alloc]init];
        [arraylist addObject:@"Voip_Push"];
        [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:arraylist];
    }else {
        [[UIApplication sharedApplication] cancelLocalNotification:callNotification];
    }
    [_vibrationTimer invalidate];
}

-(void)playShake{
    if(_vibrationTimer){
        [_vibrationTimer invalidate];
        _vibrationTimer = nil;
    }else{
        _vibrationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playkSystemSound) userInfo:nil repeats:YES];
    }
}

//振动
- (void)playkSystemSound{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
