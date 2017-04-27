//
//  WebViewController.h
//  Predrink
//
//  Created by Viktor Georgiev on 4/26/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#define PRIVACY_POLICY 1
#define LICENSES 2

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>

@property (assign, nonatomic) int type;

@end
