//
//  AnimationTransitioning.m
//  Predrink
//
//  Created by Виктор Георгиев on 3/31/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "AnimationTransitioning.h"

@implementation AnimationTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [UIView transitionFromView:fromViewController.view toView:toViewController.view duration:[self transitionDuration:transitionContext] options:self.animationOption completion:^(BOOL finished){
        [transitionContext completeTransition:YES];
    }];
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

@end

