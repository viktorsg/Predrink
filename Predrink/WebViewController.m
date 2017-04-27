//
//  WebViewController.m
//  Predrink
//
//  Created by Viktor Georgiev on 4/26/17.
//  Copyright © 2017 Viktor Georgiev. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewTopConstraint;

@end

@implementation WebViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
    NSString *urlString;
    if(self.type == PRIVACY_POLICY) {
        self.webViewTopConstraint.constant = -30;
        
        urlString = @"https://www.iubenda.com/privacy-policy/8026105/full-legal";
    } else if(self.type == LICENSES) {
        self.headerLabel.text = @"Licenses";
        
        urlString = @"http://www.getpredrink.com/licenses.html";
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - WebView Delegate Methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark - Button Clicks

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
