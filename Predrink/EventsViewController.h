//
//  EventsViewController.h
//  Predrink
//
//  Created by Виктор Георгиев on 3/29/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController;
@class MapViewController;

@interface EventsViewController : UIViewController

@property (strong, nonatomic) HomeViewController *homeViewController;

@property (strong, nonatomic) MapViewController *mapViewController;

- (void)switchViews;

@end
