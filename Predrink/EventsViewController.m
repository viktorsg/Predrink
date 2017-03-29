//
//  EventsViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 3/29/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "EventsViewController.h"
#import "MapViewController.h"

@interface EventsViewController ()

@property (weak, nonatomic) IBOutlet UIView *mapsContainerView;
@property (weak, nonatomic) IBOutlet UIView *eventsListContainerView;

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)switchViews {
    if(self.mapsContainerView.hidden == NO) {
        self.mapsContainerView.hidden = YES;
        self.eventsListContainerView.hidden = NO;
    } else {
        self.mapsContainerView.hidden = NO;
        self.eventsListContainerView.hidden = YES;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
        MapViewController *mapViewController = (MapViewController *)segue.destinationViewController;
        self.mapViewController = mapViewController;
        mapViewController.eventsViewController = self;
    }
}


@end
