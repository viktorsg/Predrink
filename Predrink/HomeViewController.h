//
//  HomeViewController.h
//  Predrink
//
//  Created by Виктор Георгиев on 3/10/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class EventsViewController;

@interface HomeViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) EventsViewController *eventsViewController;

- (void)hideBars;
- (void)showBars;

@end
