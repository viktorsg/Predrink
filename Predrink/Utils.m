//
//  Utils.m
//  Predrink
//
//  Created by Viktor Georgiev on 3/26/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [@"ff" stringByAppendingString:cleanString];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float alpha = ((baseValue >> 24) & 0xFF)/255.0f;
    float red = ((baseValue >> 16) & 0xFF)/255.0f;
    float green = ((baseValue >> 8) & 0xFF)/255.0f;
    float blue = ((baseValue >> 0) & 0xFF)/255.0f;
    
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (void)rippleEffect:(id)sender withColor:(UIColor *)color forEvent:(UIEvent *)event {
    UIButton *button = (UIButton *)sender;
    NSSet *touches = [event touchesForView:sender];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:sender];    CGFloat radius = 0;
    if(point.x > button.bounds.size.width - point.x) {
        radius = point.x;
    } else {
        radius = button.bounds.size.width - point.x;
    }
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.frame = button.bounds;
    UIBezierPath *fromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - 0.1, point.y - 0.1, 0.2, 0.2)];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - radius, point.y - radius, radius * 2, radius * 2)];
    [shape setFillColor:color.CGColor];
    [button.layer addSublayer:shape];
    
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

@end
