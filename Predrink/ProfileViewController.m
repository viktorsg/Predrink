//
//  ProfileViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 3/29/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *profileScrollView;

@property (weak, nonatomic) IBOutlet UIView *myEventsControlView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.myEventsControlView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.myEventsControlView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.myEventsControlView.layer.mask = maskLayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
