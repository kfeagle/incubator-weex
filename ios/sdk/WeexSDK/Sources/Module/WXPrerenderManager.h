//
//  WXPrerenderManager.h
//  Pods
//
//  Created by 齐山 on 17/5/2.
//
//

#import <Foundation/Foundation.h>
#import <WeexSDk/WeexSDK.h>

typedef NS_ENUM(NSUInteger, PrerenderStatus) {
    PrerenderSucceed = 0,
    PrerenderFail = 1,
};
typedef NS_ENUM(NSUInteger, PrerenderTaskType) {
    PrerenderUITaskType = 0,
    PrerenderMethodType = 1,
};

typedef void (^PrerenderCallback) (PrerenderStatus status, NSString* urlStr, NSString * msg);

@interface WXPrerenderManager : NSObject

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) sharedInstance;
- (void) executeTask:(NSString *) urlStr WXInstance:(NSString *) instanceId callback:(WXModuleCallback)callback;
- (void) cancelTask:(NSString *) instanceId;
- (BOOL) isTaskExist:(NSString *)url;
- (void) renderFromCache:(NSString *)url;
- (void) storeInstanceTask:(id)task instanceId:(NSString *)instanceId type:(PrerenderTaskType)type;
- (UIView *)viewFromUrl:(NSString *)url;
- (id )instanceFromUrl:(NSString *)url;



- (id)prerenderTasksForUrl:(NSString *)url;

- (void)storePrerenderInstance:(WXSDKInstance *)instance forUrl:(NSString *)url;

-  (void)removePrerenderTaskforUrl:(NSString *)url;

- (id)prerenderModuleTasksForUrl:(NSString *)url;

- (void)storePrerenderModuleTasks:(NSMutableDictionary *)prerenderModuleTask forUrl:(NSString *)url;

- (void)removePrerenderModuleTaskforUrl:(NSString *)url;
- (NSString *)prerenderUrl:(NSURL *)scriptUrl;
- (void)excuteModuleTasksForUrl:(NSString *)url;
@end
