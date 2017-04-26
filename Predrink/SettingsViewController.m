//
//  SettingsViewController.m
//  Predrink
//
//  Created by Viktor Georgiev on 3/28/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "SettingsViewController.h"

#import "SettingsHeaderTableViewCell.h"
#import "MyAccountTableViewCell.h"
#import "SearchRadiusTableViewCell.h"
#import "SettingsTableViewCell.h"

#import "Utils.h"
#import "FirebaseUtils.h"
#import "Animations.h"
#import "User.h"

#import <FirebaseAuth/FirebaseAuth.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeTextViewCountLabel;

@property (weak, nonatomic) IBOutlet UITextView *changeTextView;

@property (weak, nonatomic) IBOutlet UIView *underlineView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changeTextViewHeightConstraint;

@property (strong, nonatomic) NSArray<NSString *> *titlesArray;

@property (assign, nonatomic) BOOL isBioVisible;
@property (assign, nonatomic) BOOL isFavDrinkVisible;

@end

@implementation SettingsViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArray = @[@"My Account", @"Bio", @"Favourite Drink", @"Search", @"Select search radius", @"More Information", @"Send Feedback", @"Privacy Policy", @"Licenses", @"Account Actions", @"Log Out"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Custom Functions

- (void)showError:(NSString *)errorMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Predrink" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)changeHeaderLabel:(NSString *)headerString withChangeLabel:(NSString *)changeString {
    self.changeLabel.hidden = NO;
    self.changeTextView.hidden = NO;
    self.underlineView.hidden = NO;
    self.saveButton.hidden = NO;
    self.settingsTableView.hidden = YES;
    
    self.headerLabel.text = headerString;
    self.changeLabel.text = changeString;
}

- (void)showBioWindow {
    self.isBioVisible = YES;
    
    [self changeHeaderLabel:@"Bio" withChangeLabel:@"Tell everyone how you feel"];
    
    NSString *bio = [User currentUser].bio;
    self.changeTextView.text = bio;
    self.changeTextViewCountLabel.text = [NSString stringWithFormat:@"%lu/120", bio.length];
    
    [self calculateTextViewHeight:self.changeTextView];
}

- (void)showFavouriteDrinkWindow {
    self.isFavDrinkVisible = YES;
    
    [self changeHeaderLabel:@"Favourite Drink" withChangeLabel:@"Insert your new favourite drink here"];
    
    NSString *favDrink = [User currentUser].favDrink;
    self.changeTextView.text = favDrink;
    self.changeTextViewCountLabel.text = [NSString stringWithFormat:@"%lu/15", favDrink.length];
    
    [self calculateTextViewHeight:self.changeTextView];
}

- (void)calculateTextViewHeight:(UITextView *)textView {
    CGFloat neededHeight = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, MAXFLOAT)].height;
    if(self.changeTextViewHeightConstraint.constant != neededHeight) {
        self.changeTextViewHeightConstraint.constant = neededHeight;
    }
}

- (void)updateField:(NSString *)field withValue:(NSString *)value {
    [[[FirebaseUtils getUsersReference] child:[User currentUser].uid] updateChildValues:@{field : value} withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if(error == nil) {
            if([field isEqualToString:@"bio"]) {
                [User currentUser].bio = value;
            } else {
                [User currentUser].favDrink = value;
            }
            
            [self.settingsTableView reloadData];
            [self onBackPressed:self];
        } else {
            [self showError:@"Update failed"];
        }
    }];
}

- (void)signOut {
    NSError *error;
    [[FIRAuth auth] signOut:&error];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    if(error == nil) {
        self.onDismiss(YES);
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self showError:@"Error occured while logging out"];
    }
}

#pragma mark - TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.changeTextViewCountLabel.hidden = NO;
    
    self.underlineView.backgroundColor = [Utils colorFromHexString:@"#F44336"];
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
        } else if((self.isBioVisible && textView.text.length > 119) || (self.isFavDrinkVisible && textView.text.length > 14)) {
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self calculateTextViewHeight:textView];
    
    if(self.isBioVisible) {
        self.changeTextViewCountLabel.text = [NSString stringWithFormat:@"%lu/120", textView.text.length];
    } else {
        self.changeTextViewCountLabel.text = [NSString stringWithFormat:@"%lu/15", textView.text.length];
    }
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 35.0f;
    
    long row = indexPath.row;
    if(row == 1 || row == 2) {
        height = 60.0f;
    } else if(row == 4) {
        height = 70.0f;
    } else if(row == 6 || row == 7 || row == 8 || row == 10) {
        height = 44.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    long row = indexPath.row;
    
    if(row == 0 || row == 3 || row == 5 || row == 9) {
        SettingsHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        cell.headerLabel.text = [self.titlesArray objectAtIndex:row];
        
        return cell;
    } else if(row == 1 || row == 2) {
        MyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyAccountCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accountInformationTypeLabel.text = [self.titlesArray objectAtIndex:row];
        if(row == 1) {
            cell.accountInformationLabel.text = [User currentUser].bio;
            cell.separatorView.hidden = NO;
        } else {
            cell.accountInformationLabel.text = [User currentUser].favDrink;
            cell.separatorView.hidden = YES;
        }
        
        return cell;
    } else if(row == 4) {
        SearchRadiusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        cell.searchRadiusLabel.text = [self.titlesArray objectAtIndex:row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.settingsLabel.text = [self.titlesArray objectAtIndex:row];
    if(row == 8) {
        cell.separatorView.hidden = YES;
    } else {
        cell.separatorView.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long row = indexPath.row;
    
    switch (row) {
        case 1:
            [self showBioWindow];
            break;
            
        case 2:
            [self showFavouriteDrinkWindow];
            break;
            
        case 10:
            [self signOut];
            break;
    }
}

#pragma mark - Button Clicks

- (IBAction)onSavePressed:(id)sender forEvent:(UIEvent *)event {
    [Animations rippleEffect:(UIButton *)sender withColor:[Utils colorFromHexString:@"#fAA49E"] forEvent:event];
    
    if(self.changeTextView.text.length != 0) {
        if(self.isBioVisible) {
            //[self updateChildValue:@{@"bio" : self.changeTextView.text}];
            [self updateField:@"bio" withValue:self.changeTextView.text];
        } else if(self.isFavDrinkVisible) {
            [self updateField:@"favDrink" withValue:self.changeTextView.text];
        }
    } else {
        [self showError:@"Field should not be empty"];
    }
}

- (IBAction)onBackPressed:(id)sender {
    if(!self.isBioVisible && !self.isFavDrinkVisible) {
        self.onDismiss(NO);
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        self.headerLabel.text = @"Settings";
        
        self.isBioVisible = NO;
        self.isFavDrinkVisible = NO;
        
        self.changeLabel.hidden = YES;
        self.changeTextView.hidden = YES;
        self.underlineView.hidden = YES;
        self.changeTextViewCountLabel.hidden = YES;
        self.saveButton.hidden = YES;
        self.settingsTableView.hidden = NO;
        
        if([self.changeTextView isFirstResponder]) {
            [self.changeTextView resignFirstResponder];
        }
        
        self.underlineView.backgroundColor = [Utils colorFromHexString:@"#D2D2D2"];
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
