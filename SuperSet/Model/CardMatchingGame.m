//
//  CardMatchingGame.m
//  SuperSet
//
//  Created by Craig Maynard on 11/16/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Card.h"
#import "CardDeck.h"

@interface CardMatchingGame ()

@property (nonatomic, readwrite) NSUInteger cardsToMatch;
@property (nonatomic, strong) CardDeck *deck;
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *chosenCards;

@end

@implementation CardMatchingGame

- (instancetype)initWithNumberOfCardsToMatch:(NSUInteger)cardsToMatch
                               usingCardDeck:(CardDeck *)deck
{
    self = [super init];

    if (self) {
        _cardsToMatch = cardsToMatch;
        _deck = deck;
    }

    return self;
}

- (void)dealCards
{
    NSUInteger count = [self.deck cardCount];

    for (int i = 0; i < count; i++) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
        }
    }
}

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
        [self dealCards];
    }
    return _cards;
}

- (NSMutableArray *)chosenCards
{
    if (!_chosenCards) {
        _chosenCards = [[NSMutableArray alloc] init];
    }
    return _chosenCards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = self.cards[index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            [self.chosenCards removeObject:card];
        } else {
            card.chosen = YES;
            if ([self.chosenCards count] == (self.cardsToMatch - 1)) {
                // match against other cards
                if ([card match:self.chosenCards]) {
                    for (Card *chosenCard in self.chosenCards) {
                        chosenCard.matched = YES;
                    }
                    card.matched = YES;
                } else {
                    for (Card *chosenCard in self.chosenCards) {
                        chosenCard.chosen = NO;
                    }
                    card.chosen = NO;
                }
                [self.chosenCards removeAllObjects];
            } else {
                // If we still haven't matched, add card for future consideration
                if (!card.isMatched) {
                    [self.chosenCards addObject:card];
                }
            }
        }
    }
}

@end
