//
//  Animations.h
//  Predrink
//
//  Created by Viktor Georgiev on 4/1/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Animations : NSObject

+ (void)rippleEffect:(UIView *)view withColor:(UIColor *)color forEvent:(UIEvent *)event;

+ (void)button:(UIButton *)button forView:(UIView *)view withBackgroundColor:(UIColor *)color;

@end
