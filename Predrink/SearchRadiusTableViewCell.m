//
//  SearchRadiusTableViewCell.m
//  Predrink
//
//  Created by Viktor Georgiev on 4/24/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "SearchRadiusTableViewCell.h"

@implementation SearchRadiusTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)sliderValueDidChange:(id)sender {
    int value = [NSNumber numberWithFloat:((UISlider *)sender).value].intValue;
    self.searchKilometersLabel.text = [NSString stringWithFormat:@"%d km", value];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:value] forKey:@"radius"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
