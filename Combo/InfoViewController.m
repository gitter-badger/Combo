//
//  InfoViewController.m
//  Combo
//
//  Created by Craig Maynard on 1/1/14.
//  Copyright (c) 2014 Craig Maynard. All rights reserved.
//

#import "InfoViewController.h"
#import "WebViewController.h"

NSString * const ComboHomePage = @"http://cmaynard.github.io/combo";

@interface InfoViewController ()

@property (nonatomic, weak) IBOutlet UILabel *versionLabel;
@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@", version];
    [self.button setTitle:ComboHomePage forState:UIControlStateNormal];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:ComboHomePage]];
        if (!data) {
            // site down or no internet connection
            self.button.enabled = NO;
        }
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"show web page"]) {

        WebViewController *vc = [segue destinationViewController];
        vc.urlString = ComboHomePage;
    }
}

@end
