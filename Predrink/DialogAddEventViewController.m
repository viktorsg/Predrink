//
//  DialogAddEventViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 3/31/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "DialogAddEventViewController.h"

#import "Utils.h"
#import "Animations.h"

@interface DialogAddEventViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIView *editAddressView;

@property (weak, nonatomic) IBOutlet UITextView *locationTextView;

@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

@end

@implementation DialogAddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.isForEditingAddress) {
        self.locationTextView.text = self.address;
        [self textViewDidChange:self.locationTextView];
        self.editAddressView.hidden = NO;
    } else {
        
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.backgroundView addGestureRecognizer:tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if(text.length == 0) {
        if(textView.text.length != 0) {
            return YES;
        }
    } else if(textView.text.length > 199) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu/200", textView.text.length];
}

- (IBAction)onEditPressed:(id)sender {
    [Animations button:(UIButton *)sender forView:self.view withBackgroundColor:[Utils colorFromHexString:@"80F44336"]];
    
    if(self.onDismiss != nil) {
        self.onDismiss(self.locationTextView.text);
    }
    [self dismissController];
}

- (IBAction)onCancelPressed:(id)sender {
    [Animations button:(UIButton *)sender forView:self.view withBackgroundColor:[Utils colorFromHexString:@"80F44336"]];
    
    [self dismissController];
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
