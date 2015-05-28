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

@interface InfoViewController () <UIWebViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation InfoViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.webView.delegate = self;

    NSURL *baseURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:baseURL]];
}

- (BOOL)webView:(UIWebView *)sender shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {

    if ([request.URL.scheme isEqualToString:@"mailto"]) {
        if ([MFMailComposeViewController canSendMail]) {
            // always start with a new mail controller (do not reuse)
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate = self;
            [mailer setToRecipients:@[@"feedback@chmaynard.com"]];
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
