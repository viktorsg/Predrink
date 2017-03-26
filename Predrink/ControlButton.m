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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageEdgeInsets = UIEdgeInsetsMake(5.0f, self.frame.size.width / 2 - self.imageView.image.size.width , self.frame.size.height - self.imageView.image.size.height - 5.0f, self.frame.size.width / 2 - self.imageView.image.size.width);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(self.imageView.frame.size.height + 5.0f, self.frame.size.width / 2 - self.titleLabel.frame.size.width, 5, self.frame.size.width / 2 - self.titleLabel.frame.size.width);
}

@end
