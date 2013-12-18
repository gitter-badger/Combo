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
#import "MTBlockAlertView.h"


@interface SetCardGameViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SetCardGameProtocol>

@property (nonatomic, strong) SetCardGame *game;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic) BOOL showHint;

@end

@implementation SetCardGameViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

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
    [self updateUI];

    [MTBlockAlertView showWithTitle:@"Game Over"
                            message:@"Awesome!"
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
            [self animateCollection];
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
    self.game = [[SetCardGame alloc] initWithCardCount:12 usingCardDeck:[self createDeck]];
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
                     animations:^{ cell.cardView.transform = transform; }
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
                     animations:^{ cell.cardView.transform = transform; }
                     completion:NULL];
}

- (void)animateCollection
{
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse;

    CGAffineTransform transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 10, 0);

    [UIView animateWithDuration:0.15
                          delay:0
                        options:options
                     animations:^{ self.collectionView.transform = transform; }
                     completion:^(BOOL finished){ self.collectionView.transform = CGAffineTransformIdentity; }];
}

@end
