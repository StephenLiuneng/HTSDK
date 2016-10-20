//
//  ViewController.m
//  GSDK
#import "HTTalkToServer.h"
//  Created by 王璟鑫 on 16/8/4.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#import "HTBaseNavigationController.h"
#import "ViewController.h"
#import "HTFaseLoginViewController.h"
#import "HTConnect.h"
#import "HTAccountController.h"
#import "HTAddBindInfoTodict.h"
#import "HTAlbumController.h"
#import "HTPostImageTool.h"
#import "HTPOSTImageArray.h"
#import "HTUploadImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor greenColor];
    UIButton*butt=[UIButton buttonWithType:(UIButtonTypeCustom)];
    butt.frame=CGRectMake(50, 100, 100, 100);
    [butt addTarget:self action:@selector(fuck) forControlEvents:(UIControlEventTouchUpInside)];
    butt.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:butt];

    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    self.view.backgroundColor=CGrayColor;
    UIButton*postImage=[UIButton buttonWithType:UIButtonTypeCustom];
    postImage.frame=CGRectMake(200, 200, 100, 100);
    postImage.backgroundColor=[UIColor blackColor];
    [self.view addSubview:postImage];
    [postImage addTarget:self action:@selector(postImage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    }
-(void)fuck
{
    [HTConnect shareToFacebookWithURL:@"http://www.baidu.com" imageURL:@"http://www.baidu.com" contentTitle:@"标题" contentDescription:@"秒死" shareInfoBlock:^(NSDictionary *shareInfoDic) {
        NSLog(@"miaoshu   %@",shareInfoDic);
    }];
}
-(void)tap{
    
    [HTConnect showHTSDKwithLoginInfo:^(NSDictionary *loginInfo, NSDictionary *FaceBookInfo) {
        NSLog(@"%@,\n%@",loginInfo,FaceBookInfo);
    }];
    
    [HTConnect changeAccount:^(NSDictionary *accountInfo, NSDictionary *facebookInfo) {
        NSLog(@"%@",accountInfo);
    }];
    
}
-(void)postImage:(UIButton*)sender
{
    NSLog(@"CLICK");
    NSDictionary*userDic = [USER_DEFAULT objectForKey:@"userInfo"];

    NSString*token=[userDic valueForKeyPath:@"data.token"];
    
    UIImage *image=[UIImage imageNamed:@"000.jpg"];
    UIImage*ima2=[UIImage imageNamed:@"001"];
    UIImage *image3=[UIImage imageNamed:@"000.jpg"];
    UIImage*image4=[UIImage imageNamed:@"009.png"];
    NSMutableArray*array=[NSMutableArray arrayWithObjects:image4,nil];

//    HTPostImageTool*tool=[[HTPostImageTool alloc]init];

 NSDictionary*para=@{@"token":token,@"category":@"1",@"zone":@"200",@"title":@"18号",@"content":@"最新一次带图片的上传"};
 
//    [tool PostImageRequest:[NSString stringWithFormat:@"http://aq.gamehetu.com/%@/topic/create",[USER_DEFAULT objectForKey:@"appID"]] UIImage:array parameters:para success:^(id shuju) {
//        
//    } failure:^(NSError *aaa) {
//        
//    }];

//    [HTPOSTImageArray postRequestWithURL:[NSString stringWithFormat:@"http://aq.gamehetu.com/%@/topic/create",[USER_DEFAULT objectForKey:@"appID"]] postParems:para picArray:array];

}
    @end
