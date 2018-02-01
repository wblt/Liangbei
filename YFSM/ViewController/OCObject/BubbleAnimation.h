//
//  BubbleAnimation.h
//  YFSMM
//
//  Created by macos on 2017/9/4.
//  Copyright © 2017年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BubbleAnimation : NSObject

@property(nonatomic,strong)UIView * view;

@property(nonatomic,assign)CGFloat bubble_x;

@property(nonatomic,assign)CGFloat bubble_y;


/**停止气泡动画*/
- (void)stop_bubbleAnimation;

/**开始气泡动画*/
- (void)start_bubbleAnimation;


@end
