//
//  MapViewController.h
//  Predrink
//
//  Created by Viktor Georgiev on 3/26/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class HomeViewController;

@interface MapViewController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) HomeViewController *homeViewController;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
