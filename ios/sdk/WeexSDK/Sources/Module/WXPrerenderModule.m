//
//  WXPrerenderModule.m
//  Pods
//
//  Created by 齐山 on 17/5/2.
//
//

#import "WXPrerenderModule.h"
#import "WXPrerenderManager.h"

@interface WXPrerenderModule()

@property (nonatomic, strong) NSString *instanceId;

@end

@implementation WXPrerenderModule

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(addTask:callback:))

- (void)dealloc {
    if(!_instanceId){
        return;
    }
    
}

- (void) addTask:(NSString *) urlStr callback:(WXModuleCallback)callback{
    if(![self weexInstance]){
        return;
    }
    
    
    NSURL *sourceURL = [NSURL URLWithString:urlStr];
    if (!sourceURL) {
        return;
    }
    
    _instanceId = [[self weexInstance] instanceId];
    __weak WXSDKInstance *weakInstance = self.weexInstance;

    
    [[WXPrerenderManager sharedInstance] executeTask:urlStr WXInstance:[weakInstance instanceId] callback:callback];
}

@end
