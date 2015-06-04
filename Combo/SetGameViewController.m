//
//  SetGameViewController.m
//  Combo
//
//  Created by Craig Maynard on 11/24/13.
//  Copyright (c) 2014-2015 Craig Maynard. All rights reserved.
//

#import "SetGameViewController.h"
#import "Card.h"
#import "SetGame.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"
#import "SetCardDeck.h"
#import "UIAlertView+Blocks.h"
#import <QuartzCore/QuartzCore.h>


@interface SetGameViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SetGameProtocol>

@property (nonatomic, strong) SetGame *game;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, assign) BOOL showHint;
@property (nonatomic, readonly) UIEdgeInsets insets;
@property (nonatomic, readonly) CGSize itemSize;

@end

@implementation SetGameViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIEdgeInsets)insets {
    return [self collectionView:self.collectionView
                         layout:self.collectionView.collectionViewLayout
         insetForSectionAtIndex:0];
}

- (CGSize)itemSize {
    return [self collectionView:self.collectionView
                         layout:self.collectionView.collectionViewLayout
         sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    static UIEdgeInsets insets;

    if (UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero)) {
        UIUserInterfaceSizeClass sizeClass = self.traitCollection.horizontalSizeClass;
        CGFloat offset = (sizeClass == UIUserInterfaceSizeClassCompact ? 10.0 : 30.0);
        insets = UIEdgeInsetsMake(offset, offset, 0.0, offset);
    }

    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat spacing = (self.collectionView.frame.size.width - (self.itemSize.width * 3.0) - (self.insets.top * 2.0)) / 2.0;

    return spacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static CGSize itemSize;

    if (CGSizeEqualToSize(itemSize, CGSizeZero)) {
        CGSize frameSize = self.collectionView.frame.size;
        CGFloat height = frameSize.height / 4.0 - self.insets.top;
        itemSize = CGSizeMake(height * 0.75, height);
    }

    return itemSize;
}

#pragma mark - View Management

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;

    // Create the first game
    [self createGame];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    [super viewWillDisappear:animated];
}

#pragma mark - Game Control

- (void)gameDidFinish
{
    NSArray *messages = @[@"Awesome!", @"Great Job!", @"Whew!", @"Nice Work!"];
    unsigned index = arc4random() % [messages count];
    UIAlertViewCompletionBlock completionBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) { [self createGame]; };

    [self updateUI];

    [UIAlertView showWithTitle:@"Game Over"
                       message:messages[index]
                      tapBlock:completionBlock];
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
