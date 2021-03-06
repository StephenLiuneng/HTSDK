//
//  HTAccountBind.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/16.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTAccountBind.h"
#import "HTTextField.h"
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(400/550.0)
#import "HTAddBindInfoTodict.h"
@interface HTAccountBind ()

@property (nonatomic,strong)HTTextField*top;
@property (nonatomic,strong)HTTextField*center;
@property (nonatomic,strong)HTTextField*bottom;

@end

@implementation HTAccountBind

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(instancetype)init
{
    if (self=[super init]) {
        
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_2");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"賬號綁定");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    self.top=[[HTTextField alloc]init];
    self.top.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 103/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    self.top.placeholder=bendihua(@"請輸入有效郵箱賬號");
    [self.mainView addSubview:self.top];
    
    self.center=[[HTTextField alloc]init];
    self.center.frame = CGRectMake(self.top.left,self. top.bottom+18/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    self.center.placeholder=bendihua(@"請輸入密碼");
    self.center.clearButtonMode=YES;
    self.center.secureTextEntry=YES;
    [self.mainView addSubview:self.center];

   self.bottom=[[HTTextField alloc]init];
    self.bottom.frame = CGRectMake(self.center.left, self.center.bottom+18/400.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/400.0*MAINVIEW_HEIGHT);
    self.bottom.placeholder=bendihua(@"請再次輸入密碼");
    self.bottom.clearButtonMode=YES;
    self.bottom.secureTextEntry=YES;
    [self.mainView addSubview:self.bottom];

    
    HTBaseButton*makesureBind=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    [makesureBind setTitle:bendihua(@"確認綁定") font:MXSetSysFont(11) backColor:CRedColor corner:4];

    makesureBind.frame=CGRectMake(0,self.bottom.bottom+32/400.0*MAINVIEW_HEIGHT, 0.45*MAINVIEW_WIDTH, 46/400.0*MAINVIEW_HEIGHT);
    makesureBind.centerX=self.mainView.width/2;
    [makesureBind addTarget:self action:@selector(makeSureBind:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:makesureBind];

}

-(void)makeSureBind:(HTBaseButton*)sender
{
    if ([self.top.text isEqualToString:@""]||[self.center.text isEqualToString:@""])
    {
        
        [HTAlertView showAlertViewWithText:bendihua(@"用戶名或密碼不能為空") com:nil];
    }
    //是不是邮箱
    else if(![regex isValidateEmail:self.top.text])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"請輸入正確的郵箱賬號") com:nil];

          }
    else if (!(self.center.text.length>=6&&self.center.text.length<=16))
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密碼長度在6位至16位之間") com:nil];

    }else if (!(self.top.text.length>=6&&self.top.text.length<=32)){
        [HTAlertView showAlertViewWithText:bendihua(@"請輸入正確的郵箱賬號") com:nil];
    }
    //    不能含有空格
    else if([regex haveKongGe:self.center.text])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"密碼不能含有空格") com:nil];
    }
    //两次密码输入不一致
    else if(![self.center.text isEqualToString:self.bottom .text])
    {
        [HTAlertView showAlertViewWithText:bendihua(@"兩次輸入不一致") com:nil];
    }else
    {
        
        [HTprogressHUD showjuhuaText:@"正在綁定"];
       NSDictionary*userDict= [USER_DEFAULT objectForKey:@"userInfo"];
        NSString*str=[NSString stringWithFormat:@"type=email&auth=%@&password=%@&token=%@",self.top.text,self.center.text,[userDict valueForKeyPath:@"data.token"]];
        NSString*dataStr=[RSA encryptString:str];
        NSURL*URL=[NSURL URLWithString:[NSString stringWithFormat:@"http://c.gamehetu.com//passport/bind?app=%@&format=json&data=%@",[USER_DEFAULT objectForKey:@"appID"],dataStr]];
        
        NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:URL];
        [HTNetWorking sendRequest:request ifSuccess:^(id response) {
            if ([response[@"code"] isEqualToNumber:@0]) {
      
                   [HTAddBindInfoTodict addInfoToDictType:@"email" auth_name:self.top.text];
                [HTAlertView showAlertViewWithText:bendihua(@"綁定成功") com:^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];

            }else if([response[@"code"]isEqualToNumber:@1])
            {
                if ([response[@"msg"]isEqualToString:@"failed, the user is exist"]) {
                    [HTAlertView showAlertViewWithText:bendihua(@"綁定失敗,郵箱已被綁定") com:nil];
                }else
                {
                    [HTAlertView showAlertViewWithText:bendihua(@"綁定失敗,設備或賬號已被綁定過") com:nil];
                }
            
        }else
        {
            [HTAlertView showAlertViewWithText:bendihua(@"綁定失敗") com:nil];

            }
        }
        failure:^(NSError *error) {
       
            
        }];
    }

    
}




@end
