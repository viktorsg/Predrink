//
//  MapViewController.m
//  Predrink
//
//  Created by Viktor Georgiev on 3/26/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "MapViewController.h"
#import "HomeViewController.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (assign, nonatomic) BOOL initialLaunch;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.padding = UIEdgeInsetsMake(0.0, 0.0, 50.0, 0.0);
    
    self.initialLaunch = YES;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
    [self.mapView setCamera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    if(!self.initialLaunch) {
        [self.homeViewController hideBars];
    }
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    if(self.initialLaunch) {
        self.initialLaunch = NO;
    } else {
        [self.homeViewController showBars];
    }
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