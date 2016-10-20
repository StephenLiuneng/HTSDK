//
//  HTConnect.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/9.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTConnect.h"
#import <AdSupport/AdSupport.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "HTAssistiveTouch.h"
#import "HTFaseLoginViewController.h"
#import "HTBaseNavigationController.h"
#import "HTAssistiveTouch.h"
#import "IQKeyboardManager.h"

@interface HTConnect ()<FBSDKSharingDelegate,FBSDKGameRequestDialogDelegate>


@end

@implementation HTConnect
//单利
+(instancetype)shareConnect
{
    static HTConnect*help = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        help=[[HTConnect alloc]init];
    });
    return help;
}

/**
 *  展示SDK ui
 *
 *  @param infoBlack 登录信息回调
 */
+(void)showHTSDKwithLoginInfo:(void(^)(NSDictionary*loginInfo,NSDictionary*thridLoginInfo))infoBlack
{
    HTFaseLoginViewController*fast=[[HTFaseLoginViewController alloc]init];
    HTBaseNavigationController*navi=[[HTBaseNavigationController alloc]initWithRootViewController:fast];
    [MXApplication.windows[0].rootViewController presentViewController:navi animated:YES completion:nil];
    [HTConnect shareConnect].loginBackBlock=^(NSDictionary*loginDic,NSDictionary*facebookDic)
    {
        infoBlack(loginDic,facebookDic);
    };
    
}
/**
 *  初始化appID
 *
 *  @param AppID
 */

+(void)initSDKwithAppID:(NSString*)AppID
{
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

    [USER_DEFAULT setObject:AppID forKey:@"appID"];
    [FBSDKAppEvents activateApp];
    [USER_DEFAULT synchronize];
}

/**
 *  显示悬浮窗
 */
+(void)showAssistiveTouch
{
    if (![HTConnect shareConnect].mywindow) {
        CGFloat kuan;
        if (IS_IPAD) {
            
            if (SCREEN_WIDTH > SCREEN_HEIGHT) {
                
                kuan=50/768.0*SCREEN_HEIGHT;

            }else
            {
                kuan=50/768.0*SCREEN_WIDTH;

            }
            
        }else
        {
            if (SCREEN_WIDTH>SCREEN_HEIGHT) {
                kuan = 38/320.0*SCREEN_HEIGHT;
            }else
            {
                kuan=38/320.0*SCREEN_WIDTH;
            }
        }
        [HTConnect shareConnect].mywindow=[[HTAssistiveTouch alloc]initWithFrame:CGRectMake(0, 100, kuan, kuan)];
        UIViewController*viewCon=[[UIViewController alloc]init];
        [[HTConnect shareConnect].mywindow setRootViewController:viewCon];
        [[HTConnect shareConnect].mywindow makeKeyAndVisible];
        [USER_DEFAULT setObject:@"second" forKey:@"first"];
        [USER_DEFAULT synchronize];
    }else
    {
        [HTConnect shareConnect].mywindow.hidden=NO;

    }
}
/**
 *  关闭悬浮窗相应
 */
+(void)disableAssistiveUserTap
{
    [HTConnect shareConnect].mywindow.userInteractionEnabled=NO;
}
/**
 *  打开悬浮窗相应
 */
+(void)enableAssistiveUserTap
{
    [HTConnect shareConnect].mywindow.userInteractionEnabled=YES;

}
/**
 *  隐藏悬浮窗
 */
+(void)hideAssistiveTouch
{
    [HTConnect shareConnect].mywindow.hidden=YES;
}
/**
 *  统计接口
 */
+(void)StatisticsInterfacelogOrRegType:(NSString*)type version:(NSString*)version channel:(NSString*)channel coo_server:(NSString*)coo_server coo_uid:(NSString*)coo_uid;
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    NSString*urlStr=@"http://c.gamehetu.com/stat/login";
    
    NSString*paramString=[NSString stringWithFormat:@"app=%@&type=%@&version=%@&os=ios&channel=%@&uid=%@&coo_server=%@&coo_uid=%@&uuid=%@&idfa=%@&device_type=%@",
                     [USER_DEFAULT objectForKey:@"appID"],
                     type,
                     version,
                     channel,
                     [USER_DEFAULT objectForKey:@"uid"],
                     coo_server,
                     coo_uid,
                     [UUID getUUID],
                     adId,
                     [HTgetDeviceName deviceString]
                     ];
    
    [HTNetWorking POST:urlStr paramString:paramString ifSuccess:^(id response) {
    } failure:^(NSError *error) {
    }];
    [USER_DEFAULT setObject:coo_server forKey:@"coo_server"];
    [USER_DEFAULT setObject:coo_uid forKey:@"coo_uid"];
    [USER_DEFAULT setObject:channel forKey:@"channel"];
    [USER_DEFAULT synchronize];
}

/**
 *  获取商品列表
 */
+(void)getProductsIDwithServer:(NSString*)server ifSuccess:(void(^)(NSArray* response))success orError:(void(^)(NSError*error))error
{
    NSString*string=[NSString stringWithFormat:@"http://c.gamehetu.com/%@/product?package=%@&os=ios&channel=%@&server=%@",[USER_DEFAULT objectForKey:@"appID"],[NSBundle mainBundle].bundleIdentifier,[USER_DEFAULT objectForKey:@"channel"],server];
    NSURL *url=[NSURL URLWithString:string];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (success) {
            
            if (data) {
                
                NSArray*dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                success(dict);
                
            }
            
        }else if(error)
        {
            if (connectionError) {
                
                error(connectionError);
                
            }
        }
        
    } ];
    
    
}
/**
 *  facebook分享
 */
+(void)shareToFacebookWithURL:(NSString*)url imageURL:(NSString*)imageURL contentTitle:(NSString*)contentTitle contentDescription:(NSString*)contentDescription shareInfoBlock:(void(^)(NSDictionary *shareInfoDic))shareInfoBlock
{
    
    FBSDKShareLinkContent*content=[[FBSDKShareLinkContent alloc]init];
    content.contentURL=[NSURL URLWithString:url];
    content.imageURL=[NSURL URLWithString:imageURL];
    content.contentTitle=contentTitle;
    content.contentDescription=contentDescription;
    FBSDKShareDialog *shareDialog = [FBSDKShareDialog new];
    [shareDialog setMode:FBSDKShareDialogModeWeb];
    [shareDialog setShareContent:content];
    [shareDialog setFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    [shareDialog setDelegate:(id<FBSDKSharingDelegate>)self];
    [shareDialog show];
    [HTConnect shareConnect].sharFB=^(NSDictionary*shareDic)
    {
        shareInfoBlock(shareDic);
    };
    
}

//faceBook分享代理
+ (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"分享成功");
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"success" forKey:@"share"];
    [HTConnect shareConnect].sharFB(dic);
    
    
}
+ (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"分享失败");
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"erroe" forKey:@"share"];
    [HTConnect shareConnect].sharFB(dic);
}
+ (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    NSLog(@"取消分享");
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"cancle" forKey:@"share"];
    [HTConnect shareConnect].sharFB(dic);
}

//Facebook邀请
+ (void)inviteFB:(NSString *)title message:(NSString *)msg inviteInfoBlock:(void(^)(NSDictionary*inviteInfoDic))inviteInfoBlock
{
    FBSDKGameRequestContent *gameRequestContent = [[FBSDKGameRequestContent alloc] init];
    gameRequestContent.message = msg;
    gameRequestContent.title = title;
    FBSDKGameRequestDialog*game=[[FBSDKGameRequestDialog alloc]init];
    gameRequestContent.actionType = FBSDKGameRequestActionTypeNone;
    game.content=gameRequestContent;
    game.delegate=(id<FBSDKGameRequestDialogDelegate>)self;
    [game show];
    [HTConnect shareConnect].inviteFB=^(NSDictionary*inviteDic)
    {
        inviteInfoBlock(inviteDic);
    };
}
//邀请代理
+ (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didCompleteWithResults:(NSDictionary *)results
{
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"success" forKey:@"invite"];

    [HTConnect shareConnect].inviteFB(dic);
    NSLog(@"%@完成",results);
}
+ (void)gameRequestDialog:(FBSDKGameRequestDialog *)gameRequestDialog didFailWithError:(NSError *)error
{
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"error" forKey:@"invite"];
    [HTConnect shareConnect].inviteFB(dic);
}
+ (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)gameRequestDialog
{
    NSDictionary*dic=[NSDictionary dictionaryWithObject:@"cancle" forKey:@"invite"];
    [HTConnect shareConnect].inviteFB(dic);
    NSLog(@"取消");
}

//切换账号
+(void)changeAccount:(void(^)(NSDictionary*accountInfo,NSDictionary*facebookInfo))changeAccountBlock
{
    [HTConnect shareConnect].changeAccount=^(NSDictionary*dict,NSDictionary*facebook)
    {
        changeAccountBlock(dict,facebook);
    };
}
@end
