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
#import "ProfileViewController.h"
#import "SettingsViewController.h"

#import "ControlButton.h"

#import "Utils.h"
#import "Animations.h"

#import <GoogleMaps/GoogleMaps.h>

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *eventsContainerView;
@property (weak, nonatomic) IBOutlet UIView *profileContainerView;
@property (weak, nonatomic) IBOutlet UIView *eventsButtonsView;

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
    
    [Utils addShadowToView:self.addButton radius:2.0 opacity:0.5 offset:CGSizeMake(2.0, 2.0)];
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
}

- (void)buttonsControll:(long)index {
    if(index == 0) {
        self.addButton.hidden = YES;
        self.settingsButton.hidden = YES;
        self.myLocationButton.hidden = YES;
        self.eventsButtonsView.hidden = YES;
    } else if(index == 1) {
        self.eventsContainerView.hidden = NO;
        self.profileContainerView.hidden = YES;
        
        self.addButton.hidden = NO;
        self.settingsButton.hidden = YES;
        self.myLocationButton.hidden = NO;
        self.eventsButtonsView.hidden = NO;
    } else {
        self.eventsContainerView.hidden = YES;
        self.profileContainerView.hidden = NO;
        
        self.addButton.hidden = YES;
        self.settingsButton.hidden = NO;
        self.myLocationButton.hidden = YES;
        self.eventsButtonsView.hidden = YES;
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
    [Animations rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#33F44336"] forEvent:event];
}

- (IBAction)onBlursPressed:(id)sender forEvent:(UIEvent *)event {
    [Animations rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#33FFFFFF"] forEvent:event];
    
    [self customizeButton:0];
    [self buttonsControll:0];
}

- (IBAction)onEventsPressed:(id)sender forEvent:(UIEvent *)event {
    [Animations rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#33FFFFFF"] forEvent:event];
    
    [self customizeButton:1];
    [self buttonsControll:1];
}

- (IBAction)onProfilePressed:(id)sender forEvent:(UIEvent *)event {
    [Animations rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#33FFFFFF"] forEvent:event];
    
    if(self.profileContainerView.hidden == YES) {
        [self.profileViewController animateMyEventsView];
        [self.profileViewController loadInformation];
    }
    
    [self customizeButton:2];
    [self buttonsControll:2];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[EventsViewController class]]) {
        EventsViewController *eventsViewController = (EventsViewController *)segue.destinationViewController;
        self.eventsViewController = eventsViewController;
        eventsViewController.homeViewController = self;
    } else if([segue.destinationViewController isKindOfClass:[ProfileViewController class]]) {
        ProfileViewController *profileViewController = (ProfileViewController *)segue.destinationViewController;
        self.profileViewController = profileViewController;
    } else if([segue.destinationViewController isKindOfClass:[SettingsViewController class]]) {
        SettingsViewController *settingsViewController = (SettingsViewController *)segue.destinationViewController;
        settingsViewController.onDismiss = ^{
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        };
    }
}


@end
