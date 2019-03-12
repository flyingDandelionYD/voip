//
//  TalkVideoManager.h
//  AccessControl
//
//  
// 
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol VideoCallbackDelegate <NSObject>
/**
 *  当APP收到呼叫、处于后台时调用、用来处理通知栏类型和铃声。
 *
 *  @param name 呼叫者的名字
 */


- (void)onCallRing:(NSString*)name withInfo:(NSDictionary*)info;
/**
 *  呼叫取消调用、取消通知栏
 */
- (void)onCancelRing;
@end

@interface TalkVideoManager : NSObject
+ (TalkVideoManager *)sharedClient;

- (void)initWithSever;

- (void)setDelegate:(id<VideoCallbackDelegate>)delegate;

//用户挂断/接听  停止震动
-(void)cancleCall;
@end

