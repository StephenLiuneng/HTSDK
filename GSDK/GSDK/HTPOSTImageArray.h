//
//  HTPOSTImageArray.h
//  GSDK
//
//  Created by 王璟鑫 on 16/10/18.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPOSTImageArray : NSObject
+ (void)postRequestWithURL: (NSString *)url
                postParems: (NSDictionary *)postParems
                  picArray: (NSMutableArray *)picArray;

@end
