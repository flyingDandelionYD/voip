//
//  TalkVideoManager.m
//  AccessControl
//
//  
// 
//

#import "TalkVideoManager.h"
#import <PushKit/PushKit.h>
#import "RingCall.h"


@interface TalkVideoManager ()<PKPushRegistryDelegate>{
    NSString *token;
}

@property (nonatomic,weak)id<VideoCallbackDelegate>mydelegate;

@end


@implementation TalkVideoManager
static TalkVideoManager *instance = nil;
+ (TalkVideoManager *)sharedClient {
    if (instance == nil) {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

-(void)initWithSever {
    //voip delegate
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    //ios10注册本地通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        [[RingCall sharedMCCall] regsionPush];
    }
}

- (void)setDelegate:(id<VideoCallbackDelegate>)delegate {
    self.mydelegate = delegate;
}

#pragma mark -pushkitDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type{
    if([credentials.token length] == 0) {
        NSLog(@"voip token NULL");
        return;
    }
    //应用启动获取token，并上传服务器
    token = [[[[credentials.token description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
              stringByReplacingOccurrencesOfString:@">" withString:@""]
             stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token：%@",token);
    //token上传服务器
    
}

-(void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type{
    BOOL isCalling = false;
    switch ([UIApplication sharedApplication].applicationState) {
        case UIApplicationStateActive: {
            isCalling = false;
        }
            break;
        case UIApplicationStateInactive: {
            isCalling = false;
        }
            break;
        case UIApplicationStateBackground: {
            isCalling = true;
        }
            break;
        default:
            isCalling = true;
            break;
    }
    NSLog(@"payload==%@",payload.dictionaryPayload);
    if (isCalling){
        //获取推送的内容
        NSString *callerStr = payload.dictionaryPayload[@"aps"][@"alert"];
        //本地通知，实现响铃效果
        [self.mydelegate onCallRing:callerStr withInfo:payload.dictionaryPayload];
        
    }
}

-(void)cancleCall{
    [self.mydelegate onCancelRing];
}

@end

