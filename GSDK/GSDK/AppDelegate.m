//
//  AppDelegate.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/4.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "AppDelegate.h"
#import "HTAssistiveTouch.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import <GameKit/GameKit.h>
#import "HTConnect.h"

#import "HTOrientation.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%d",IS_IPAD);
    NSLog(@"%f",SCREEN_WIDTH);
    NSLog(@"%f",SCREEN_HEIGHT);

    [HTConnect StatisticsInterfacelogOrRegType:@"aaa" version:@"a" channel:@"default" coo_server:@"200" coo_uid:@"11"];
    [HTConnect initSDKwithAppID:@"10001"];
    [GIDSignIn sharedInstance].clientID = @"1047879244101-ab7hk0r62dq3oqjk6jpmp6knimk4p2un.apps.googleusercontent.com";
  

    return YES;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}




//游戏中心登录的一些事情
- (void) authenticateLocalPlayer

{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
                    if (!error && viewcontroller)
                    {
                        [MXRootViewController       presentViewController:viewcontroller animated:YES completion:nil];
                    }
                    else
                    {
                        
                    }
        
        if (error == nil) {
            
                        //成功处理
            
                        NSLog(@"成功");
            
                        NSLog(@"1--alias--.%@",[GKLocalPlayer localPlayer].alias);
            
                        NSLog(@"2--authenticated--.%d",[GKLocalPlayer localPlayer].authenticated);
            
                        NSLog(@"3--isFriend--.%d",[GKLocalPlayer localPlayer].isFriend);
            
                        NSLog(@"4--playerID--.%@",[GKLocalPlayer localPlayer].playerID);
            
                        NSLog(@"%@",[GKLocalPlayer localPlayer].displayName);
            
                        NSLog(@"5--underage--.%d",[GKLocalPlayer localPlayer].underage);
           //            - (void)loadPhotoForSize:(GKPhotoSize)size withCompletionHandler:(void(^__nullable)(UIImage * __nullable photo, NSError * __nullable error))completionHandler NS_AVAILABLE(10_8, 5_0);

                    }else {
                
                        NSLog(@"失败  %@",error);
                        
                    }

                })];

    
}
- (void)checkLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.isAuthenticated)
    {
        
    }
    else
    {
        
    }
}

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] \
compare:v options:NSNumericSearch] == NSOrderedAscending)

- (BOOL) isGameCenterAvailable
{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}



- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
