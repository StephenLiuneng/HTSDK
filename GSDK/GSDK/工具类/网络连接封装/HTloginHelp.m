//  HTloginHelp.m
//  NewSDkBy
//
//  Created by 王璟鑫 on 16/1/15.
//  Copyright © 2016年 www.gamehetu.com. All rights reserved.
//
#import "HTgetDeviceName.h"
#import "HTloginHelp.h"
#import "RSA.h"
#import "UUID.h"

@implementation HTloginHelp

+(NSMutableURLRequest*)returnRequest:(NSString*)mainStr usernameTextField:(UITextField*)usernameTextField passwordTextField:(UITextField*)passwordTextField
{
    NSString*nameAndWord;
    //主体
    NSURL*url=[NSURL URLWithString:mainStr];
    
    nameAndWord=[NSString stringWithFormat:@"username=%@&password=%@&uuid=%@",usernameTextField.text,passwordTextField.text,[UUID getUUID]];
  
   
    //将获取的信息加密
    NSString*dataStr=[RSA encryptString:nameAndWord];
    NSString*appId=[USER_DEFAULT objectForKey:@"appID"];
    NSString*parmaStr=[NSString stringWithFormat:@"app=%@&data=%@&format=json",appId,dataStr];
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    NSData*paraData=[parmaStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:paraData];
    return request;
}
+(NSString*)returnLoginString
{
NSString*str=@"http://c.gamehetu.com/passport/login?";
    return str;
}
+(NSString*)returnSignupString
{
    NSString*str=@"http://c.gamehetu.com/passport/register?";
    return str;
}
+(NSDictionary*)jsonBecomeDict:(NSData*)data
{
    NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
    return dict;
}


@end
