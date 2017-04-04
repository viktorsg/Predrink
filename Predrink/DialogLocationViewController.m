//
//  DialogAddEventViewController.m
//  Predrink
//
//  Created by Виктор Георгиев on 3/31/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "DialogLocationViewController.h"

#import "MyPlaceTableViewCell.h"

#import "Utils.h"
#import "Animations.h"

@interface DialogLocationViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIView *editAddressView;
@property (weak, nonatomic) IBOutlet UIView *myPlacesView;

@property (weak, nonatomic) IBOutlet UITextView *locationTextView;

@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editAdressViewVerticalConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myPlacesViewHeightConstraint;

@property (strong, nonatomic) NSArray *placesArray;

@end

@implementation DialogLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.isForEditingAddress) {
        self.locationTextView.text = self.address;
        [self textViewDidChange:self.locationTextView];
        self.editAddressView.hidden = NO;
    } else {
        self.myPlacesView.hidden = NO;
        self.placesArray = @[@"Testjksahdjsajdsahjkdsahjdkhjdkajksd", @"Test", @"Test", @"Test", @"Test", @"Test", @"Test", @"Test"];
        CGFloat totalHeight = 50.0f;
        for(NSString *place in self.placesArray) {
            totalHeight += [place boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Menlo-Regular" size:16.0f]} context:nil].size.height;
            totalHeight += 10;
        }
        if(totalHeight > 300) {
            totalHeight = 300.0f;
        }
        self.myPlacesViewHeightConstraint.constant = totalHeight;
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissController)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.backgroundView addGestureRecognizer:tapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)keyboardWillShow {
    [self animateEditAddressView:(self.view.frame.size.height - self.editAddressView.frame.size.height) / 4];
}

- (void)keyboardWillHide {
    [self animateEditAddressView:0.0f];
}

- (void)animateEditAddressView:(CGFloat)constant {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.editAdressViewVerticalConstraint.constant = -constant;
        [self.view layoutIfNeeded];
    }];
}

- (void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        if(text.length == 0) {
            if(textView.text.length != 0) {
                return YES;
            }
        } else if(textView.text.length > 199) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu/200", textView.text.length];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *place = [self.placesArray objectAtIndex:indexPath.row];
    
    CGFloat height = [place boundingRectWithSize:CGSizeMake(250, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Menlo-Regular" size:16.0f]} context:nil].size.height;
    
    return height + 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.placeLabel.text = [self.placesArray objectAtIndex:indexPath.row];
    
    return cell;
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
