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

@property (weak, nonatomic) IBOutlet UILabel *helloLabel;

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

- (void)setupGradient {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[Utils colorFromHexString:@"#FF512F"].CGColor, (id)[Utils colorFromHexString:@"#DD2476"].CGColor, nil];
    
    [gradient setStartPoint:CGPointMake(1, 0)];
    [gradient setEndPoint:CGPointMake(0, 1)];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (IBAction)onCheckPressed:(id)sender forEvent:(UIEvent *)event {
    [Animations rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#33F44336"] forEvent:event];
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
