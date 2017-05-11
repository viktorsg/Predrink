//
//  AddEventViewController.m
//  Predrink
//
//  Created by Viktor Georgiev on 3/30/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "AddEventViewController.h"
#import "DialogLocationViewController.h"

#import "Utils.h"
#import "Animations.h"

@interface AddEventViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *eventScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *leftCircleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *centerCircleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightCircleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadFirstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadSecondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadThirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *uploadFourthImageView;

@property (weak, nonatomic) IBOutlet UIProgressView *topLeftProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *topRightProgressView;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;


@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@property (assign, nonatomic) long page;
@property (assign, nonatomic) long imageTappedIndex;

@property (assign, nonatomic) BOOL isForEditingAddress;

@end

@implementation AddEventViewController

#pragma mark - Life Cycle

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

#pragma mark - Custom Functions

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

- (void)openCameraImagePicker {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.view.frame = CGRectMake(0, 50, self.imagePickerController.view.frame.size.width, self.imagePickerController.view.frame.size.height);
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.imagePickerController.allowsEditing = NO;
        self.imagePickerController.showsCameraControls = NO;
        
        [self addChildViewController:self.imagePickerController];
        [self.view addSubview:self.imagePickerController.view];
        
        [self.view bringSubviewToFront:self.imagePickerController.view];
    }
}

- (void)openPhotoLibraryImagePicker {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePickerController.allowsEditing = NO;
    self.imagePickerController.delegate = self;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - Image Picker Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    switch (self.imageTappedIndex) {
        case 0:
            self.uploadFirstImageView.image = image;
            break;
            
        case 1:
            self.uploadSecondImageView.image = image;
            break;
            
        case 2:
            self.uploadThirdImageView.image = image;
            break;
            
        case 3:
            self.uploadFourthImageView.image = image;
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextField Delegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField == self.titleTextField) {
        
    }
}

#pragma mark - Event Place Button Clicks

- (IBAction)onSavePressed:(id)sender forEvent:(UIEvent *)event {
    [Animations button:(UIButton *)sender forView:self.view withBackgroundColor:[Utils colorFromHexString:@"80F44336"]];
}

- (IBAction)onEditPressed:(id)sender forEvent:(UIEvent *)event {
    [Animations button:(UIButton *)sender forView:self.view withBackgroundColor:[Utils colorFromHexString:@"80F44336"]];
    
    self.isForEditingAddress = YES;
    [self performSegueWithIdentifier:@"DialogLocationSegue" sender:self];
}

- (IBAction)onPickFromMyPlacesPressed:(id)sender forEvent:(UIEvent *)event {
    [Animations button:(UIButton *)sender forView:self.view withBackgroundColor:[Utils colorFromHexString:@"80F44336"]];
    
    self.isForEditingAddress = NO;
    [self performSegueWithIdentifier:@"DialogLocationSegue" sender:self];
}

- (IBAction)onPickNewLocationPressed:(id)sender forEvent:(UIEvent *)event {
    [Animations button:(UIButton *)sender forView:self.view withBackgroundColor:[Utils colorFromHexString:@"80F44336"]];
}

#pragma mark - Event Image Button Clicks

- (IBAction)onImagePressed:(id)sender {
    UIView *view = ((UITapGestureRecognizer *)sender).view;
    self.imageTappedIndex = view.tag;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCameraImagePicker];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Chose from Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoLibraryImagePicker];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[DialogLocationViewController class]]) {
        DialogLocationViewController *dialogAddEventViewController = (DialogLocationViewController *)segue.destinationViewController;
        dialogAddEventViewController.isForEditingAddress = self.isForEditingAddress;
        dialogAddEventViewController.address = self.locationLabel.text;
        dialogAddEventViewController.onDismiss = ^(NSString *address) {
            self.locationLabel.text = address;
        };
    }
}

@end
