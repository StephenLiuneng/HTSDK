
//
//  HTAlertView.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTAlertView.h"
#import "MXCommonKit.h"
#import "HTBaseLabel.h"
#import "HTBaseButton.h"
#import "UIView+UIViewAdditional.h"

@interface HTAlertView()


@end

@implementation HTAlertView

+(instancetype)shareAlertView{
    static HTAlertView*alertview;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertview=[[HTAlertView alloc]initWithFrame:MXApplication.windows[0].bounds];
        
    });
    return alertview;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
    }
    return self;
}

+(void)showAlertViewWithText:(NSString*)text com:(void(^)())com{
    HTAlertView*alert=[HTAlertView shareAlertView];
    UIView*backView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*BEGIN_MAINVIEW, 0, MAINVIEW_WIDTH, 150/550.0*MAINVIEW_WIDTH)];
    backView.center=alert.center;
    backView.backgroundColor=CWhiteColor;
    backView.layer.borderColor=CRedColor.CGColor;
    backView.layer.borderWidth=1;
    [alert addSubview:backView];
    HTBaseLabel*infoLabel=[[HTBaseLabel alloc]init];
    infoLabel.frame=CGRectMake(20, 0, backView.width-40, 0);
    
    [infoLabel setText:text font:MXSetSysFont(13) color:CRedColor sizeToFit:NO];
    
    infoLabel.numberOfLines=0;
    infoLabel.textAlignment = NSTextAlignmentCenter;
    
    [backView addSubview:infoLabel];
    
    CGSize labelSize=[infoLabel.text boundingRectWithSize:CGSizeMake(backView.width-40, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: infoLabel.font} context:nil].size;
    infoLabel.height=labelSize.height;
    
    if (infoLabel.height>25) {
        backView.height+=20;
    }
    backView.center=alert.center;
    infoLabel.centerY=backView.height/2;
    [HTAlertView shareAlertView].block=com;
    HTBaseButton*OKButton=[[HTBaseButton alloc]init];
    [OKButton setTitle:bendihua(@"確認") font:MXSetSysFont(16) backColor:CRedColor corner:4];
    OKButton.bounds=CGRectMake(0,0, 130/550.0*backView.width, 50/550.0*backView.width);
    OKButton.left=backView.right-OKButton.width;
    OKButton.top=backView.bottom-OKButton.height;
    [alert addSubview:OKButton];
    
    [OKButton addTarget:self action:@selector(hiddenAlertView:) forControlEvents:(UIControlEventTouchUpInside)];
    [[UIApplication sharedApplication].windows[0] addSubview:alert];
    alert.alpha=0;
    [UIView animateWithDuration:0.3 animations:^{
        alert.alpha=1;
    }];
}
+(void)hiddenAlertView:(HTBaseButton*)sender
{
    HTAlertView*alert=[HTAlertView shareAlertView];
    alert.alpha=1;
    [UIView animateWithDuration:0.3 animations:^{
        alert.alpha=0;
    } completion:^(BOOL finished) {
        [alert removeFromSuperview];
        
        
        if ([HTAlertView shareAlertView].block) {
            [HTAlertView shareAlertView].block();
        }
        
        
    }];
    
}
@end
