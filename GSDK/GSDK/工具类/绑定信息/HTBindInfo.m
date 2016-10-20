//
//  HTBindInfo.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/23.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTBindInfo.h"

@implementation HTBindInfo


+(instancetype)shareBindInfo
{
    static HTBindInfo*bindInfo;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        bindInfo=[[HTBindInfo alloc]init];
        
    });
    
    return bindInfo;
}

+(NSString*)returnHomeName:(NSDictionary*)dict
{
    NSArray*arr=[[dict valueForKeyPath:@"data.bind"] allKeys];

    if ([arr containsObject:@"email"]) {
    
        return [dict valueForKeyPath:@"data.bind.email.auth_id"];
    
    }else if([arr containsObject:@"phone"])
    {
        return [dict valueForKeyPath:@"phone"];

    }
    else if([arr containsObject:@"facebook"])
    {
        return [dict valueForKeyPath:@"data.bind.facebook.auth_name"];
    
    }else if([arr containsObject:@"google"])
    {
        
        return [dict valueForKeyPath:@"data.bind.google.auth_name"];
        
    }else if([arr containsObject:@"apple"])
    {
        
        return [dict valueForKeyPath:@"data.bind.apple.auth_name"];
        
    }else
    {
        return [dict valueForKeyPath:@"data.bind.device.auth_id"];

    }
}

+(BOOL)haveBindOfficalAccount
{
    NSDictionary*dict=[USER_DEFAULT objectForKey:@"userInfo"];
    NSArray*arr=[[dict valueForKeyPath:@"data.bind"] allKeys];
    
    return [arr containsObject:@"email"];
}
+(BOOL)haveBindThridAccount
{
    NSDictionary*dict=[USER_DEFAULT objectForKey:@"userInfo"];
    NSArray*arr=[[dict valueForKeyPath:@"data.bind"] allKeys];
    
    if ([arr containsObject:@"facebook"]){
     return YES;
    }else if([arr containsObject:@"google"]){
        return YES;
    }else if([arr containsObject:@"apple"])
    {
        return YES;
    }else
    {
        return NO;
    }
}

+(NSDictionary*)showBindAccountName
{
    NSDictionary*dict=[USER_DEFAULT objectForKey:@"userInfo"];

    NSDictionary*userInfo;
    if ([self haveBindOfficalAccount]) {
        
        userInfo=[NSDictionary dictionaryWithObjectsAndKeys:@"email",@"type",[dict valueForKeyPath:@"data.bind.email.auth_id"],@"name", nil];
        
        return userInfo;
    }else
    {
        NSArray*arr=[[dict valueForKeyPath:@"data.bind"] allKeys];

        if ([self haveBindThridAccount]) {
            
            if ([arr containsObject:@"facebook"]) {
            userInfo=[NSDictionary dictionaryWithObjectsAndKeys:imageNamed(@"渠道图标_1"),@"image",@"facebook",@"type",[dict valueForKeyPath:@"data.bind.facebook.auth_name"],@"name", nil];
                return userInfo;
                
            }else if([arr containsObject:@"google"])
            {
                userInfo=[NSDictionary dictionaryWithObjectsAndKeys:imageNamed(@"渠道图标_3"),@"image",@"google",@"type",[dict valueForKeyPath:@"data.bind.google.auth_name"],@"name", nil];
                return userInfo;
                
            }else
            {
                userInfo=[NSDictionary dictionaryWithObjectsAndKeys:imageNamed(@"渠道图标_2"),@"image",@"gamecenter",@"type",[dict valueForKeyPath:@"data.bind.apple.auth_name"],@"name", nil];
                return userInfo;
            }
           
        }else//设备登录,没有绑定
        {
            userInfo=[NSDictionary dictionaryWithObjectsAndKeys:@"device",@"type",[dict valueForKeyPath:@"data.bind.device.auth_id"],@"name", nil];
            
            return userInfo;
        }
    }
    return nil;
}

@end
