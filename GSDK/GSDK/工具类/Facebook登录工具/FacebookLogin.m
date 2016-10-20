//
//  FacebookLogin.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/5.
//  Copyright © 2016年 王璟鑫. All rights reserved

#import "HTNameAndRequestModel.h"
#import "FacebookLogin.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "HTAddBindInfoTodict.h"
@implementation FacebookLogin

+(void)logInIfSuccess:(void(^)(id response, NSDictionary*FacebookDict))success failure:(void(^)(NSError*error))failure
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if ([FBSDKAccessToken currentAccessToken]!=nil) {
//        [login logOut];
    }
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    
    [login
     logInWithReadPermissions: @[@"public_profile",@"read_custom_friendlists",@"user_friends",@"email"]
     fromViewController:MXRootViewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
             failure(error);
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");

         } else {
             NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            @"name,id",@"fields",
                                            nil];
             FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:@"me"
                                           parameters:params
                                           HTTPMethod:@"GET"];
             [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                   id result,
                                                   NSError *error) {
                 NSLog(@"----------%@",result);
    if (result) {
                     
        [HTprogressHUD  showjuhuaText:bendihua(@"正在登錄")];
                     
        NSString*str=[NSString stringWithFormat:@"username=%@#facebook&name=%@&uuid=%@&token=%@",result[@"id"],result[@"name"],[UUID getUUID],[FBSDKAccessToken currentAccessToken].tokenString];
                     
        NSString*rsaStr=[RSA encryptString:str];
        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json",[[NSUserDefaults standardUserDefaults]objectForKey:@"appID"],rsaStr];
        NSURL*url=[NSURL URLWithString:urlStr];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        
        
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
             NSDictionary*facebookDict=[NSDictionary dictionaryWithObjectsAndKeys:result[@"id"], @"facebookID",result[@"name"],@"facebookName",[FBSDKAccessToken currentAccessToken].tokenString,@"facebookToken",nil];
            if ([response[@"code"]isEqualToNumber:@0]) {
                [HTConnect showAssistiveTouch];

                [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
                success(response,facebookDict);
            }else
            {

            }

        } failure:^(NSError *error) {
            
        }];
                 }
            else
                 {
                     failure(error);
                     NSLog(@"%@Facebook登录出错",error);
                     [HTAlertView showAlertViewWithText:bendihua(@"網絡連接失敗") com:nil];

                 }
             }];
         }
     }];

}
+(void)getFacebookInfoIfSuccess:(void(^)())success{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if ([FBSDKAccessToken currentAccessToken]!=nil) {
    }
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    [login
     logInWithReadPermissions: @[@"public_profile",@"read_custom_friendlists",@"user_friends",@"email"]
     fromViewController:MXRootViewController
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
             
         } else {
             NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"name,id",@"fields",nil];
             FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                        initWithGraphPath:@"me"                                           parameters:params
                                           HTTPMethod:@"GET"];
             [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,id result,NSError *error) {
                 
                 NSLog(@"----------%@",result);
                if (result) {
                     NSString*appID=[USER_DEFAULT objectForKey:@"appID"];
                     NSDictionary*userDic = [USER_DEFAULT objectForKey:@"userInfo"];
                     NSString*dataStr=[NSString stringWithFormat:@"type=facebook&auth=%@&name=%@&token=%@",result[@"id"],result[@"name"],[userDic valueForKeyPath:@"data.token"]];
                     NSString*RSADataStr=[RSA encryptString:dataStr];
                     NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/bind?app=%@&data=%@&format=json",appID,RSADataStr];
                     NSURL*url=[NSURL URLWithString:urlStr];
                     NSMutableURLRequest*requestq=[NSMutableURLRequest requestWithURL:url];
                     [HTNetWorking sendRequest:requestq ifSuccess:^(id response) {
                         
                         if ([response[@"code"] isEqualToNumber:@0]) {
                             [HTAddBindInfoTodict addInfoToDictType:@"facebook" auth_name:result[@"name"]];
                             success();
                         
                         }else if([response[@"code"] isEqualToNumber:@1])
                         {
                             [HTAlertView showAlertViewWithText:bendihua(@"綁定失敗,該賬號已綁定過") com:nil];
                             
                         }else
                         {
                             [HTAlertView showAlertViewWithText:bendihua(@"綁定失败") com:nil];
                         }
                         
                     } failure:^(NSError *error) {
                         [HTAlertView showAlertViewWithText:bendihua(@"綁定失败") com:nil];

                     }];

                 }

                 else
                 {
                     [HTAlertView showAlertViewWithText:bendihua(@"網絡連接失敗") com:nil];

                 }
                 
             }];
         }
     }];
    
}


@end
