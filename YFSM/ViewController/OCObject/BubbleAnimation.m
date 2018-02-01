//
//  BubbleAnimation.m
//  YFSMM
//
//  Created by macos on 2017/9/4.
//  Copyright © 2017年 Alvin. All rights reserved.
//

#import "BubbleAnimation.h"

@interface BubbleAnimation()

@property(nonatomic,strong)NSTimer * timer;

@end

@implementation BubbleAnimation


- (void)stop_bubbleAnimation{

    [self.timer invalidate];
    
    self.timer = nil;
    
}


- (void)start_bubbleAnimation{
  
    if (self.timer == nil) {
        
       self.timer = [NSTimer scheduledTimerWithTimeInterval:.8
                                         target:self
                                       selector:@selector(createBubble)
                                       userInfo:nil
                                        repeats:YES];
    }
    
}

- (void)createBubble{
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble"]];
    
    CGFloat size = [self randomFloatBetween:5 and:30];
    
    /* If you are not animating your fish, this will work fine
     [bubbleImageView setFrame:CGRectMake(self.fishImageView.frame.origin.x + 5, self.fishImageView.frame.origin.y + 80, size, size)]; */
    
    // If you are animating your fish, you need to get the starting point from the
    // fish's presentation layer, since it will be animating at the time.
    
    
    //    [bubbleImageView setFrame:CGRectMake([self.fishImageView.layer.presentationLayer frame].origin.x + 5, [self.fishImageView.layer.presentationLayer frame].origin.y + 80, size, size)];
    
    
    [bubbleImageView setFrame:CGRectMake(self.bubble_x,self.bubble_y, size*3, size*3)];
    
    bubbleImageView.alpha = [self randomFloatBetween:.1 and:1];
    
    [self.view addSubview:bubbleImageView];
    
    UIBezierPath *zigzagPath = [[UIBezierPath alloc] init];
    CGFloat oX = bubbleImageView.frame.origin.x;
    CGFloat oY = bubbleImageView.frame.origin.y;
    CGFloat eX = oX;
    CGFloat eY = oY - [self randomFloatBetween:50 and:300];
    CGFloat t = [self randomFloatBetween:20 and:100];
    CGPoint cp1 = CGPointMake(oX - t, ((oY + eY) / 2));
    CGPoint cp2 = CGPointMake(oX + t, cp1.y);
    
    // randomly switch up the control points so that the bubble
    // swings right or left at random
    NSInteger r = arc4random() % 2;
    if (r == 1) {
        CGPoint temp = cp1;
        cp1 = cp2;
        cp2 = temp;
    }
    
    // the moveToPoint method sets the starting point of the line
    [zigzagPath moveToPoint:CGPointMake(oX, oY)];
    // add the end point and the control points
    [zigzagPath addCurveToPoint:CGPointMake(eX, eY) controlPoint1:cp1 controlPoint2:cp2];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        // transform the image to be 1.3 sizes larger to
        // give the impression that it is popping
        [UIView transitionWithView:bubbleImageView
                          duration:0.1f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            bubbleImageView.transform = CGAffineTransformMakeScale(1.3, 1.3);
                        } completion:^(BOOL finished) {
                            [bubbleImageView removeFromSuperview];
                        }];
    }];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = 2;
    pathAnimation.path = zigzagPath.CGPath;
    // remains visible in it's final state when animation is finished
    // in conjunction with removedOnCompletion
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    [bubbleImageView.layer addAnimation:pathAnimation forKey:@"movingAnimation"];
    
    [CATransaction commit];
    
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}





@end
