//
//  HomeViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 3/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "HomeViewController.h"

#import <GoogleMaps/GoogleMaps.h>

@interface HomeViewController ()

@property (strong, nonatomic) GMSMapView *mapView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
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
