//
//  HTChangeAccountList.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/16.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTChangeAccountList.h"
#import "HTNameAndRequestModel.h"
#import "HTChangeAccountController.h"
#import "FacebookLogin.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <GameKit/GameKit.h>
#import "FacebookLogin.h"
static BOOL a=NO;

#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(470/550.0)

@interface HTChangeAccountList ()<GIDSignInUIDelegate,GIDSignInDelegate>

@end

@implementation HTChangeAccountList

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    if (error) {
        [[GIDSignIn sharedInstance] signOut];
        
    }else
    {
        [HTprogressHUD showjuhuaText:bendihua(@"正在登錄")];
        NSString*str=[NSString stringWithFormat:@"username=%@#google&name=%@&uuid=%@&token=%@",[GIDSignIn sharedInstance].currentUser.userID,[GIDSignIn sharedInstance].currentUser.profile.name,[UUID getUUID],user.authentication.idToken];
        NSString*rsaStr=[RSA encryptString:str];
        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json",[[NSUserDefaults standardUserDefaults]objectForKey:@"appID"],rsaStr];
        NSURL*url=[NSURL URLWithString:urlStr];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
            
            if ([response[@"code"] isEqualToNumber:@0]) {
                [HTConnect showAssistiveTouch];
                [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
                NSDictionary*googleDic=[NSDictionary dictionaryWithObjectsAndKeys:[GIDSignIn sharedInstance].currentUser.profile.email, @"googleID",[GIDSignIn sharedInstance].currentUser.profile.name,@"googleName",user.authentication.idToken,@"googleToken",nil];
                
                //切换google账号登录成功返回
                [HTConnect shareConnect].changeAccount(response,googleDic);

                [HTAlertView showAlertViewWithText:bendihua(@"登錄成功") com:^{
                    [self dismissViewControllerAnimated:YES completion:nil];

                }];
            }else
            {
                [HTAlertView showAlertViewWithText:bendihua(@"登錄失敗") com:nil];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    [[GIDSignIn sharedInstance] signOut];
}

-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_3");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"賬號切換");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    HTBaseLabel*titleLabel=[[HTBaseLabel alloc]init];
    titleLabel.frame=CGRectMake(0, 93/470.0*MAINVIEW_HEIGHT, 0, 0);
    [titleLabel setText:bendihua(@"請選擇登錄方式") font:MXSetSysFont(16) color:CRedColor sizeToFit:YES];
    titleLabel.centerX=MAINVIEW_WIDTH/2;
    [self.mainView addSubview:titleLabel];
    
    HTBaseButton*offical=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    offical.frame=CGRectMake(0.09*MAINVIEW_WIDTH,160/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    [offical setTitle:bendihua(@"官方賬號") font:MXSetSysFont(13) backColor:CGreenColor corner:4];
    [offical addTarget:self action:@selector(accountAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:offical];
    
    HTBaseButton*facebook=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    facebook.frame=CGRectMake(0.09*MAINVIEW_WIDTH,offical.bottom+ 17/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    [facebook setTitle:bendihua(@"Facebook") font:MXSetSysFont(13) backColor:CRedColor corner:4];
    [facebook addTarget:self action:@selector(facebookAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:facebook];

    HTBaseButton*Google=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    Google.frame=CGRectMake(0.09*MAINVIEW_WIDTH,facebook.bottom+17/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    [Google setTitle:bendihua(@"Google+") font:MXSetSysFont(13) backColor:CRedColor corner:4];
    [Google addTarget:self action:@selector(googleAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:Google];

    HTBaseButton*Gamecenter=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    Gamecenter.frame=CGRectMake(0.09*MAINVIEW_WIDTH,Google.bottom+17/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    [Gamecenter setTitle:bendihua(@"Gamecenter") font:MXSetSysFont(13) backColor:CRedColor corner:4];
    [Gamecenter addTarget:self action:@selector(gamecenterAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:Gamecenter];
}
-(void)accountAction:(HTBaseButton*)sender
{
    HTChangeAccountController*account=[[HTChangeAccountController alloc]init];
    //记录切换账号界面是从哪里跳出
    account.changeType=@1;
    [self.navigationController pushViewController:account animated:YES];
    
}
-(void)facebookAction:(HTBaseButton*)sender
{
    [FacebookLogin logInIfSuccess:^(id response, NSDictionary *FacebookDict) {
        [HTConnect shareConnect].changeAccount(response,FacebookDict);

        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
    }];

}
-(void)googleAction:(HTBaseButton*)sender
{
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate=self;
    [[GIDSignIn sharedInstance] signIn];

}
-(void)gamecenterAction:(HTBaseButton*)sender
{
    [self authenticateLocalPlayer];
}
- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    static  UIViewController*con;
    if(a)
    {
        a=NO;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
    }else if (localPlayer.authenticated) {
        [HTprogressHUD showjuhuaText:bendihua(@"正在登錄")];
        
        [self gameCenterLoginConnection];
    }else{
        [HTprogressHUD showjuhuaText:bendihua(@"正在登錄")];
        __weak typeof (self)weakSelf = self;
        [localPlayer setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
            
            if (!error && viewcontroller)
            {
                con=viewcontroller;
                [weakSelf presentViewController:viewcontroller animated:YES completion:nil];
                
            }
            else if (error == nil&&viewcontroller==nil) {
                
                [self gameCenterLoginConnection];
                
            }else if(error) {
                a=YES;
                [HTprogressHUD hiddenHUD];
                NSLog(@"error---%@",error);
            }
        })];
    }
}
-(void)gameCenterLoginConnection
{
    NSString*str=[NSString stringWithFormat:@"username=%@#apple&name=%@&uuid=%@",
                  [GKLocalPlayer localPlayer].playerID,
                  [GKLocalPlayer localPlayer].alias,
                  [UUID getUUID]];
    
    NSString*urlStr=[NSString stringWithFormat:@"app=%@&data=%@&format=json",
                     [USER_DEFAULT objectForKey:@"appID"],
                     [RSA encryptString:str]];
    
    NSString*mainStr=@"http://c.gamehetu.com/passport/login";
    
    //這是為了保存request準備的
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:mainStr] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:15];
    [request setHTTPMethod:@"POST"];
    
    NSData*paraData=[urlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:paraData];
    
    [HTNetWorking sendRequest:request ifSuccess:^(id response) {
        
        [HTprogressHUD hiddenHUD];
        
        if ([response[@"code"] isEqualToNumber:@0]) {
            [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
            [HTConnect shareConnect].changeAccount(response,nil);
            [HTConnect showAssistiveTouch];
            [HTAlertView showAlertViewWithText:bendihua(@"登錄成功") com:^{
                [self dismissViewControllerAnimated:YES
                                         completion:nil];
            }];
        }else{
            [HTAlertView showAlertViewWithText:bendihua(@"登錄失敗") com:nil];
        }
    } failure:^(NSError *error) {
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
