//
//  SettingsViewController.h
//  Predrink
//
//  Created by Viktor Georgiev on 3/28/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) void (^onDismiss)(BOOL shouldLogOut);

@end
