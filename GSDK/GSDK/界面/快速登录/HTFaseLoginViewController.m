//
//  HTFaseLoginViewController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/4.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTFaseLoginViewController.h"
#import "HTNameAndRequestModel.h"
#import "HTChangeAccountController.h"
#import "FacebookLogin.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <GameKit/GameKit.h>
#import "HTPhoneLogin.h"
@interface HTFaseLoginViewController ()<GIDSignInUIDelegate,GIDSignInDelegate>

@property (nonatomic,strong) HTBaseButton*fastLoginButton;

@property (nonatomic,strong) HTBaseLabel*otherLoginWayLabel;

@property (nonatomic,strong) UIImageView*imageView;

@property (nonatomic,strong)HTPhoneLogin*login;

@end

static BOOL a=NO;

@implementation HTFaseLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(instancetype)init
{
    if (self=[super init]) {
    
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW,((SCREEN_HEIGHT-MAINVIEW_WIDTH*0.67)/2),MAINVIEW_WIDTH,MAINVIEW_WIDTH*0.67);
        
        self.backImageView.image=imageNamed(@"底板_1");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=@"登錄";
        
        [self configUI];
}
    return self;
}
-(BOOL)isFirstLogin
{
    if ([USER_DEFAULT objectForKey:@"first"]) {
        return NO;
    }else
    {
        return YES;
    }
}

-(void)configUI
{
    [self setFastLoginButton];
    [self setOtherLoginWayLabel];
    [self setOtherLoginButton];
}
-(void)setFastLoginButton
{
    self.fastLoginButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    
    self.fastLoginButton.frame=CGRectMake(25,self.mainView.height*(130/370.0), self.mainView.width-50, self.mainView.height*(80/370.0));
    
    HTBaseLabel*inforLabel=[[HTBaseLabel alloc]init];
    inforLabel.frame=CGRectMake(23/550.0*MAINVIEW_WIDTH,93/550.0*MAINVIEW_WIDTH, 0, 0);
    [self.mainView addSubview:inforLabel];
    
    [self.fastLoginButton setTitle:bendihua(@"進入遊戲") font:MXSetSysFont(16) backColor:CRedColor corner:4];
    if ([self isFirstLogin]) {
        
        [self.fastLoginButton setTitle:bendihua(@"快速登錄") forState:(UIControlStateNormal)];
        
    }else
    {
        [inforLabel setText:bendihua(@"當前賬號：") font:MXSetSysFont(9) color:CRedColor sizeToFit:YES];
    }
    
    HTBaseLabel*nameLabel=[[HTBaseLabel alloc]init];
    nameLabel.frame=CGRectMake(inforLabel.right, 0, 0, 0);
    [nameLabel setText:[HTBindInfo returnHomeName:[USER_DEFAULT objectForKey:@"userInfo"]] font:inforLabel.font color:inforLabel.textColor sizeToFit:YES];
    nameLabel.centerY=inforLabel.centerY;
    nameLabel.width=self.mainView.width-nameLabel.left-5;
    [self.mainView addSubview:nameLabel];
    
    
    [self.mainView addSubview:self.fastLoginButton];
    
    [self.fastLoginButton addTarget:self action:@selector(fastLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
}
-(void)fastLoginAction:(UIButton*)sender
{
    NSMutableURLRequest *request;
    if ([self isFirstLogin]) {
    //获取标识符
    NSString *identifier = GETUUID;
    //拼接字符串
    NSString*str=[NSString stringWithFormat:@"username=%@#device&name=%@&uuid=%@",identifier,[HTgetDeviceName deviceString],GETUUID];
    //加密
    NSString*rsaStr=[RSA encryptString:str];
    //拼接加密后文件
    NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json",[USER_DEFAULT objectForKey:@"appID"],rsaStr];
    //创建url
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //简历网络请求体
        request=[NSMutableURLRequest requestWithURL:url];
    }else
    {
        request=[HTNameAndRequestModel getModelFormUserDefault].requset;
        
    }
    [HTprogressHUD showjuhuaText:bendihua(@"快速進入中")];

    [HTNetWorking sendRequest:request ifSuccess:^(id response) {
        
        
        if ([response[@"code"]isEqualToNumber:@0]) {
            
            
            [HTConnect showAssistiveTouch];
            [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
            [HTConnect shareConnect].loginBackBlock(response,nil);
            [HTAlertView showAlertViewWithText:bendihua(@"登錄成功") com:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            }else
            {
                [HTAlertView showAlertViewWithText:@"登錄失敗" com:nil];
                }
    } failure:^(NSError *error) {
        
    }];
    
}
-(void)setOtherLoginWayLabel
{
    self.otherLoginWayLabel=[[HTBaseLabel alloc]init];
    
    self.otherLoginWayLabel.frame=CGRectMake(self.fastLoginButton.left, self.fastLoginButton.bottom+self.mainView.height*(57/370.0), self.fastLoginButton.width, 1);
    self.otherLoginWayLabel.backgroundColor=MXRGBColor(231, 87, 53);
    [self.mainView addSubview:self.otherLoginWayLabel];
    
    HTBaseLabel*textLabel=[[HTBaseLabel alloc]init];
    [textLabel setText:bendihua(@"其他登錄方式") font:MXSetSysFont(10) color:MXRGBColor(231, 87, 53) sizeToFit:YES];
    UIView*labelBackView=[[UIView alloc]init];
    labelBackView.backgroundColor=CWhiteColor;
    labelBackView.bounds=CGRectMake(-5, 0, textLabel.width+10, textLabel.height);
    [labelBackView addSubview:textLabel];
    labelBackView.centerX=self.otherLoginWayLabel.centerX;
    labelBackView.centerY=self.otherLoginWayLabel.centerY;
    [self.mainView addSubview:labelBackView];
    
}
-(void)setOtherLoginButton
{
    for (int i=0; i<5; i++) {
        
        HTBaseButton*button=[[HTBaseButton alloc]init];
        
        button.tag=99+i;
        
        button.frame=CGRectMake(self.otherLoginWayLabel.left+(((self.otherLoginWayLabel.width-250/550.0*MAINVIEW_WIDTH)/4.0+50/550.0*MAINVIEW_WIDTH)*i), self.otherLoginWayLabel.bottom+15, 50/550.0*MAINVIEW_WIDTH, 50/550.0*MAINVIEW_WIDTH);
        
        button.backgroundColor=COrangeColor;
        
        [self.mainView addSubview:button];
        
        NSArray*imagearray=@[imageNamed(@"渠道图标_1"),imageNamed(@"渠道图标_2"),imageNamed(@"渠道图标_3"),imageNamed(@"渠道图标_4"),imageNamed(@"渠道图标_4")];
        [button setImage:imagearray[i] forState:(UIControlStateNormal)];
        
        switch (button.tag) {
                case 99:
                [button addTarget:self action:@selector(PhoneLogin:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 100:
            [button addTarget:self action:@selector(FaceBookLogin:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 101:
            [button addTarget:self action:@selector(GameCenterLogin:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 102:
            [button addTarget:self action:@selector(GoogleLogin:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 103:
            [button addTarget:self action:@selector(AccountLogin:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            default:
                break;
        }
    }
}

-(void)FaceBookLogin:(HTBaseButton*)sender
{
    [FacebookLogin logInIfSuccess:^(id response, NSDictionary *FacebookDict) {
        
        [HTConnect showAssistiveTouch];
        [HTConnect shareConnect].loginBackBlock(response,FacebookDict);
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *error) {
    
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
        [HTprogressHUD showjuhuaText:bendihua(@"正在登錄")];
        NSString*str=[NSString stringWithFormat:@"username=%@#google&name=%@&uuid=%@&token=%@",[GIDSignIn sharedInstance].currentUser.profile.email,[GIDSignIn sharedInstance].currentUser.profile.name,[UUID getUUID],user.authentication.idToken];
        NSString*rsaStr=[RSA encryptString:str];
        NSString*urlStr=[NSString stringWithFormat:@"http://c.gamehetu.com/passport/login?app=%@&data=%@&format=json",[[NSUserDefaults standardUserDefaults]objectForKey:@"appID"],rsaStr];
        NSURL*url=[NSURL URLWithString:urlStr];
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url];
        
        
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
            
            if ([response[@"code"] isEqualToNumber:@0]) {
                
                [HTConnect showAssistiveTouch];
                [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
                NSDictionary*googleDic=[NSDictionary dictionaryWithObjectsAndKeys:[GIDSignIn sharedInstance].currentUser.userID, @"googleID",[GIDSignIn sharedInstance].currentUser.profile.name,@"googleName",user.authentication.idToken,@"googleToken",nil];
                
                //google登录成功返回
                [HTConnect shareConnect].loginBackBlock(response,googleDic);
                
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
-(void)PhoneLogin:(UIButton*)sender
{
    self.login=[[HTPhoneLogin alloc]init];
    [self.login loginWithPhoneNumber:self];
}
-(void)GameCenterLogin:(UIButton*)sender
{
    [self authenticateLocalPlayer];
}
-(void)GoogleLogin:(UIButton*)sender
{
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate=self;
    [[GIDSignIn sharedInstance] signIn];
}
-(void)AccountLogin:(UIButton*)sender
{
    HTChangeAccountController*account=[[HTChangeAccountController alloc]init];
    account.changeType=@0;
    [self.navigationController pushViewController:account animated:NO];
}
- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
  static  UIViewController*con;
    if(a)
    {
        a=NO;
        if ([UIDevice currentDevice].systemVersion.floatValue>=10.0) {
            [HTAlertView showAlertViewWithText:bendihua(@"@iOS 10用户需要手动到设置里面登录游戏中心") com:nil];
        };
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
        }else
        {
            [HTprogressHUD hiddenHUD];

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
    [[GKLocalPlayer localPlayer]loadPhotoForSize:GKPhotoSizeNormal withCompletionHandler:^(UIImage * _Nullable photo, NSError * _Nullable error) {
        
        if (error) {
            
        }else
        {
        
        UIImageView*imagev=[[UIImageView alloc]init];
        imagev.frame=CGRectMake(0, 0, 100, 100);
        imagev.image=photo;
        [self.mainView addSubview:imagev];
        imagev.backgroundColor=[UIColor greenColor];
        }
    }];
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
        [HTConnect shareConnect].loginBackBlock(response,nil);
        [HTConnect showAssistiveTouch];

            [HTAlertView showAlertViewWithText:bendihua(@"登錄成功") com:^{
                [self dismissViewControllerAnimated:YES
                                         completion:nil];
            }];
    }
        else{
            [HTAlertView showAlertViewWithText:bendihua(@"登錄失敗") com:nil];
        }
    }
     failure:^(NSError *error) {
    }];
}
@end
