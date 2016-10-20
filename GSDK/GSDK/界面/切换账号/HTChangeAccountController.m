//
//  HTChangeAccountController.m
//  GSDK
//  Created by 王璟鑫 on 16/8/16.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTChangeAccountController.h"
#import "HTTextField.h"
#import "HTNameAndRequestModel.h"
#import "HTAlertView.h"
#import "HTRegisterController.h"
#import "HTloginHelp.h"
#import "HTforgetPasswordController.h"

#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)

@interface HTChangeAccountController ()
{
    HTTextField*top;
    HTTextField*bottom;
}
@end

@implementation HTChangeAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_2");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"切換賬號");
        [self configUI];
    }
    return self;
}


-(void)configUI
{
    top=[[HTTextField alloc]init];
    top.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 103/400.0*MAINVIEW_HEIGHT,0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    top.placeholder=bendihua(@"請輸入賬號");
    [self.mainView addSubview:top];

    
    bottom=[[HTTextField alloc]init];
    bottom.frame = CGRectMake(0.09*MAINVIEW_WIDTH, top.bottom+32/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    bottom.clearButtonMode=YES;
    bottom.secureTextEntry=YES;
    bottom.placeholder=bendihua(@"請輸入密碼");

    [self.mainView addSubview:bottom];
    
    HTBaseButton*leftbutton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    leftbutton.frame=CGRectMake(bottom.left,bottom.bottom+56/400.0*MAINVIEW_HEIGHT, 110/400.0*MAINVIEW_WIDTH,50/400.0*MAINVIEW_HEIGHT);
    [leftbutton setTitle:bendihua(@"賬號註冊") font:MXSetSysFont(11) backColor:CRedColor corner:4];
    [leftbutton addTarget:self action:@selector(registerBUtton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:leftbutton];
    
    HTBaseButton*rightButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    rightButton.frame=CGRectMake(bottom.right-110/400.0*MAINVIEW_WIDTH,bottom.bottom+56/400.0*MAINVIEW_HEIGHT, 110/400.0*MAINVIEW_WIDTH,50/400.0*MAINVIEW_HEIGHT);
    [rightButton setTitle:bendihua(@"登錄") font:MXSetSysFont(11) backColor:CGreenColor corner:4];

    [rightButton addTarget:self action:@selector(loginButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:rightButton];

    
    HTBaseButton*forgetPassword=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:bendihua(@"忘記密碼")];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:CTextGrayColor range:strRange];
    [str addAttribute:NSUnderlineColorAttributeName
                    value:CTextGrayColor
                    range:strRange];
    
    [forgetPassword setAttributedTitle:str forState:UIControlStateNormal];
    forgetPassword.titleLabel.font=MXSetSysFont(10);
    [forgetPassword sizeToFit];
    forgetPassword.frame=CGRectMake(rightButton.right-forgetPassword.width,rightButton.bottom+ 8/400.0*MAINVIEW_HEIGHT , forgetPassword.width, forgetPassword.height);
    [forgetPassword addTarget:self action:@selector(forgetPasswordButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:forgetPassword];
    
}
-(void)forgetPasswordButtonAction:(HTBaseButton*)sender
{
    HTforgetPasswordController*con=[[HTforgetPasswordController alloc]init];
    [self.navigationController pushViewController:con animated:YES];

}
-(void)registerBUtton:(HTBaseButton*)sender
{
    HTRegisterController*registe=[[HTRegisterController alloc]init];
    [self.navigationController pushViewController:registe animated:NO];
    
}
-(void)loginButton:(HTBaseButton*)sender
{
    if([top.text isEqualToString:@""]||[bottom.text isEqualToString:@""])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"用戶名或密碼不能為空") com:nil];
        
    }else if (!(bottom.text.length>=6&&bottom.text.length<=16))
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密碼長度應在6位至16位之間") com:nil];

    }else if (!(top.text.length>=6&&bottom.text.length<=32)){
        
        [HTAlertView showAlertViewWithText:bendihua(@"用戶名長度應在6位至32位之間") com:nil];
    }
    //用户名或密码是否为空
    else if (![regex validateUserName:top.text])
    {
     
        [HTAlertView showAlertViewWithText:bendihua(@"您輸入的用戶名包含非法字元，用戶名只能由字母、數位、底線組成") com:nil];
    }else
    {
         [HTprogressHUD showjuhuaText:bendihua(@"正在登錄")];
        NSMutableURLRequest *request=[HTloginHelp returnRequest:[HTloginHelp returnLoginString] usernameTextField:top passwordTextField:bottom];
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
           
            if ([response[@"code"] isEqualToNumber:@0]) {
                [HTNameAndRequestModel setFastRequest:request AndNameFormdict:response];
                
                //账号登陆成功返回
                if ([self.changeType isEqualToNumber:@0]) {
                 [HTConnect shareConnect].loginBackBlock(response,nil);
                }else
                {
                [HTConnect shareConnect].changeAccount(response,nil);
                }
                [HTAlertView showAlertViewWithText:bendihua(@"登陸成功") com:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [HTConnect showAssistiveTouch];
                }];
        }else if ([response[@"code"]isEqualToNumber:@40101]){
            
            [HTAlertView showAlertViewWithText:bendihua(@"用戶名或密碼為空") com:nil];
            
        }else if ([response[@"code"]isEqualToNumber:@40105])
         {
             [HTAlertView showAlertViewWithText:bendihua(@"用戶名或密碼錯誤") com:nil];
         }else
         {
             [HTAlertView showAlertViewWithText:bendihua(@"登錄失敗") com:nil];
         }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
}


-(void)dealloc
{
    
}
@end
