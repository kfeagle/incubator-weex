//
//  WXConfigCenterDefaultImpl.m
//  WeexDemo
//
//  Created by 齐山 on 17/5/12.
//  Copyright © 2017年 taobao. All rights reserved.
//

#import "WXConfigCenterDefaultImpl.h"

@implementation WXConfigCenterDefaultImpl

- (id)configForKey:(NSString *)key defaultValue:(id)defaultValue isDefault:(BOOL *)isDefault
{
    NSArray<NSString*>* keys = [key componentsSeparatedByString:@"."];
    if (keys[0] && keys[1]) {
        if([keys[0] isEqualToString:@"iOS_weex_ext_config"] && [keys[1] isEqualToString:@"text_render_useCoreText"]){
            return @true;
        }
        if([keys[0] isEqualToString:@"iOS_weex_ext_config"] && [keys[1] isEqualToString:@"slider_class_name"]){
            return @"WXCycleSliderComponent";
        }
        if([keys[0] isEqualToString:@"weex_prerender_config"] && [keys[1] isEqualToString:@"is_switch_on"]){
            return @true;
        }
        if([keys[0] isEqualToString:@"weex_prerender_config"] && [keys[1] isEqualToString:@"time"]){
            return @300000;
        }
        if([keys[0] isEqualToString:@"weex_prerender_config"] && [keys[1] isEqualToString:@"max_cache_num"]){
            return @1;
        }
    }
    return nil;
}

@end
