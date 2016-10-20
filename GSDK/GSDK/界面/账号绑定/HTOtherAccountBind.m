//
//  HTOtherAccountBind.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/15.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTOtherAccountBind.h"
#import "HTbindButtonView.h"
#import "FacebookLogin.h"
#import "HTAddBindInfoTodict.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <GameKit/GameKit.h>

#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)
static BOOL a=NO;

@interface HTOtherAccountBind ()<GIDSignInUIDelegate,GIDSignInDelegate>

@end

@implementation HTOtherAccountBind

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_2");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"其他賬號綁定");
        [GIDSignIn sharedInstance].uiDelegate = self;
        [GIDSignIn sharedInstance].delegate=self;
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    HTBaseLabel*tipLabel=[[HTBaseLabel alloc]init];
    tipLabel.frame=CGRectMake(23/500.0*MAINVIEW_WIDTH, 93/400.0*MAINVIEW_HEIGHT, 0, 0);
    [tipLabel setText:bendihua(@"注：每個遊客只能綁定一個其他賬號") font:MXSetSysFont(8) color:CRedColor sizeToFit:YES];
    [self.mainView addSubview:tipLabel];
    
    HTbindButtonView*top=[[HTbindButtonView alloc]init];
   top.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 140/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    [top createView];
    top.leftLabel.text=bendihua(@"Facebook");
    top.centerLabel.text=bendihua(@"未綁定");
    [top.rightButton setTitle:bendihua(@"點擊綁定") forState:(UIControlStateNormal)];
    [top.rightButton setBackgroundColor:CRedColor];
    [top.rightButton addTarget:self action:@selector(FacebookBind:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:top];

    
    HTbindButtonView*center=[[HTbindButtonView alloc]init];
    center.frame = CGRectMake(0.09*MAINVIEW_WIDTH, top.bottom+32/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    [center createView];
    center.leftLabel.text=bendihua(@"Google+");
    center.centerLabel.text=bendihua(@"未綁定");
    [center.rightButton setTitle:bendihua(@"點擊綁定") forState:(UIControlStateNormal)];
    [center.rightButton setBackgroundColor:CRedColor];
    [center.rightButton addTarget:self action:@selector(GoogleBind:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:center];
    
    HTbindButtonView*down=[[HTbindButtonView alloc]init];
    down.frame = CGRectMake(0.09*MAINVIEW_WIDTH, center.bottom+32/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    [down createView];
    down.leftLabel.text=bendihua(@"Gamecenter");
    down.centerLabel.text=bendihua(@"未綁定");
    [down.rightButton setTitle:bendihua(@"點擊綁定") forState:(UIControlStateNormal)];
    [down.rightButton setBackgroundColor:CRedColor];
    [down.rightButton addTarget:self action:@selector(GamecenterBind:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.mainView addSubview:down];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)FacebookBind:(HTBaseButton*)sender
{
    [FacebookLogin getFacebookInfoIfSuccess:^{
        [HTAlertView showAlertViewWithText:bendihua(@"綁定成功") com:^{
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    if (error) {
        [[GIDSignIn sharedInstance] signOut];
        
    }else
    {
        NSString*appID=[USER_DEFAULT objectForKey:@"appID"];
        NSDictionary*userDic = [USER_DEFAULT objectForKey:@"userInfo"];
        NSString*dataStr=[NSString stringWithFormat:@"type=google&auth=%@&name=%@&token=%@",[GIDSignIn sharedInstance].currentUser.profile.email,[GIDSignIn sharedInstance].currentUser.profile.name,[userDic valueForKeyPath:@"data.token"]];
        NSString*RSADataStr=[RSA encryptString:dataStr];
        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/bind?app=%@&data=%@&format=json",appID,RSADataStr];
        NSURL*url=[NSURL URLWithString:urlStr];
        NSMutableURLRequest*requestq=[NSMutableURLRequest requestWithURL:url];
        [HTNetWorking sendRequest:requestq ifSuccess:^(id response) {
            
            if ([response[@"code"] isEqualToNumber:@0]) {
                [HTAddBindInfoTodict addInfoToDictType:@"google" auth_name:[GIDSignIn sharedInstance].currentUser.profile.name];
                [HTAlertView showAlertViewWithText:bendihua(@"綁定成功") com:^{
                    
                    [self.navigationController popViewControllerAnimated:NO];
                    
                }];

            }else if([response[@"code"] isEqualToNumber:@1])
            {
                [HTAlertView showAlertViewWithText:bendihua(@"綁定失敗,該賬號已綁定過") com:nil];
                
            }else
            {
                [HTAlertView showAlertViewWithText:bendihua(@"綁定失败") com:nil];
            }
            
        } failure:^(NSError *error) {
            
        }];

    }
}
-(void)GoogleBind:(HTBaseButton*)sender
{
    [[GIDSignIn sharedInstance] signIn];

}
-(void)GamecenterBind:(HTBaseButton*)sender
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
        [HTprogressHUD showjuhuaText:bendihua(@"正在綁定")];
        
        [self appleBind];
    }else{
        [HTprogressHUD showjuhuaText:bendihua(@"正在綁定")];
        __weak typeof (self)weakSelf = self;
        [localPlayer setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
            
            if (!error && viewcontroller)
            {
                con=viewcontroller;
                [weakSelf presentViewController:viewcontroller animated:YES completion:nil];
                
            }
            else if (error == nil&&viewcontroller==nil) {
                
                [self appleBind];
                
            }else if(error) {
                a=YES;
                [HTprogressHUD hiddenHUD];
                NSLog(@"error---%@",error);
            }
        })];
    }
}
-(void)appleBind
{
    
        NSString*appID=[USER_DEFAULT objectForKey:@"appID"];
        NSDictionary*userDic = [USER_DEFAULT objectForKey:@"userInfo"];
    NSString*dataStr=[NSString stringWithFormat:@"type=apple&auth=%@&name=%@&token=%@",[GKLocalPlayer localPlayer].playerID,
                      [GKLocalPlayer localPlayer].alias,[userDic valueForKeyPath:@"data.token"]];
        NSString*RSADataStr=[RSA encryptString:dataStr];
        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/bind?app=%@&data=%@&format=json",appID,RSADataStr];
        NSURL*url=[NSURL URLWithString:urlStr];
        NSMutableURLRequest*requestq=[NSMutableURLRequest requestWithURL:url];
        [HTNetWorking sendRequest:requestq ifSuccess:^(id response) {
            
            if ([response[@"code"] isEqualToNumber:@0]) {
                [HTAddBindInfoTodict addInfoToDictType:@"apple" auth_name:[GKLocalPlayer localPlayer].alias];
                [HTAlertView showAlertViewWithText:bendihua(@"綁定成功") com:^{
                    
                    [self.navigationController popViewControllerAnimated:NO];
                    
                }];
            }else if([response[@"code"] isEqualToNumber:@1])
            {
                [HTAlertView showAlertViewWithText:bendihua(@"綁定失敗,該賬號已綁定過") com:nil];
                
            }else
            {
                [HTAlertView showAlertViewWithText:bendihua(@"綁定失败") com:nil];
            }
            
        } failure:^(NSError *error) {
        }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
