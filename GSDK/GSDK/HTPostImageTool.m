//
//  HTPostImageTool.m
//  GSDK
//
//  Created by 王璟鑫 on 16/10/14.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTPostImageTool.h"

@implementation HTPostImageTool{
    void(^_success)(id);
    void(^_failure)(NSError*);
    NSMutableURLRequest*_request;
    NSData*_responseData;

    
}
//- (NSMutableURLRequest *)PostImageRequest:(NSString *)URLString
//                                  UIImage:(UIImage*)image
//                               parameters:(NSDictionary *)parameters
//                                  success:(void (^)(id))success
//                                  failure:(void (^)(NSError *))failure
//{
//    _success = success;
//    _failure = failure;
//    //分界线的标识符
//    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
//    //根据url初始化request
//    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
//                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                   timeoutInterval:10];
//    //分界线 --AaB03x
//    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
//    //结束符 AaB03x--
//    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
//    //得到图片的data
//    NSData* data = UIImageJPEGRepresentation(image, 1);
//    //http body的字符串
//    NSMutableString *body=[[NSMutableString alloc]init];
//    //参数的集合的所有key的集合
//    NSArray *keys= [parameters allKeys];
//    
//    //遍历keys
//    for(int i=0;i<[keys count];i++)
//    {
//        //得到当前key
//        NSString *key=[keys objectAtIndex:i];
//        //如果key不是pic，说明value是字符类型，比如name：Boris
//        if(![key isEqualToString:@"pic"])
//        {
//            //添加分界线，换行
//            [body appendFormat:@"%@\r\n",MPboundary];
//            //添加字段名称，换2行
//            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//            //添加字段的值
//            [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
//        }
//    }
//    
//    ////添加分界线，换行
//    [body appendFormat:@"%@\r\n",MPboundary];
//    //声明pic字段，文件名为boris.png
//    [body appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"x1234.png\"\r\n"];
//    //声明上传文件的格式
//    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
//    
//    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
//    //声明myRequestData，用来放入http body
//    NSMutableData *myRequestData=[NSMutableData data];
//    //将body字符串转化为UTF8格式的二进制
//    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
//    //将image的data加入
//    [myRequestData appendData:data];
//    //加入结束符--AaB03x--
//    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //设置HTTPHeader中Content-Type的值
//    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
//    //设置HTTPHeader
//    [_request setValue:content forHTTPHeaderField:@"Content-Type"];
//    //设置Content-Length
//    [_request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
//    //设置http body
//    [_request setHTTPBody:myRequestData];
//    //http method
//    [_request setHTTPMethod:@"POST"];
//    [NSURLConnection sendAsynchronousRequest:_request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//
//        if (data) {
//            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
//
//        _success(dict);
//        }else
//        {
//            NSLog(@"%@",connectionError);
//        }
//    }];
//    
//    
//    
//    return _request;
//}
- (NSMutableURLRequest *)PostImageRequest:(NSString *)URLString
                                  UIImage:(NSMutableArray*)imageArray
                               parameters:(NSDictionary *)parameters
                                  success:(void (^)(id))success
                                  failure:(void (^)(NSError *))failure
{
    _success = success;
    _failure = failure;
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                   timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [parameters allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"x1234.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    for (UIImage*img in imageArray) {
        NSData* data = UIImageJPEGRepresentation(img, 1);
    [myRequestData appendData:data];

    }

    
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [_request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [_request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [_request setHTTPBody:myRequestData];
    //http method
    [_request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:_request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (data) {
            NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            
            _success(dict);
        }else
        {
            NSLog(@"%@",connectionError);
        }
    }];
    
    
    
    return _request;
}

//#pragma mark ---- NSURLConnectionDataDelegate -----
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//    NSLog(@"%@",[res allHeaderFields]);
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
////    [_responseData appendData:data];
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSString *receiveStr = [[NSString alloc]initWithData:_responseData encoding:NSUTF8StringEncoding];
//    _success(receiveStr);
//}
//
//#pragma mark ---- NSURLConnectionDelegate -----
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    _failure(error);
//}
@end
