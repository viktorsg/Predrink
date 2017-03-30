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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowUpTopConstraint;

@property (strong, nonatomic) NSTimer *animationTimer;

@property (assign, nonatomic) long animationCount;

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

- (void)onPageChanged:(int)page {
    switch (page) {
        case 0: {
            break;
        }
            
        case 1: {
            break;
        }
    }
}

- (void)animateMyEventsView {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.25 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    [self.animationTimer fire];
}

- (void)animation {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.20 delay:0.25 options:UIViewAnimationOptionCurveLinear animations:^{
        self.arrowUpTopConstraint.constant = 1;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished) {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.10 animations:^{
                self.arrowUpTopConstraint.constant = 5;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if(finished) {
                    [self.view layoutIfNeeded];
                    [UIView animateWithDuration:0.10 animations:^{
                        self.arrowUpTopConstraint.constant = 4;
                        [self.view layoutIfNeeded];
                    } completion:^(BOOL finished) {
                        if(finished) {
                            [self.view layoutIfNeeded];
                            [UIView animateWithDuration:0.20 animations:^{
                                self.arrowUpTopConstraint.constant = 7;
                                [self.view layoutIfNeeded];
                            } completion:^(BOOL finished) {
                                if(finished) {
                                    if(self.animationCount == 0) {
                                        self.animationCount++;
                                    } else {
                                        self.animationCount = 0;
                                        
                                        [self.animationTimer invalidate];
                                    }
                                }
                            }];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = (scrollView.contentOffset.y + scrollView.frame.size.height / 2) / scrollView.frame.size.height;
    [self onPageChanged:page];
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
