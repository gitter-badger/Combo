//
//  SuperSetViewController.m
//  SuperSet
//
//  Created by Craig Maynard on 11/24/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

#import "SuperSetViewController.h"
#import "Card.h"
#import "SetCardGame.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"
#import "SetCardDeck.h"
#import "SetCardView.h"

@interface SuperSetViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) SetCardGame *game;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *singleTapGesture;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *doubleTapGesture;

@end

@implementation SuperSetViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create the first game
    self.game = [self createGame];
    [self updateUI];

    // [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
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
        [self.game chooseCardAtIndex:indexPath.item];
        [self updateUI];
    }
}

- (IBAction)doubleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self updateUI];
    }
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
    cell.cardView.fillColor = card.isChosen ? [UIColor colorWithRed:.90 green:.90 blue:.90 alpha:1] : [UIColor whiteColor];
    cell.cardView.hidden = card.isMatched;
}

@end
