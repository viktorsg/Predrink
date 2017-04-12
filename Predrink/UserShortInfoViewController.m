//
//  UserShortInfoViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 4/12/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "UserShortInfoViewController.h"

#import "Utils.h"

@interface UserShortInfoViewController ()

@property (assign, nonatomic) BOOL didLayoutSubviews;

@end

@implementation UserShortInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)setupGradient {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[Utils colorFromHexString:@"#DD2476"].CGColor, (id)[Utils colorFromHexString:@"#FF512F"].CGColor, nil];
    
    [gradient setStartPoint:CGPointMake(1, 0)];
    [gradient setEndPoint:CGPointMake(0, 1)];
    [self.view.layer insertSublayer:gradient atIndex:0];
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
