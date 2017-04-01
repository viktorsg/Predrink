//
//  Animations.m
//  Predrink
//
//  Created by Viktor Georgiev on 4/1/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "Animations.h"

@implementation Animations

+ (void)rippleEffect:(UIView *)view withColor:(UIColor *)color forEvent:(UIEvent *)event {
    NSSet *touches = [event touchesForView:view];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:view];    CGFloat radius = 0;
    if(point.x > view.bounds.size.width - point.x) {
        radius = point.x;
    } else {
        radius = view.bounds.size.width - point.x;
    }
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.frame = view.bounds;
    UIBezierPath *fromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - 0.1, point.y - 0.1, 0.2, 0.2)];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - radius, point.y - radius, radius * 2, radius * 2)];
    [shape setFillColor:color.CGColor];
    [view.layer addSublayer:shape];
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.fromValue = (id)fromPath.CGPath;
    anim.toValue = (id)toPath.CGPath;
    anim.duration = 0.5;
    
    CABasicAnimation *fade = [CABasicAnimation  animationWithKeyPath:@"opacity"];
    fade.fromValue = [NSNumber numberWithFloat:1.0];
    fade.toValue = [NSNumber numberWithFloat:0.0];
    fade.duration = 0.25;
    fade.beginTime = CACurrentMediaTime() + 0.25;
    
    [shape addAnimation:anim forKey:@"anim"];
    [shape addAnimation:fade forKey:@"fade"];
}

+ (void)button:(UIButton *)button forView:(UIView *)view withBackgroundColor:(UIColor *)color {
    [view layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        button.backgroundColor = color;
        [view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished) {
            button.backgroundColor = [UIColor clearColor];
        }
    }];
}

@end
