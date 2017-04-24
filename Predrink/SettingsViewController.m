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
#import "User.h"

@interface SettingsViewController ()

@property (strong, nonatomic) NSArray<NSString *> *titlesArray;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArray = @[@"My Account", @"Bio", @"Favourite Drink", @"Search", @"Select search radius", @"More Information", @"Send Feedback", @"Privacy Policy", @"Licenses", @"Account Actions", @"Log Out"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)onBackPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
