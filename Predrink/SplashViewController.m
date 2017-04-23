//
//  SplashViewController.m
//  Predrink
//
//  Created by Viktor Georgiev on 3/28/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "AppDelegate.h"

#import "SplashViewController.h"
#import "UserShortInfoViewController.h"

#import "User.h"

#import "FirebaseUtils.h"
#import <FirebaseAuth/FirebaseAuth.h>

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FirebaseUtils instantiateDatabse];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    if(user == nil) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    } else {
        [user reloadWithCompletion:nil];
        
        [[[FirebaseUtils getUsersReference] child:user.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            User *user = [[User alloc] initWithSnapshot:snapshot];
            [User setCurrentUser:user];
            
            if([user.firstLogin isKindOfClass:[NSNull class]] || user.firstLogin == nil || user.firstLogin.intValue == 1) {
                [self performSegueWithIdentifier:@"UserInfoSegue" sender:self];
            } else {
                [self performSegueWithIdentifier:@"HomeSegue" sender:self];
            }
        } withCancelBlock:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[UserShortInfoViewController class]]) {
        ((UserShortInfoViewController *)segue.destinationViewController).splashViewController = self;
    }
}


@end
