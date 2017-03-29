//
//  LoginViewController.m
//  Predrink
//
//  Created by Viktor Georgiev on 3/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "LoginViewController.h"

#import "Utils.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emojiLogoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emojiLogoWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emojiLogoHorizontalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emojiLogoVerticalConstraint;

@property (nonatomic, retain) CAGradientLayer *gradient;

@property (strong, nonatomic) NSArray<NSString *> *startingGradientsArray;
@property (strong, nonatomic) NSArray<NSString *> *endingGradientsArray;

@property (assign, nonatomic) BOOL didLayoutSubviews;

@property (assign, nonatomic) long state;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if(!self.didLayoutSubviews) {
        self.emojiLogoHorizontalConstraint.constant = self.view.frame.size.width * 0.10;
        self.didLayoutSubviews = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupGradient];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:1.5 animations:^{
        self.emojiLogoHeightConstraint.constant = 100;
        self.emojiLogoWidthConstraint.constant = 160;
        self.emojiLogoHorizontalConstraint.constant = 0;
        self.emojiLogoVerticalConstraint.constant = -40;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished) {
            self.fbLoginButton.hidden = NO;
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:1.2 animations:^{
                self.fbLoginButton.alpha = 1.0f;
                [self.view layoutIfNeeded];
            }];
        }
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupGradient {
    self.state = 0;
    
    self.startingGradientsArray = @[@"#E96443", @"#43CEA2", @"#E55D87", @"#D53369" ,@"#49A09D", @"#DE6262", @"#FF6B6B"];
    self.endingGradientsArray = @[@"#904E95", @"#185A9D", @"#5FC3E4", @"#E43A15", @"#5F2C82", @"#FFB88C", @"#D38312"];
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.view.bounds;
    self.gradient.colors = [NSArray arrayWithObjects:(id)[Utils colorFromHexString:[self.startingGradientsArray objectAtIndex:self.state]].CGColor, (id)[Utils colorFromHexString:[self.endingGradientsArray objectAtIndex:self.state]].CGColor, nil];
    
    [self.gradient setStartPoint:CGPointMake(1, 0)];
    [self.gradient setEndPoint:CGPointMake(0, 1)];
    [self.view.layer insertSublayer:self.gradient atIndex:0];
    
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(animateLayer) userInfo:nil repeats:YES];
}

- (void)animateLayer {
    if(self.state != 6) {
        self.state++;
    } else {
        self.state = 0;
    }
    
    NSArray *fromColors = self.gradient.colors;
    NSArray *toColors = @[(id)[Utils colorFromHexString:[self.startingGradientsArray objectAtIndex:self.state]].CGColor, (id)[Utils colorFromHexString:[self.endingGradientsArray objectAtIndex:self.state]].CGColor];
    
    [self.gradient setColors:toColors];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    animation.fromValue             = fromColors;
    animation.toValue               = toColors;
    animation.duration              = 2.50;
    animation.removedOnCompletion   = YES;
    animation.fillMode              = kCAFillModeForwards;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.gradient addAnimation:animation forKey:@"animateGradient"];
}

- (IBAction)onFBLoginButtonPressed:(id)sender {
    self.fbLoginButton.hidden = YES;
    [self.loginIndicator startAnimating];
    
    if([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"birthday"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             [self.loginIndicator stopAnimating];
             self.fbLoginButton.hidden = NO;
             
             if(result != nil && error == nil) {
                 [self performSegueWithIdentifier:@"HomeSegue" sender:self];
             }
         }];
    } else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile", @"user_birthday"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if(result != nil && error == nil) {
                [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile *profile, NSError *error) {
                    [self.loginIndicator stopAnimating];
                    self.fbLoginButton.hidden = NO;
                    
                    if(error != nil) {
                        
                    }
                }];
                [self performSegueWithIdentifier:@"HomeSegue" sender:self];
            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
