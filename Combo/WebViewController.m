//
//  WebViewController.m
//  Combo
//
//  Created by Craig Maynard on 1/4/14.
//  Copyright (c) 2014 Craig Maynard. All rights reserved.
//

#import "WebViewController.h"
#import <MessageUI/MessageUI.h>

@interface WebViewController () <UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) MFMailComposeViewController *mailer;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.delegate = self;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:request];
}

- (MFMailComposeViewController *)mailer
{
    if (!_mailer) {
        _mailer = [[MFMailComposeViewController alloc] init];
        _mailer.mailComposeDelegate = self;
    }
    return _mailer;
}

- (BOOL)webView:(UIWebView *)sender shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if ([request.URL.scheme isEqualToString:@"mailto"]) {
		if ([MFMailComposeViewController canSendMail]) {
            [self.mailer setToRecipients:[NSArray arrayWithObject:request.URL.resourceSpecifier]];
            [self presentViewController:self.mailer animated:YES completion:NULL];
        }
    }

    return YES;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
