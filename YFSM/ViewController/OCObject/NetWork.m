//
//  NetWork.m
//  YFSMM
//
//  Created by macos on 2017/9/6.
//  Copyright © 2017年 Alvin. All rights reserved.
//

#import "NetWork.h"

@implementation NetWork


- (void)getTheNewVersion{


    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
        manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    [manger POST:@"https://itunes.apple.com/lookup?id=414478124" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *array = responseObject[@"results"];
        NSDictionary *dict = [array lastObject];
        NSLog(@"当前版本为：%@", dict[@"version"]);
        
        NSString * version = [dict objectForKey:@"version"];
        
        self.checkVisionBK(version);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)getlogin{
    
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    
    [manger POST:@"http://hi-watch.com.cn/tpiot/app/login" parameters:@{@"username":@"15274835385",@"username":@"e10adc3949ba59abbe56e057f20f883e"} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

@end
