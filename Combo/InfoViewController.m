//
//  InfoViewController.m
//  Combo
//
//  Created by Craig Maynard on 1/1/14.
//  Copyright (c) 2014-2015 Craig Maynard. All rights reserved.
//

#import "InfoViewController.h"
#import "UIAlertView+Blocks.h"
#import <MessageUI/MessageUI.h>
#import <objc/message.h>
#import <XWebView/XWebView-Swift.h>

@import XWebView;

@interface InfoViewController () <WKNavigationDelegate, MFMailComposeViewControllerDelegate>
@end

@implementation InfoViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];

    // In Combo 1.2, we switched from UIWebView to the new, shiny WKWebView.
    // Sadly, WKWebView lacks the ability to load local files on the device.
    // XWebView, a Swift framework that extends WKWebView, solves this problem.
    // https://github.com/XWebView/XWebView

    SEL selector = NSSelectorFromString(@"loadFileURL:allowingReadAccessToURL:");
    if ([webView respondsToSelector:selector]) {
        NSURL *baseURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
        NSURL *directoryURL = [NSURL URLWithString:[baseURL.absoluteString stringByDeletingLastPathComponent]];
        [webView loadFileURL:baseURL allowingReadAccessToURL:directoryURL];
    }
}

- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
 decisionHandler:(void (^)(WKNavigationActionPolicy)) decisionHandler
{
    decisionHandler([self shouldStartDecidePolicy:navigationAction.request]);
}

- (BOOL) shouldStartDecidePolicy:(NSURLRequest *)request
{
    if ([request.URL.scheme isEqualToString:@"mailto"]) {
        if ([MFMailComposeViewController canSendMail]) {
            // always start with a new mail controller (do not reuse)
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            [mailer setToRecipients:@[request.URL.resourceSpecifier]];
            [mailer setSubject:(NSString *)@"Combo Feedback"];
            [self presentViewController:mailer animated:YES completion:NULL];
        }
        return NO;
    }
    else {
        return YES;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {

    if (error) {

        [UIAlertView showWithTitle:@"Error"
                           message:[error description]
                          tapBlock:nil];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
