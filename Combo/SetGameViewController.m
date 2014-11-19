//
//  SetGameViewController.m
//  Combo
//
//  Created by Craig Maynard on 11/24/13.
//  Copyright (c) 2014 Craig Maynard. All rights reserved.
//

#import "SetGameViewController.h"
#import "Card.h"
#import "SetGame.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"
#import "SetCardDeck.h"
#import "MTBlockAlertView.h"
#import <QuartzCore/QuartzCore.h>


@interface SetGameViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SetGameProtocol>

@property (nonatomic, strong) SetGame *game;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic) BOOL showHint;

@end

@implementation SetGameViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    // configure the flow layout

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.collectionViewLayout = flowLayout;

    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        flowLayout.itemSize = CGSizeMake(72.0, 96.0);
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 26.0, 5.0, 26.0);
    }
    else {
        flowLayout.itemSize = CGSizeMake(90.0, 120.0);
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0, 10.0, 0.0, 10.0);
    }

    // Create the first game
    [self createGame];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}

- (void)gameDidFinish
{
    NSArray *messages = @[@"Awesome!", @"Great Job!", @"Whew!", @"Nice Work!"];
    unsigned index = arc4random() % [messages count];

    [self updateUI];

    [MTBlockAlertView showWithTitle:@"Game Over"
                            message:messages[index]
                    completionBlock:^(UIAlertView *alertView) { [self createGame]; }];
}

- (IBAction)singleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        self.showHint = NO;
        BOOL success = [self.game chooseCardAtIndex:indexPath.item];
        [self updateUI];
        if (!success) {
            // match failed
            [self shake];
        }
    }
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)gesture
{
    self.showHint = YES;
    [self updateUI];
}

- (void)createGame
{
    self.game = [[SetGame alloc] initWithCardCount:12 usingCardDeck:[self createDeck]];
    self.game.delegate = self;
    [self updateUI];
}

- (CardDeck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)updateUI
{
    for (SetCardCollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        SetCard *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }

    CGFloat progress = [self.game gameProgress];
    [self.progressView setProgress:progress animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SetCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collection View Cell" forIndexPath:indexPath];
    SetCard *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];

    return cell;
}

- (void)updateCell:(SetCardCollectionViewCell *)cell usingCard:(SetCard *)card
{
    cell.rank = card.rank;
    cell.shape = card.shape;
    cell.color = card.color;
    cell.shading = card.shading;
    cell.hidden = card.isMatched;

    if (card.isNew) {
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromBottom;
        transition.duration = 0.3;
        [cell.layer addAnimation:transition forKey:nil];
        card.new = NO;
    }

    if (self.showHint) {
        if (card.canMatch) {
            [self startAnimatingCell:cell];
        }
    }
    else if (card.isChosen) {
        [self startAnimatingCell:cell];
    }
    else {
        [self stopAnimatingCell:cell];
    }
}

- (void)startAnimatingCell:(SetCardCollectionViewCell *)cell
{
    if (cell.animating) return;
    cell.animating = YES;

    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut |
                                     UIViewAnimationOptionAutoreverse |
                                     UIViewAnimationOptionRepeat |
                                     UIViewAnimationOptionAllowUserInteraction;

    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95);

    [UIView animateWithDuration:0.25
                          delay:0
                        options:options
                     animations:^{ cell.transform = transform; }
                     completion:NULL];
}

- (void)stopAnimatingCell:(SetCardCollectionViewCell *)cell
{
    if (!cell.animating) return;
    cell.animating = NO;

    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState;

    CGAffineTransform transform = CGAffineTransformIdentity;

    [UIView animateWithDuration:0.1
                          delay:0
                        options:options
                     animations:^{ cell.transform = transform; }
                     completion:NULL];
}

- (void)shake
{
    static CAKeyframeAnimation *animation;

    if (!animation) {

        animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.duration = 0.25;
        animation.delegate = self;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = YES;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

        NSMutableArray* values = [[NSMutableArray alloc] init];

        int steps = 100;
        double position = 0;
        float e = 2.71;

        for (int t = 0; t < steps; t++) {
            position = 10 * pow(e, -0.022 * t) * sin(0.12 * t);
            NSValue* value = [NSValue valueWithCGPoint:CGPointMake([self.collectionView center].x - position, [self.collectionView center].y)];
            [values addObject:value];
        }

        animation.values = values;
    }

    [[self.collectionView layer] addAnimation:animation forKey:@"position"];
}

@end
