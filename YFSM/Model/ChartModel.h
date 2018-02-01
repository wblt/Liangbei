//
//  ChartModel.h
//  YFSM
//
//  Created by wb on 2018/1/17.
//  Copyright © 2018年 wb. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChartModel : NSObject
/*
 var water1:Int = 0 //水份使用前
 
 var water2:Int = 0 //水份使用后
 
 var oil1:Int = 0//油份使用前
 
 var oil2:Int = 0//油份使用后
 
 var date:Int = 0 //日期
 
 var step:Int = 0 //步骤
 
 override static func getPrimaryKey() -> String {
 return "date"
 }
 
 override static func getTableName() -> String {
 return "LKTable"
 }
*/
@property(nonatomic,assign) NSInteger water1;
@property(nonatomic,assign) NSInteger water2;
@property(nonatomic,assign) NSInteger oil1;
@property(nonatomic,assign) NSInteger oil2;
@property(nonatomic,assign) NSInteger date;
@property(nonatomic,assign) NSInteger step;

@end
