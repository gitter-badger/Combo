//
//  InfoViewController.m
//  Combo
//
//  Created by Craig Maynard on 1/1/14.
//  Copyright (c) 2014 Craig Maynard. All rights reserved.
//

#import "InfoViewController.h"

NSString * const homePage = @"http://cmaynard.github.io/combo";

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
    [self.button setTitle:homePage forState:UIControlStateNormal];
}

- (IBAction)handleButtonTap:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:homePage]];
}

@end
