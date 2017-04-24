//
//  MyAccountTableViewCell.h
//  Predrink
//
//  Created by Viktor Georgiev on 4/24/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (weak, nonatomic) IBOutlet UILabel *accountInformationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountInformationLabel;

@end
