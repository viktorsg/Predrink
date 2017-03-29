//
//  HomeViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 3/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "HomeViewController.h"
#import "EventsViewController.h"
#import "MapViewController.h"

#import "ControlButton.h"

#import "Utils.h"

#import <GoogleMaps/GoogleMaps.h>

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *eventsContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *myLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet ControlButton *blursButton;
@property (weak, nonatomic) IBOutlet ControlButton *eventsButton;
@property (weak, nonatomic) IBOutlet ControlButton *profileButton;

@property (assign, nonatomic) BOOL areBarsHidden;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blursButton.titleLabel.textColor = [Utils colorFromHexString:@"#B3FFFFFF"];
    self.profileButton.titleLabel.textColor = [Utils colorFromHexString:@"#B3FFFFFF"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)hideBars {
    if(!self.areBarsHidden) {
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            self.topBarViewTopConstraint.constant = -125;
            self.bottomBarViewBottomConstraint.constant = -100;
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

- (void)rippleEffect:(id)sender withColor:(UIColor *)color forEvent:(UIEvent *)event {
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

- (void)customizeButton:(long)index {
    NSArray<UIButton *> *buttonsArray = @[self.blursButton, self.eventsButton, self.profileButton];
    NSArray<NSString *> *icons = @[@"blur", @"pin", @"profile"];
    NSArray<NSString *> *greyIcons = @[@"blur_grey", @"pin_grey", @"profile_grey"];
    for(int i = 0; i < buttonsArray.count; i++) {
        UIButton *button = [buttonsArray objectAtIndex:i];
        if(i == index) {
            button.titleLabel.font = [UIFont fontWithName:self.blursButton.titleLabel.font.fontName size:14.0f];
            button.titleLabel.textColor = [UIColor whiteColor];
            [button setImage:[UIImage imageNamed:[icons objectAtIndex:i]] forState:UIControlStateNormal];
        } else {
            button.titleLabel.font = [UIFont fontWithName:self.blursButton.titleLabel.font.fontName size:12.0f];
            button.titleLabel.textColor = [Utils colorFromHexString:@"#B3FFFFFF"];
            [button setImage:[UIImage imageNamed:[greyIcons objectAtIndex:i]] forState:UIControlStateNormal];
        }
    }
    
    [self buttonsControll:index];
}

- (void)buttonsControll:(long)index {
    if(index == 0) {
        self.addButton.hidden = YES;
        self.settingsButton.hidden = YES;
        self.myLocationButton.hidden = YES;
    } else if(index == 1) {
        self.addButton.hidden = NO;
        self.settingsButton.hidden = YES;
        self.myLocationButton.hidden = NO;
    } else {
        self.addButton.hidden = YES;
        self.settingsButton.hidden = NO;
        self.myLocationButton.hidden = YES;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)onListPressed:(id)sender {
    self.myLocationButton.hidden = YES;
    
    self.listButton.userInteractionEnabled = NO;
    self.mapButton.userInteractionEnabled = YES;
    
    self.listButton.backgroundColor = [Utils colorFromHexString:@"CCF44336"];
    self.mapButton.backgroundColor = [UIColor whiteColor];
    
    [self.listButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.mapButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.eventsViewController switchViews];
}

- (IBAction)onMapPressed:(id)sender {
    self.myLocationButton.hidden = NO;
    
    self.listButton.userInteractionEnabled = YES;
    self.mapButton.userInteractionEnabled = NO;
    
    self.listButton.backgroundColor = [UIColor whiteColor];
    self.mapButton.backgroundColor = [Utils colorFromHexString:@"CCF44336"];
    
    [self.listButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.mapButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.eventsViewController switchViews];
}

- (IBAction)onMyLocationPressed:(id)sender {
    [self.eventsViewController.mapViewController.locationManager requestLocation];
}

- (IBAction)onAddPressed:(id)sender forEvent:(UIEvent *)event {
    [self rippleEffect:sender withColor:[Utils colorFromHexString:@"33F44336"] forEvent:event];
}

- (IBAction)onBlursPressed:(id)sender forEvent:(UIEvent *)event {
    [self rippleEffect:sender withColor:[Utils colorFromHexString:@"#33FFFFFF"] forEvent:event];
    
    [self customizeButton:0];
}

- (IBAction)onEventsPressed:(id)sender forEvent:(UIEvent *)event {
    [self rippleEffect:sender withColor:[Utils colorFromHexString:@"#33FFFFFF"] forEvent:event];
    
    [self customizeButton:1];
}

- (IBAction)onProfilePressed:(id)sender forEvent:(UIEvent *)event {
    [self rippleEffect:sender withColor:[Utils colorFromHexString:@"#33FFFFFF"] forEvent:event];
    
    [self customizeButton:2];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[EventsViewController class]]) {
        EventsViewController *eventsViewController = (EventsViewController *)segue.destinationViewController;
        self.eventsViewController = eventsViewController;
        eventsViewController.homeViewController = self;
    }
}


@end
