//
//  SplashViewController.m
//  Predrink
//
//  Created by Viktor Georgiev on 3/28/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "SplashViewController.h"

#import "User.h"

#import "FirebaseUtils.h"
#import <FirebaseAuth/FirebaseAuth.h>

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FirebaseUtils instantiateDatabse];
    
    NSError *error;
    //[[FIRAuth auth] signOut:&error];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    if(user == nil) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    } else {
        [user reloadWithCompletion:nil];
        
        [[[[FirebaseUtils getUsersReference] child:@"users"] child:user.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            User *user = [snapshot valueInExportFormat];
            if([user.firstLogin isKindOfClass:[NSNull class]] || user.firstLogin == nil || user.firstLogin) {
                
            }
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
