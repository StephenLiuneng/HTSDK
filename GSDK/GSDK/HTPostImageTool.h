//
//  HTPostImageTool.h
//  GSDK
//
//  Created by 王璟鑫 on 16/10/14.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HTPostImageTool : NSObject
//- (NSMutableURLRequest *)PostImageRequest:(NSString *)URLString
//                                  UIImage:(UIImage*)image
//                               parameters:(NSDictionary *)parameters
//                                  success:(void (^)(id))success
//                                  failure:(void (^)(NSError *))failure;
- (NSMutableURLRequest *)PostImageRequest:(NSString *)URLString
                                  UIImage:(NSMutableArray*)imageArray
                               parameters:(NSDictionary *)parameters
                                  success:(void (^)(id))success
                                  failure:(void (^)(NSError *))failure;

@end
