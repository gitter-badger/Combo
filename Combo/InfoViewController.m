//
//  InfoViewController.m
//  Combo
//
//  Created by Craig Maynard on 1/1/14.
//  Copyright (c) 2014-2015 Craig Maynard. All rights reserved.
//

#import "InfoViewController.h"
#import <MessageUI/MessageUI.h>

@interface InfoViewController () <UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) MFMailComposeViewController *mailer;

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
            // construct and present a new email controller (do not reuse)
            self.mailer = [[MFMailComposeViewController alloc] init];
            self.mailer.mailComposeDelegate = self;
            [self.mailer setToRecipients:[NSArray arrayWithObject:request.URL.resourceSpecifier]];
            [self.mailer setSubject:(NSString *)@"Combo Feedback"];
            [self presentViewController:self.mailer animated:YES completion:NULL];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error with message"
                                                        message:[NSString stringWithFormat:@"Error %@", [error description]]
                                                       delegate:nil
                                              cancelButtonTitle:@"Try Again Later!"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }

    [self dismissViewControllerAnimated:YES completion:^{ self.mailer = nil; }];
}

@end
