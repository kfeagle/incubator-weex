//
//  WXPrerenderManager.m
//  Pods
//
//  Created by 齐山 on 17/5/2.
//
//

#import "WXPrerenderManager.h"
#import "WXConfigCenterProtocol.h"
#import "WXModuleMethod.h"
#import "WXBridgeManager.h"
#import "WXSDKInstance_private.h"

static NSString *const MSG_PRERENDER_INTERNAL_ERROR = @"internal_error";

@interface WXPrerenderManager()

@property (nonatomic, strong) NSMutableArray *cachedUrlList;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary*> *prerenderTasks;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray*> *prerenderModuleTasks;

@end

@implementation WXPrerenderManager

+ (instancetype) sharedInstance{
    
    static WXPrerenderManager *instance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        instance = [[WXPrerenderManager alloc] initPrivate];
    });
    
    return instance;
}

- (instancetype) initPrivate{
    self = [super init];
    if(self){
        self.cachedUrlList = [[NSMutableArray alloc] init];
        self.queue = dispatch_queue_create("JSPrerender", DISPATCH_QUEUE_SERIAL);
        self.prerenderTasks = [[NSMutableDictionary alloc] init];
        self.prerenderModuleTasks = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) dealloc{
    self.cachedUrlList = nil;
    self.prerenderTasks = nil;
    self.prerenderModuleTasks = nil;
}

- (void) cancelTask:(NSString *)instanceId{
    dispatch_async(self.queue, ^{
        for(NSURLSessionDataTask *task in _prerenderTasks[instanceId]){
            [task cancel];
        }
        
        [_prerenderTasks removeObjectForKey:instanceId];
    });
}

- (void) executeTask:(NSString *)urlStr WXInstance:(NSString *)instanceId callback:(WXModuleCallback)callback{
    NSURL *url = [NSURL URLWithString:urlStr];
    if(!url){
        callback(@{@"url":urlStr,@"error":MSG_PRERENDER_INTERNAL_ERROR});
        return;
    }
    
    __weak WXPrerenderManager *weakSelf = self;
    dispatch_async(self.queue, ^{
        [weakSelf prerender:url WXInstance:instanceId callback:callback];
    });
}


- (void) prerender:(NSURL *)url WXInstance:(NSString *)instanceId callback:(WXModuleCallback) callback{

    NSString *str = url.absoluteString;
    if(str.length==0){
        callback(@{@"url":[url absoluteString],@"message":MSG_PRERENDER_INTERNAL_ERROR,@"result":@"error"});
    }
    id configCenter = [WXSDKEngine handlerForProtocol:@protocol(WXConfigCenterProtocol)];
    if ([configCenter respondsToSelector:@selector(configForKey:defaultValue:isDefault:)]) {
        BOOL switchOn = [[configCenter configForKey:@"weex_prerender_config.is_switch_on" defaultValue:@false isDefault:NULL] boolValue];
        if(!switchOn){
            callback(@{@"url":[url absoluteString],@"message":MSG_PRERENDER_INTERNAL_ERROR,@"result":@"error"});
            return;
        }
    }
    WXSDKInstance *instance = [[WXSDKInstance alloc] init];
    instance.needPrerender = YES;
    NSString *newURL = nil;
    NSMutableDictionary *task = [NSMutableDictionary new];
    [task setObject:instance forKey:@"instance"];
    [task setObject:instanceId forKey:@"parentInstanceId"];
    [task setObject:instance.instanceId forKey:@"instanceId"];
    
    [instance renderWithURL:url options:@{@"bundleUrl":url.absoluteString} data:nil];
    
    [self.prerenderTasks setObject:task forKey:url.absoluteString];
    __weak typeof(self) weakSelf = self;
    instance.onCreate = ^(UIView *view) {
        NSMutableDictionary *m = [weakSelf.prerenderTasks objectForKey:url.absoluteString];
        [m setObject:view forKey:@"view"];
        [weakSelf.prerenderTasks setObject:m forKey:url.absoluteString];
    };
    
    instance.onFailed = ^(NSError *error) {
        
    };
    
    instance.renderFinish = ^(UIView *view) {
        NSMutableDictionary *m = [weakSelf.prerenderTasks objectForKey:url.absoluteString];
        [m setObject:@(WeexInstanceAppear) forKey:@"WeexInstanceAppear"];
        [weakSelf.prerenderTasks setObject:m forKey:url.absoluteString];
    };
}


-(NSString *)prerenderUrl:(NSURL *)scriptUrl
{
    if(scriptUrl){
        return scriptUrl.absoluteString;
    }
    return @"";
}

- (BOOL)isTaskExist:(NSString *)url
{
    NSDictionary *m  = [self.prerenderTasks objectForKey:url];
    if(m ){
        return YES;
    }
    return NO;
}

- (void) renderFromCache:(NSString *)url
{
    if([self isTaskExist:url])
    {
        NSMutableDictionary *m  = [self.prerenderTasks objectForKey:url];
        WXSDKInstance *instance = [m objectForKey:@"instance"];
        instance.needPrerender = NO;
        NSMutableArray *tasks = [m objectForKey:@"tasks"];
        WXPerformBlockOnComponentThread(^{
            [instance.componentManager excutePrerenderUITask:url];
        });
        for (NSDictionary *task in tasks) {
            NSInteger type = [[task objectForKey:@"type"] integerValue];
            if(type == PrerenderMethodType){
                WXModuleMethod *method = [task objectForKey:@"task"];
                [method invoke];
            }
        }
    }
}

-(UIView *)viewFromUrl:(NSString *)url
{
    NSDictionary *m  = [self.prerenderTasks objectForKey:url];
    UIView *view = [m objectForKey:@"view"];
    return view;
}

- (id )instanceFromUrl:(NSString *)url
{
    NSDictionary *m  = [self.prerenderTasks objectForKey:url];
    WXSDKInstance *instance = [m objectForKey:@"instance"];
    return instance;
}

- (id)prerenderTasksForUrl:(NSString *)url
{
    return [self.prerenderTasks objectForKey:url];
}

- (NSString *)urlForInstanceId:(NSString *)url
{
    if(self.prerenderTasks){
        [self.prerenderTasks enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if (obj && [obj objectForKey:@""]) {
                
                *stop = YES;
                
            }
            
        }];
    }
    return nil;
}

- (void) storeInstanceTask:(id)task instanceId:(NSString *)instanceId type:(PrerenderTaskType)type
{
    WXSDKInstance *instance = [WXSDKManager instanceForID:instanceId];
    NSMutableDictionary *taskInfo = [self prerenderTasksForUrl:instance.scriptURL.absoluteString];
    if(!taskInfo){
        taskInfo = [NSMutableDictionary new];
    }
    NSMutableArray *tasks = [taskInfo objectForKey:@"tasks"];
    if(!tasks){
        tasks = [NSMutableArray new];
    }
    NSMutableDictionary *taskDic = [NSMutableDictionary new];
    [taskDic setObject:task forKey:@"task"];
    [taskDic setObject:@(type) forKey:@"type"];
    [tasks addObject:taskDic];
    [taskInfo setObject:tasks forKey:@"tasks"];
    [self.prerenderTasks setObject:taskInfo forKey:instance.scriptURL.absoluteString];
}









- (void)storePrerenderTasks:(NSMutableDictionary *)prerenderTasks forUrl:(NSString *)url
{
    [self.prerenderTasks setObject:prerenderTasks forKey:url];
}

- (void)removePrerenderTaskforUrl:(NSString *)url
{
    if (url) {
        [self.prerenderTasks removeObjectForKey:url];
    }
}


- (id)prerenderModuleTasksForUrl:(NSString *)url
{
    return [self.prerenderModuleTasks objectForKey:url];
}

- (void)storePrerenderModuleTasks:(WXModuleMethod *)method forUrl:(NSString *)url
{
    NSMutableArray *m = [self.prerenderModuleTasks objectForKey:url];
    if (!m){
        m = [NSMutableArray new];
    }
    [m addObject:method];
    [self.prerenderModuleTasks setObject:m forKey:url];}

- (void)removePrerenderModuleTaskforUrl:(NSString *)url
{
    if (url) {
        [self.prerenderModuleTasks removeObjectForKey:url];
    }
}

- (void)excuteModuleTasksForUrl:(NSString *)url
{
    NSMutableArray *m = [self.prerenderModuleTasks objectForKey:url];
    
    if (m && [m count]>0){
        for (WXModuleMethod *method in m) {
            [method invoke];
        }
    }

    
}

@end
