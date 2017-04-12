//
//  Utils.h
//  Predrink
//
//  Created by Viktor Georgiev on 3/26/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (UIColor *) colorFromHexString:(NSString *)hexString;

+ (void)addShadowToView:(UIView *)view radius:(CGFloat)radius opacity:(CGFloat)opacity offset:(CGSize)offset;

@end
