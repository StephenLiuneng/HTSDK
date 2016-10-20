//
//  HTNetWorking.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/9.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTNetWorking.h"

@implementation HTNetWorking
+(void)POST:(NSString*)URL paramString:(NSString*)paramString ifSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    
    NSData*paraData=[paramString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:paraData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [HTprogressHUD hiddenHUD];

        if (data) {
    
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSLog(@"%@",dict);
            success(dict);
            
        }else
        {
            NSLog(@"%@",connectionError);
            [HTAlertView showAlertViewWithText:bendihua(@"網絡連接失敗") com:nil];
            failure(connectionError);
        }
    }];
}
+(void)sendRequest:(NSMutableURLRequest*)request ifSuccess:(void(^)(id response))success failure:(void (^)(NSError *error))failure
{
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [HTprogressHUD hiddenHUD];

        if (data) {
            
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            NSLog(@"%@",dict);
            success(dict);
            
        }else
        {
            NSLog(@"%@",connectionError);
            failure(connectionError);
            [HTAlertView showAlertViewWithText:bendihua(@"網絡連接失敗") com:nil];
        }
    }];

}
@end

