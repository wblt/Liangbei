//
//  NetWork.h
//  YFSMM
//
//  Created by macos on 2017/9/6.
//  Copyright © 2017年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


typedef void(^checkVisionBlock)(NSString * );

@interface NetWork : NSObject

@property(nonatomic,copy)checkVisionBlock checkVisionBK;

- (void)getTheNewVersion;

- (void)getlogin;

@end
