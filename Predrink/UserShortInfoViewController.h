//
//  UserShortInfoViewController.h
//  Predrink
//
//  Created by Виктор Георгиев on 4/12/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SplashViewController;
@class LoginViewController;

@interface UserShortInfoViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) SplashViewController *splashViewController;

@property (strong, nonatomic) LoginViewController *loginViewController;

@end
