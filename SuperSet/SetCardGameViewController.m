//
//  SetCardGameViewController.m
//  SuperSet
//
//  Created by Craig Maynard on 11/24/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "Card.h"
#import "SetCardGame.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"
#import "SetCardDeck.h"
#import "SetCardView.h"
#import <QuartzCore/QuartzCore.h>


@interface SetCardGameViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) SetCardGame *game;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL showHint;

@end

@implementation SetCardGameViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create the first game
    self.game = [self createGame];
    [self updateUI];
}

- (SetCardGame *)game
{
    if (!_game) {
        _game = [self createGame];
        [self updateUI];
    }

    return _game;
}

- (IBAction)newGameButton:(UIButton *)sender
{
    self.game = [self createGame];
    [self updateUI];
}

- (IBAction)singleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        self.showHint = NO;
        [self.game chooseCardAtIndex:indexPath.item];
        [self updateUI];
    }
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)gesture
{
    self.showHint = YES;
    [self updateUI];
}

- (SetCardGame *)createGame
{
    return [[SetCardGame alloc] initWithCardCount:12 usingCardDeck:[self createDeck]];
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
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SetCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SetCard" forIndexPath:indexPath];
    SetCard *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];

    return cell;
}

- (void)updateCell:(SetCardCollectionViewCell *)cell usingCard:(SetCard *)card
{
    cell.cardView.rank = card.rank;
    cell.cardView.shape = card.shape;
    cell.cardView.color = card.color;
    cell.cardView.shading = card.shading;
    cell.cardView.hidden = card.isMatched;

    if (self.showHint) {
        if (card.canMatch) {
            [self startAnimationWithCell:cell];
        }
    }
    else if (card.isChosen) {
        [self startAnimationWithCell:cell];
    }
    else {
        [self stopAnimationWithCell:cell];
    }
}

- (void)startAnimationWithCell:(SetCardCollectionViewCell *)cell
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
                     animations:^{ cell.cardView.transform = transform; }
                     completion:NULL];
}

- (void)stopAnimationWithCell:(SetCardCollectionViewCell *)cell
{
    if (!cell.animating) return;
    cell.animating = NO;

    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState;

    CGAffineTransform transform = CGAffineTransformIdentity;

    [UIView animateWithDuration:0.1
                          delay:0
                        options:options
                     animations:^{ cell.cardView.transform = transform; }
                     completion:NULL];
}

@end
