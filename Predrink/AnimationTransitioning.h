//
//  AnimationTransitioning.h
//  Predrink
//
//  Created by Виктор Георгиев on 3/31/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AnimationTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) UIViewAnimationOptions animationOption;

@end
