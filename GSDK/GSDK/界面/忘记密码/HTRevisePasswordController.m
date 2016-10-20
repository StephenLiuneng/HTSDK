//
//  HTRevisePasswordController.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/16.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTRevisePasswordController.h"
#import "HTTextField.h"
#define MAINVIEW_HEIGHT MAINVIEW_WIDTH*(470/550.0)

@interface HTRevisePasswordController ()

@end

@implementation HTRevisePasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(instancetype)init
{
    if (self=[super init]) {
        self.mainView.frame=CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, (SCREEN_HEIGHT-MAINVIEW_HEIGHT)/2, MAINVIEW_WIDTH, MAINVIEW_HEIGHT);
        self.backImageView.image=imageNamed(@"底板_3");
        self.backImageView.frame=self.mainView.bounds;
        self.titleLabel.text=bendihua(@"修改密码");
        [self configUI];
    }
    return self;
}
-(void)configUI
{
    HTTextField*username=[[HTTextField alloc]init];
    username.frame = CGRectMake(0.09*MAINVIEW_WIDTH, 103/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    username.placeholder=bendihua(@"请输入账号");
    [self.mainView addSubview:username];
    
    HTTextField*oldPassword=[[HTTextField alloc]init];
    oldPassword.frame = CGRectMake(0.09*MAINVIEW_WIDTH,username.bottom+17/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    oldPassword.placeholder=bendihua(@"请输入旧密码");
    [self.mainView addSubview:oldPassword];
    
    HTTextField*newPassword=[[HTTextField alloc]init];
    newPassword.frame = CGRectMake(0.09*MAINVIEW_WIDTH,oldPassword.bottom+17/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    newPassword.placeholder=bendihua(@"請輸入新密碼");
    [self.mainView addSubview:newPassword];

    HTTextField*againPassword=[[HTTextField alloc]init];
    againPassword.frame = CGRectMake(0.09*MAINVIEW_WIDTH,newPassword.bottom+17/470.0*MAINVIEW_HEIGHT, 0.82*MAINVIEW_WIDTH, 50/470.0*MAINVIEW_HEIGHT);
    againPassword.placeholder=bendihua(@"請再次輸入新密碼");
    [self.mainView addSubview:againPassword];
    
    HTBaseButton*makesureRevise=[HTBaseButton buttonWithType:(UIButtonTypeCustom)];
    [makesureRevise setTitle:bendihua(@"確認修改") font:MXSetSysFont(11) backColor:CRedColor corner:4];
    
    makesureRevise.frame=CGRectMake(0,againPassword.bottom+36/470.0*MAINVIEW_HEIGHT, 0.45*MAINVIEW_WIDTH, 46/470.0*MAINVIEW_HEIGHT);
    makesureRevise.centerX=self.mainView.width/2;
    [makesureRevise addTarget:self action:@selector(makeSureRevise:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.mainView addSubview:makesureRevise];
    
}

-(void)makeSureRevise:(HTBaseButton*)sender
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
