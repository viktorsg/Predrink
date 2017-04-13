//
//  UserShortInfoViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 4/12/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "UserShortInfoViewController.h"

#import "User.h"

#import "Utils.h"
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

- (void)animateView:(UIView *)view withDelay:(CGFloat)delay {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:1.20 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        view.alpha = 1.0f;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)setupGradient {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[Utils colorFromHexString:@"#FF512F"].CGColor, (id)[Utils colorFromHexString:@"#DD2476"].CGColor, nil];
    
    [gradient setStartPoint:CGPointMake(1, 0)];
    [gradient setEndPoint:CGPointMake(0, 1)];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)showBioSymbolCount:(BOOL)showBio {
    self.bioSymbolCountLabel.hidden = !showBio;
    self.bioUnderlineView.alpha = showBio ? 1.0f : 0.2f;
    
    self.drinkSymbolCountLabel.hidden = showBio;
    self.drinkUnderlineView.alpha = showBio ? 0.2f : 1.0f;
}

- (void)changeFrameIfNeeded:(UITextField *)textField {
    if(textField == self.bioTextField) {
        CGRect frame = self.view.frame;
        frame = CGRectMake(frame.origin.x, 0.0f, frame.size.width, frame.size.height);
        self.view.frame = frame;
    } else {
        CGRect frameRelativeToParent = [textField convertRect:textField.bounds toView:self.view];
        if(!CGRectIsNull(frameRelativeToParent)) {
            if(self.view.frame.size.height - 216 <= frameRelativeToParent.origin.y) {
                CGRect frame = self.view.frame;
                frame = CGRectMake(frame.origin.x, self.view.frame.size.height - 260 - frameRelativeToParent.origin.y, frame.size.width, frame.size.height);
                self.view.frame = frame;
            }
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == self.bioTextField) {
        [self showBioSymbolCount:YES];
    } else {
        [self showBioSymbolCount:NO];
    }
    
    [self changeFrameIfNeeded:textField];
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
        
        [self showBioSymbolCount:NO];
    } else {
        [self.drinkTextField resignFirstResponder];
        
        self.drinkSymbolCountLabel.hidden = YES;
        self.drinkUnderlineView.alpha = 0.2f;
    }
    
    [self changeFrameIfNeeded:textField];
    
    return YES;
}

- (IBAction)onCheckPressed:(id)sender forEvent:(UIEvent *)event {
    [Animations rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#33F44336"] forEvent:event];
    
    NSMutableDictionary *userDictionary = [User getUserAsDictionary];
    if(userDictionary != nil) {
        
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
