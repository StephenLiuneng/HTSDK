//
//  HTRegisterController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/18.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#import "HTTextField.h"
#import "HTRegisterController.h"
#import "HTAlertView.h"
#import "HTNameAndRequestModel.h"
#import "HTloginHelp.h"
#import "HTLegalInformation.h"
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)

@interface HTRegisterController ()

@end

@implementation HTRegisterController{
    HTTextField*top;
    HTTextField*bottom;
    HTTextField*center;
    HTBaseButton*fangkuangButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_2");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"賬號注册");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    top=[[HTTextField alloc]init];
    top.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 89/400.0*MAINVIEW_HEIGHT,0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    top.placeholder=bendihua(@"請輸入有效郵箱賬號");
    [self.mainView addSubview:top];
    
    center=[[HTTextField alloc]init];
    center.frame = CGRectMake(0.09*MAINVIEW_WIDTH, top.bottom+11/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    center.clearButtonMode=YES;
    center.secureTextEntry=YES;
    center.placeholder=bendihua(@"請輸入新密碼");
    [self.mainView addSubview:center];
    
    bottom=[[HTTextField alloc]init];
    bottom.frame = CGRectMake(0.09*MAINVIEW_WIDTH, center.bottom+11/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    bottom.clearButtonMode=YES;
    bottom.secureTextEntry=YES;
    bottom.placeholder=bendihua(@"請再次輸入密碼");
    [self.mainView addSubview:bottom];
    

    fangkuangButton=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    fangkuangButton.frame=CGRectMake(bottom.left, bottom.bottom+19/400.0*MAINVIEW_HEIGHT, 33/550.0*MAINVIEW_WIDTH, 27/550.0*MAINVIEW_WIDTH);
    [fangkuangButton setImage:imageNamed(@"方形选择_2") forState:(UIControlStateNormal)];
    [fangkuangButton setImage:imageNamed(@"方形选择_1") forState:(UIControlStateSelected)];
    [fangkuangButton addTarget:self action:@selector(fangkuangAcction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:fangkuangButton];
    
    
    HTBaseLabel*woTongYi=[[HTBaseLabel alloc]init];
    woTongYi.frame=CGRectMake(fangkuangButton.right+2, fangkuangButton.top, 0, 0);
    [woTongYi setText:bendihua(@"我同意") font:MXSetSysFont(10) color:CTextGrayColor sizeToFit:YES];
    woTongYi.centerY=fangkuangButton.centerY+1;
    [self.mainView addSubview:woTongYi];
    
    
    HTBaseButton*fuWuTiaoKuan=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    fuWuTiaoKuan.frame=CGRectMake(woTongYi.right+2, woTongYi.top, 0, 0);
    NSMutableAttributedString *fuwuStr = [[NSMutableAttributedString alloc] initWithString:bendihua(@"服務條款")];
    NSRange strRange = {0,[fuwuStr length]};
    [fuwuStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [fuwuStr addAttribute:NSForegroundColorAttributeName value:CTextGrayColor range:strRange];
    [fuwuStr addAttribute:NSUnderlineColorAttributeName
                value:CTextGrayColor
                range:strRange];
    [fuWuTiaoKuan setAttributedTitle:fuwuStr forState:UIControlStateNormal];
    fuWuTiaoKuan.titleLabel.font=MXSetSysFont(10);
    [fuWuTiaoKuan sizeToFit];
    fuWuTiaoKuan.centerY=woTongYi.centerY;
    [self.mainView addSubview:fuWuTiaoKuan];
    [fuWuTiaoKuan addTarget:self action:@selector(fuWuTiaoKuan:) forControlEvents:UIControlEventTouchUpInside];
    
    
    HTBaseLabel*he=[[HTBaseLabel alloc]init];
    he.frame=CGRectMake(fuWuTiaoKuan.right+2, 0, 0, 0);
    [he setText:bendihua(@"和") font:woTongYi.font color:CTextGrayColor sizeToFit:YES];
    he.centerY=fuWuTiaoKuan.centerY;
    [self.mainView addSubview:he];
    
    
    
    HTBaseButton*yinSiTiaoKuan=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    yinSiTiaoKuan.frame=CGRectMake(he.right+2, he.top, 0, 0);
    NSMutableAttributedString *yinSiStr = [[NSMutableAttributedString alloc] initWithString:bendihua(@"隱私條款")];
    NSRange yiStrRange = {0,[yinSiStr length]};
    [yinSiStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:yiStrRange];
    [yinSiStr addAttribute:NSForegroundColorAttributeName value:CTextGrayColor range:yiStrRange];
    [yinSiStr addAttribute:NSUnderlineColorAttributeName
                value:CTextGrayColor
                range:yiStrRange];

    [yinSiTiaoKuan setAttributedTitle:yinSiStr forState:UIControlStateNormal];
    yinSiTiaoKuan.titleLabel.font=MXSetSysFont(10);
    [yinSiTiaoKuan sizeToFit];
    yinSiTiaoKuan.centerY=he.centerY;
    [self.mainView addSubview:yinSiTiaoKuan];
    [yinSiTiaoKuan addTarget:self action:@selector(yinSiTiaoKuan:) forControlEvents:UIControlEventTouchUpInside];
    
    HTBaseButton*regisAndLogin=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    [regisAndLogin setTitle:bendihua(@"註冊并登錄") font:MXSetSysFont(11) backColor:CRedColor corner:4];
    regisAndLogin.frame=CGRectMake(0,fangkuangButton.bottom+20/400.0*MAINVIEW_HEIGHT, 0.45*MAINVIEW_WIDTH, 46/400.0*MAINVIEW_HEIGHT);
    regisAndLogin.centerX=self.mainView.width/2;
    [regisAndLogin addTarget:self action:@selector(regisAndLoginAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:regisAndLogin];
}
-(void)fangkuangAcction:(HTBaseButton*)sender
{
    if (!sender.selected) {
        
        sender.selected=YES;
        
    }else
    {
        sender.selected=NO;
    }
}
-(void)regisAndLoginAction:(HTBaseButton*)sender
{
    //判断用户名或密码不能为空
    if ([top.text isEqualToString:@""]||[center.text isEqualToString:@""])
    {

        [HTAlertView showAlertViewWithText:bendihua(@"用戶名或密碼不能為空") com:nil];
    }
    //判断用户
    else if (![regex isValidateEmail:top.text])
    {
     
        [HTAlertView showAlertViewWithText:bendihua(@"請輸入常用郵箱,方便密碼找回") com:nil];
    }
    else if (!(center.text.length>=6&&center.text.length<=16))
    {
      
        [HTAlertView showAlertViewWithText:bendihua(@"密碼長度應在6位元至16位之間") com:nil];

    }else if (!(top.text.length>=6&&top.text.length<=32)){
        
        [HTAlertView showAlertViewWithText:bendihua(@"用戶名長度應在6位元至32位之間") com:nil];
    }
    //不能含有空格
    else if([regex haveKongGe:center.text])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密碼不能含有空格") com:nil];
    }
    //两次密码输入不一致
    else if(![center.text isEqualToString:bottom .text])
    {
     [HTAlertView showAlertViewWithText:bendihua(@"兩次輸入不一致") com:nil];
    }
    //请先同意用户协议
    else if(fangkuangButton.selected==NO)
    {
        [HTAlertView showAlertViewWithText:bendihua(@"請同意使用者協議") com:nil];
    }else
    {
        [HTprogressHUD showjuhuaText:@"正在注冊"];
        NSMutableURLRequest*request=[HTloginHelp returnRequest:[HTloginHelp returnSignupString] usernameTextField:top passwordTextField:center];
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
        
            if ([response[@"code"] isEqualToNumber:@0]) {
        
                NSMutableURLRequest*murequest=[HTloginHelp returnRequest:[HTloginHelp returnLoginString] usernameTextField:top passwordTextField:center];
                [HTNameAndRequestModel setFastRequest:murequest AndNameFormdict:response];
                [HTAlertView showAlertViewWithText:bendihua(@"註冊并登錄成功")com:^{
                    [HTConnect shareConnect].loginBackBlock(response,nil);

                    [self dismissViewControllerAnimated:YES completion:nil];

                 }];
            }
            else if ([response[@"code"]isEqualToNumber:@40106])
            {
                [HTAlertView showAlertViewWithText:bendihua(@"用戶名已存在") com:nil];
                
            }else{
                
                [HTAlertView showAlertViewWithText:bendihua(@"登錄失敗") com:nil];
            }
                    } failure:^(NSError *error) {
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)yinSiTiaoKuan:(HTBaseButton*)sender
{
    HTLegalInformation*legal=[[HTLegalInformation alloc]init];
    [self.navigationController pushViewController:legal animated:YES];
}
-(void)fuWuTiaoKuan:(HTBaseButton*)sender
{
    
}
@end
