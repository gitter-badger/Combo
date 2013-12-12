//
//  SuperSetViewController.m
//  SuperSet
//
//  Created by Craig Maynard on 11/24/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

#import "SuperSetViewController.h"
#import "Card.h"
#import "CardGame.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"
#import "SetCardDeck.h"
#import "SetCardView.h"

@interface SuperSetViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) CardGame *game;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

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
}

- (CardGame *)game
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

- (IBAction)tapCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game chooseCardAtIndex:indexPath.item];
        [self updateUI];
    }
}

- (CardGame *)createGame
{
    return [[CardGame alloc] initWithNumberOfCardsToMatch:3 usingCardDeck:[self createDeck]];
}

- (CardDeck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SetCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];

    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
     if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *cardView = ((SetCardCollectionViewCell *)cell).cardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            cardView.rank = setCard.rank;
            cardView.shape = setCard.shape;
            cardView.color = setCard.color;
            cardView.shading = setCard.shading;
            cardView.hidden = setCard.isMatched;
        }
    }
}

@end
