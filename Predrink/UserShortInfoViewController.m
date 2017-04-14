//
//  UserShortInfoViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 4/12/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "UserShortInfoViewController.h"
#import "SplashViewController.h"
#import "LoginViewController.h"

#import "User.h"

#import "Utils.h"
#import "FirebaseUtils.h"
#import "Animations.h"

@interface UserShortInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *bioView;
@property (weak, nonatomic) IBOutlet UIView *bioUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *drinkView;
@property (weak, nonatomic) IBOutlet UIView *drinkUnderlineView;

@property (weak, nonatomic) IBOutlet UILabel *helloLabel;
@property (weak, nonatomic) IBOutlet UILabel *tellUsMoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioSymbolCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *drinkLabel;
@property (weak, nonatomic) IBOutlet UILabel *drinkSymbolCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bioImageView;
@property (weak, nonatomic) IBOutlet UIImageView *drinkImageView;

@property (weak, nonatomic) IBOutlet UITextField *bioTextField;
@property (weak, nonatomic) IBOutlet UITextField *drinkTextField;

@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (assign, nonatomic) BOOL didLayoutSubviews;

@end

@implementation UserShortInfoViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    User *user = [User currentUser];
    
    self.helloLabel.text = [NSString stringWithFormat:@"Hello %@", user.firstName];
    
    self.checkButton.layer.cornerRadius = 20.0f;
    [Utils addShadowToView:self.checkButton radius:2.0 opacity:0.5 offset:CGSizeMake(2.0, 2.0)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self animateView:self.helloLabel withDelay:0.0f];
    
    [self animateView:self.tellUsMoreLabel withDelay:1.20f];
    
    [self animateView:self.bioImageView withDelay:2.40f];
    [self animateView:self.bioLabel withDelay:2.40f];
    [self animateView:self.bioView withDelay:2.40f];
    
    [self animateView:self.drinkImageView withDelay:3.60f];
    [self animateView:self.drinkLabel withDelay:3.60f];
    [self animateView:self.drinkView withDelay:3.60f];
    
    [self animateView:self.checkButton withDelay:4.80f];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if(!self.didLayoutSubviews) {
        [self setupGradient];
        
        self.didLayoutSubviews = YES;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Design Customizations

- (void)animateView:(UIView *)view withDelay:(CGFloat)delay {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:1.20 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        view.alpha = 1.0f;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished && delay == 4.80f) {
            self.bioTextField.userInteractionEnabled = YES;
            self.drinkTextField.userInteractionEnabled = YES;
        }
    }];
}

- (void)animateViewFrame:(CGRect)frame {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
        [self.view layoutIfNeeded];
    }];
}

- (void)setupGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[Utils colorFromHexString:@"#FF512F"].CGColor, (id)[Utils colorFromHexString:@"#DD2476"].CGColor, nil];
    
    [gradient setStartPoint:CGPointMake(1, 0)];
    [gradient setEndPoint:CGPointMake(0, 1)];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

#pragma mark - Custom Functions

- (void)showBioSymbolCount:(BOOL)showBio {
    self.bioSymbolCountLabel.hidden = !showBio;
    self.bioUnderlineView.alpha = showBio ? 1.0f : 0.4f;
    
    self.drinkSymbolCountLabel.hidden = showBio;
    self.drinkUnderlineView.alpha = showBio ? 0.4f : 1.0f;
}

- (void)showError:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Predrink" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == self.bioTextField) {
        [self animateViewFrame:CGRectMake(self.view.frame.origin.x, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
        
        [self showBioSymbolCount:YES];
    } else {
        CGRect frameRelativeToParent = [textField convertRect:textField.bounds toView:self.view];
        if(!CGRectIsNull(frameRelativeToParent)) {
            if(self.view.frame.size.height - 216 <= frameRelativeToParent.origin.y) {
                [self animateViewFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height - 260 - frameRelativeToParent.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
            }
        }
        
        [self showBioSymbolCount:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(string.length == 0) {
        if(textField.text.length != 0) {
            return YES;
        }
    } else if(textField == self.bioTextField && textField.text.length > 119) {
        return NO;
    } else if(textField == self.drinkTextField && textField.text.length > 119) {
        return NO;
    }
    
    return YES;
}

- (IBAction)textFieldDidChangeText:(UITextField *)textField {
    if(textField == self.bioTextField) {
        self.bioSymbolCountLabel.text = [NSString stringWithFormat:@"%lu/120", textField.text.length];
    } else {
        self.drinkSymbolCountLabel.text = [NSString stringWithFormat:@"%lu/15", textField.text.length];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.bioTextField) {
        [self.drinkTextField becomeFirstResponder];
    } else {
        [self.drinkTextField resignFirstResponder];
        
        self.drinkSymbolCountLabel.hidden = YES;
        self.drinkUnderlineView.alpha = 0.2f;
        
        [self animateViewFrame:CGRectMake(self.view.frame.origin.x, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    return YES;
}

#pragma mark - Button Clicks

- (IBAction)onCheckPressed:(id)sender forEvent:(UIEvent *)event {
    [Animations rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#33F44336"] forEvent:event];
    
    NSString *bio = self.bioTextField.text;
    NSString *drink = self.drinkTextField.text;
    
    if(bio.length == 0 || drink.length == 0) {
        [self showError:@"Please fill all fields!"];
    } else {
        [self animateViewFrame:CGRectMake(self.view.frame.origin.x, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
        
        User *user = [User currentUser];
        NSMutableDictionary *userDictionary = [User getUserAsDictionary:user];
        
        [userDictionary setValue:bio forKey:@"bio"];
        [userDictionary setValue:drink forKey:@"favDrink"];
        [userDictionary setValue:@NO forKey:@"firstLogin"];
        
        [[[FirebaseUtils getUsersReference] child:user.uid] updateChildValues:userDictionary withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if(error == nil) {
                user.bio = bio;
                user.favDrink = drink;
                user.firstLogin = [NSNumber numberWithInt:0];
                [User setCurrentUser:user];
                
                if(self.loginViewController != nil) {
                    [self.loginViewController performSegueWithIdentifier:@"HomeSegue" sender:self.loginViewController];
                } else {
                    [self.splashViewController performSegueWithIdentifier:@"HomeSegue" sender:self.splashViewController];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self showError:@"Failed to update user information"];
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
