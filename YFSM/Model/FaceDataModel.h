//
//  FaceDataModel.h
//  YFSM
//
//  Created by wb on 2018/1/20.
//  Copyright © 2018年 wb. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {"water":"40","oil":"30","beforeusewater“:”90“, "beforeuseoil":"50",compactness:5,beforeusecompactness:5,elastic:5,beforeuseelastic:6 ,"time":"2017-12-30 12:45"}
 */
@interface FaceDataModel : NSObject
@property(nonatomic,copy) NSString *water;
@property(nonatomic,copy) NSString *oil;
@property(nonatomic,copy) NSString *beforeusewater;
@property(nonatomic,copy) NSString *beforeuseoil;
@property(nonatomic,copy) NSString *compactness;
@property(nonatomic,copy) NSString *beforeusecompactness;
@property(nonatomic,copy) NSString *elastic;
@property(nonatomic,copy) NSString *beforeuseelastic;
@property(nonatomic,copy) NSString *time;

@end
