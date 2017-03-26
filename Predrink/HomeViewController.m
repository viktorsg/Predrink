//
//  HomeViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 3/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "HomeViewController.h"
#import "MapViewController.h"

#import "ControlButton.h"

#import <GoogleMaps/GoogleMaps.h>

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet ControlButton *blursButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)onBlursPressed:(id)sender {
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
        self.mapViewController = (MapViewController *)segue.destinationViewController;
    }
}


@end
