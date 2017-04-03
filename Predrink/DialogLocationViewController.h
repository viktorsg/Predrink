//
//  DialogAddEventViewController.h
//  Predrink
//
//  Created by Виктор Георгиев on 3/31/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogLocationViewController : UIViewController<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) void (^onDismiss)(NSString *address);

@property (strong, nonatomic) NSString *address;

@property (assign, nonatomic) BOOL isForEditingAddress;

@end
