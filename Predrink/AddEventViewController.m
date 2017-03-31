//
//  AddEventViewController.m
//  Predrink
//
//  Created by Viktor Georgiev on 3/30/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "AddEventViewController.h"

#import "Utils.h"

@interface AddEventViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *eventScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *leftCircleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *centerCircleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightCircleImageView;

@property (weak, nonatomic) IBOutlet UIProgressView *topLeftProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *topRightProgressView;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property (assign, nonatomic) long page;

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customizeImageView:self.leftCircleImageView should:YES];
    [self customizeImageView:self.centerCircleImageView should:YES];
    [self customizeImageView:self.rightCircleImageView should:YES];
    
    [self customizeProgressView:self.topLeftProgressView];
    [self customizeProgressView:self.topRightProgressView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)customizeImageView:(UIImageView *)imageView should:(BOOL)should {
    imageView.backgroundColor = should ? [UIColor clearColor] : [Utils colorFromHexString:@"F44336"];
    imageView.layer.cornerRadius = 10.0f;
    imageView.layer.borderColor = should ? [UIColor whiteColor].CGColor : [UIColor clearColor].CGColor;
    imageView.layer.borderWidth = should ? 3.0f : 0.0f;
    
    if(!should) {
        imageView.image = [UIImage imageNamed:@"done_white_small"];
    }
}

- (void)customizeProgressView:(UIProgressView *)progressView {
    progressView.trackTintColor = [UIColor whiteColor];
    progressView.progressTintColor = [Utils colorFromHexString:@"#F44336"];
}

- (void)changePage {
    self.page++;
    self.eventScrollView.contentOffset = CGPointMake(self.page * self.eventScrollView.frame.size.width, 0);
}

- (void)animateProgressView {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        if(self.page == 0) {
            self.topLeftProgressView.progress = 1.0f;
        } else {
            self.topRightProgressView.progress = 1.0f;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(finished) {
            if(self.page == 1)  {
                self.centerCircleImageView.image = [UIImage imageNamed:@"red_dot"];
            } else {
                self.rightCircleImageView.image = [UIImage imageNamed:@"red_dot"];
            }
        }
    }];
}
- (IBAction)onSavePressed:(id)sender forEvent:(UIEvent *)event {
    [Utils rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#BFF44336"] forEvent:event];
}

- (IBAction)onEditPressed:(id)sender forEvent:(UIEvent *)event {
    [Utils rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#BFF44336"] forEvent:event];
}

- (IBAction)onPickFromMyPlacesPressed:(id)sender forEvent:(UIEvent *)event {
    [Utils rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#BFF44336"] forEvent:event];
}

- (IBAction)onPickNewLocationPressed:(id)sender forEvent:(UIEvent *)event {
    [Utils rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#BFF44336"] forEvent:event];
}

- (IBAction)onForwardPressed:(id)sender {
    if(self.page == 0) {
        [self animateProgressView];
        [self changePage];
        [self customizeImageView:self.leftCircleImageView should:NO];
    } else if(self.page == 1) {
        [self animateProgressView];
        [self changePage];
        [self customizeImageView:self.centerCircleImageView should:NO];
        
        [self.forwardButton setImage:[UIImage imageNamed:@"done_white"] forState:UIControlStateNormal];
    } else {
        self.page++;
        [self customizeImageView:self.rightCircleImageView should:NO];
    }
}

- (IBAction)onClosePressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
