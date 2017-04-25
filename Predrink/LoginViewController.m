//
//  LoginViewController.m
//  Predrink
//
//  Created by Viktor Georgiev on 3/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "LoginViewController.h"
#import "UserShortInfoViewController.h"

#import "Utils.h"

#import "User.h"

#import "FirebaseUtils.h"
#import <FirebaseAuth/FirebaseAuth.h>
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


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth * _Nonnull auth, FIRUser * _Nullable user) {
        if(user != nil) {
            [[[FirebaseUtils getUsersReference] child:user.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"birthday, picture"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    FBSDKProfile *profile = [FBSDKProfile currentProfile];
                    NSDictionary *fbInformationDictionary = (NSDictionary *)result;
                    NSString *birthday = [fbInformationDictionary objectForKey:@"birthday"];
                    
                    if(snapshot.childrenCount > 0) {
                        User *user = [[User alloc] initWithSnapshot:snapshot];
                        NSMutableDictionary *userDictionary = [User getUserAsDictionary:user];
                        
                        [userDictionary setValue:profile.firstName forKey:@"firstName"];
                        [userDictionary setValue:profile.lastName forKey:@"lastName"];
                        [userDictionary setValue:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?height=450&width=450", profile.userID] forKey:@"profilePictureUri"];
                        [userDictionary setValue:[self yearsBetweenCurrentDateAnd:birthday] forKey:@"age"];
                        
                        [[[FirebaseUtils getUsersReference] child:user.uid] updateChildValues:userDictionary withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                            if(error == nil) {
                                user.firstName = profile.firstName;
                                user.lastName = profile.lastName;
                                user.profilePictureUri = [userDictionary objectForKey:@"profilePictureUri"];
                                [User setCurrentUser:user];
                                
                                if([user.firstLogin isKindOfClass:[NSNull class]] || user.firstLogin == nil || user.firstLogin.intValue == 1) {
                                    [self performSegueWithIdentifier:@"UserInfoSegue" sender:self];
                                } else {
                                    [self performSegueWithIdentifier:@"HomeSegue" sender:self];
                                }
                            } else {
                                [self showError:@"Failed to update user information"];
                            }
                        }];
                    } else {
                        NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
                        [userDictionary setValue:profile.userID forKey:@"fid"];
                        [userDictionary setValue:[FIRAuth auth].currentUser.uid forKey:@"uid"];
                        [userDictionary setValue:profile.firstName forKey:@"firstName"];
                        [userDictionary setValue:profile.lastName forKey:@"lastName"];
                        [userDictionary setValue:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?height=450&width=450", profile.userID] forKey:@"profilePictureUri"];
                        [userDictionary setValue:@"" forKey:@"bio"];
                        [userDictionary setValue:@"" forKey:@"favDrink"];
                        [userDictionary setValue:@YES forKey:@"firstLogin"];
                        [userDictionary setValue:[self yearsBetweenCurrentDateAnd:birthday] forKey:@"age"];
                        [userDictionary setValue:[NSNumber numberWithInt:0] forKey:@"joinedCount"];
                        [userDictionary setValue:[NSNumber numberWithInt:0] forKey:@"hostedCount"];
                        [userDictionary setValue:birthday forKey:@"birthday"];
                        
                        [[[FirebaseUtils getUsersReference] child:[FIRAuth auth].currentUser.uid] setValue:userDictionary withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                            if(error == nil) {
                                User *user = [[User alloc] initWithDictionary:userDictionary];
                                [User setCurrentUser:user];
                                [self performSegueWithIdentifier:@"UserInfoSegue" sender:self];
                            } else {
                                [self showError:@"User registration failed"];
                            }
                        }];
                    }
                }];
            }];
        } else {
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
 
    self.fbLoginButton.hidden = NO;
    [self.loginIndicator stopAnimating];
    
    self.emojiLogoHeightConstraint.constant = 120;
    self.emojiLogoWidthConstraint.constant = 200;
    self.emojiLogoHorizontalConstraint.constant = self.view.frame.size.width * 0.10;
    self.emojiLogoVerticalConstraint.constant = 0;
    
    self.fbLoginButton.hidden = YES;
    self.fbLoginButton.alpha = 0.0f;
    [self.view layoutIfNeeded];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if(!self.didLayoutSubviews) {
        self.emojiLogoHorizontalConstraint.constant = self.view.frame.size.width * 0.10;
        self.didLayoutSubviews = YES;
        
        [self setupGradient];
        
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Design Customizations

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

#pragma mark - Custom Functions

- (void)showError:(NSString *)message {
    self.fbLoginButton.hidden = NO;
    [self.loginIndicator stopAnimating];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Predrink" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSNumber *)yearsBetweenCurrentDateAnd:(NSString *)birthday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd-yyyy";
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:[dateFormatter dateFromString:birthday] toDate:[NSDate date] options:0];
    return [NSNumber numberWithInteger:components.year];
}

#pragma mark - Button Presses

- (IBAction)onFBLoginButtonPressed:(id)sender {
    self.fbLoginButton.hidden = YES;
    [self.loginIndicator startAnimating];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
    [loginManager logInWithReadPermissions: @[@"public_profile", @"email", @"user_birthday", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if(result != nil && error == nil) {
            if(result.declinedPermissions != nil && result.declinedPermissions.count == 0) {
                [[FIRAuth auth] signInWithCredential:[FIRFacebookAuthProvider credentialWithAccessToken:[[FBSDKAccessToken currentAccessToken] tokenString]] completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                    if(error != nil) {
                        [self showError:@"Authorization failed"];
                    }
                }];
            } else {
                [self showError:@"You have not granted needed permissions"];
            }
        } else {
            [self showError:@"Facebook login failed"];
        }
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[UserShortInfoViewController class]]) {
        ((UserShortInfoViewController *)segue.destinationViewController).loginViewController = self;
    }
}


@end
