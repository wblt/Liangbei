//
//  ChartModel.m
//  YFSM
//
//  Created by wb on 2018/1/17.
//  Copyright © 2018年 wb. All rights reserved.
//

#import "ChartModel.h"

@implementation ChartModel
//主键
+(NSString *)getPrimaryKey
{
    return @"date";
}

//表名
+(NSString *)getTableName
{
    return @"LKTable";
}
@end
