//
//  ControlButton.m
//  Predrink
//
//  Created by Viktor Georgiev on 3/26/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "ControlButton.h"

@implementation ControlButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if(!self.isBig) {
        self.imageView.frame = CGRectMake((self.frame.size.width - self.imageView.frame.size.width) / 2, 8, self.imageView.frame.size.width - 1, self.imageView.frame.size.height - 1);
        self.titleLabel.frame = CGRectMake((self.frame.size.width - self.titleLabel.frame.size.width) / 2, self.imageView.frame.size.height + 5, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        NSLog(@"not big");
    } else {
        self.imageView.frame = CGRectMake((self.frame.size.width - self.imageView.frame.size.width) / 2, 5, self.imageView.frame.size.width + 1, self.imageView.frame.size.height + 1);
        self.titleLabel.frame = CGRectMake((self.frame.size.width - self.titleLabel.frame.size.width) / 2, self.imageView.frame.size.height + 5, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        NSLog(@"big");
    }
}

@end
