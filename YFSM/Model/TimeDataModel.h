//
//  TimeDataModel.h
//  YFSM
//
//  Created by yanghuan on 2018/2/1.
//  Copyright © 2018年 wb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeDataModel : NSObject

@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSArray *data; //存放水油表数据

@end
