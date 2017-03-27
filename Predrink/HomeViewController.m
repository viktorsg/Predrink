//
//  HomeViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 3/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "HomeViewController.h"
#import "MapViewController.h"

#import "ControlButton.h"

#import "Utils.h"

#import <GoogleMaps/GoogleMaps.h>

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarViewBottomConstraint;

@property (weak, nonatomic) IBOutlet ControlButton *blursButton;
@property (weak, nonatomic) IBOutlet ControlButton *eventsButton;
@property (weak, nonatomic) IBOutlet ControlButton *profileButton;

@property (assign, nonatomic) BOOL areBarsHidden;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)hideBars {
    if(!self.areBarsHidden) {
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            self.topBarViewTopConstraint.constant = -50;
            self.bottomBarViewBottomConstraint.constant = -50;
            [self.view layoutIfNeeded];
        }];
        
        self.areBarsHidden = YES;
    }
}

- (void)showBars {
    if(self.areBarsHidden) {
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            self.topBarViewTopConstraint.constant = 0;
            self.bottomBarViewBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
        
        self.areBarsHidden = NO;
    }
}

- (void)rippleEffect:(id)sender forEvent:(UIEvent *)event {
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
    [shape setFillColor:[Utils colorFromHexString:@"#33FFFFFF"].CGColor];
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)onBlursPressed:(id)sender forEvent:(UIEvent *)event {
    [self rippleEffect:sender forEvent:event];
    
    self.blursButton.alpha = 1.0f;
    self.eventsButton.alpha = 0.7f;
    self.profileButton.alpha = 0.7f;
}

- (IBAction)onEventsPressed:(id)sender forEvent:(UIEvent *)event {
    [self rippleEffect:sender forEvent:event];
    
    self.blursButton.alpha = 0.7f;
    self.eventsButton.alpha = 1.0f;
    self.profileButton.alpha = 0.7f;

}

- (IBAction)onProfilePressed:(id)sender forEvent:(UIEvent *)event {
    [self rippleEffect:sender forEvent:event];
    
    self.blursButton.alpha = 0.7f;
    self.eventsButton.alpha = 0.7f;
    self.profileButton.alpha = 1.0f;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
        MapViewController *mapViewController = (MapViewController *)segue.destinationViewController;
        self.mapViewController = mapViewController;
        mapViewController.homeViewController = self;
    }
}


@end
