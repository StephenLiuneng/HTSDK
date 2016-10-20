//
//  HTPhoneLogin.m
//  NEWFacebookSDK
//
//  Created by 王璟鑫 on 16/10/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTPhoneLogin.h"
#import <AccountKit/AccountKit.h>


@interface HTPhoneLogin ()<AKFViewControllerDelegate>


@end

@implementation HTPhoneLogin{
    AKFAccountKit *_accountKit;
    UIViewController<AKFViewController> *_pendingLoginViewController;
    
}
-(void)loginWithPhoneNumber:(UIViewController*)con
{
    if (_accountKit == nil) {
        _accountKit = [[AKFAccountKit alloc] initWithResponseType:
                       AKFResponseTypeAccessToken];
    }
    AKFPhoneNumber *preFillPhoneNumber = [[AKFPhoneNumber alloc]initWithCountryCode:@"86" phoneNumber:@""];
    NSString *inputState = [[NSUUID UUID] UUIDString];
    UIViewController<AKFViewController> *viewController = [_accountKit viewControllerForPhoneLoginWithPhoneNumber:preFillPhoneNumber
                                                                                                            state:inputState];
    viewController.delegate=self;
    [con presentViewController:viewController animated:YES completion:NULL];

}
- (void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAuthorizationCode:(NSString *)code state:(NSString *)state
{
    
}
- (void)viewController:(UIViewController<AKFViewController> *)viewController didCompleteLoginWithAccessToken:(id<AKFAccessToken>)accessToken state:(NSString *)state
{
    AKFAccountKit *accountKit = [[AKFAccountKit alloc] initWithResponseType:AKFResponseTypeAuthorizationCode];

    [accountKit requestAccount:^(id<AKFAccount>  _Nullable account, NSError * _Nullable error) {
        
        [account accountID];
        
            NSString*phoneNum=[[account phoneNumber] stringRepresentation];
        
            NSString*dataStr=[NSString stringWithFormat:@"username=%@#facebook&name=%@&uuid=%@&token=%@",phoneNum,phoneNum,GETUUID,[accessToken tokenString]];
        
            //加密
            NSString*rsaStr=[RSA encryptString:dataStr];
            //拼接加密后文件
            NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json",[USER_DEFAULT objectForKey:@"appID"],rsaStr];
            //创建url
            NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            //简历网络请求体
        NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:url];
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
           
            NSLog(@"%@",response);
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
}
- (void)viewController:(UIViewController<AKFViewController> *)viewController didFailWithError:(NSError *)error
{
    
}
- (void)viewControllerDidCancel:(UIViewController<AKFViewController> *)viewController
{
    NSString*dataStr=[NSString stringWithFormat:@"username=%@#facebook&name=%@&uuid=%@",@"+18646546435",@"+18646546435",GETUUID];
    
    //加密
    NSString*rsaStr=[RSA encryptString:dataStr];
    //拼接加密后文件
    NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json",[USER_DEFAULT objectForKey:@"appID"],rsaStr];
    //创建url
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //简历网络请求体
    NSMutableURLRequest * request=[NSMutableURLRequest requestWithURL:url];
    [HTNetWorking sendRequest:request ifSuccess:^(id response) {
        [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];

        NSLog(@"%@",response);
        
    } failure:^(NSError *error) {
        
    }];

}

@end
