//
//  SetCardGame.m
//  SuperSet
//
//  Created by Craig Maynard on 11/16/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

#import "SetCardGame.h"
#import "SetCard.h"
#import "CardDeck.h"

@interface SetCardGame ()

@property (nonatomic, readwrite) NSUInteger cardCount;
@property (nonatomic, strong) CardDeck *deck;
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *cardsInPlay;
@property (nonatomic, strong) NSMutableArray *chosenCards;
@property (nonatomic, strong) NSMutableSet *sets;

@end

@implementation SetCardGame

- (instancetype)initWithCardCount:(NSUInteger)count usingCardDeck:(CardDeck *)deck
{
    self = [super init];

    if (self) {
        _cardCount = count;
        _deck = deck;
    }

    return self;
}

- (void)dealCards
{
    for (int i = 0; i < self.cardCount; i++) {
        Card *card = [self.cardsInPlay objectAtIndex:i];
        if (card.isMatched) {
            card = [self.cards firstObject];
            if (card) {
                [self.cardsInPlay replaceObjectAtIndex:i withObject:card];
                [self.cards removeObjectAtIndex:0];
            }
        }
    }
}

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];

        NSUInteger count = [self.deck cardCount];

        for (int i = 0; i < count; i++) {
            Card *card = [self.deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
        }
    }

    return _cards;
}

- (NSMutableArray *)cardsInPlay
{
    if (!_cardsInPlay) {
        _cardsInPlay = [[NSMutableArray alloc] init];

        for (int i = 0; i < self.cardCount; i++) {
            Card *card = [self.cards firstObject];
            if (card) {
                [self.cardsInPlay insertObject:card atIndex:i];
                [self.cards removeObjectAtIndex:0];
            }
        }
    }

    return _cardsInPlay;
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
    return self.cardsInPlay[index];
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];

    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            [self.chosenCards removeObject:card];
        }
        else {
            card.chosen = YES;
            [self.chosenCards addObject:card];
            if ([self.chosenCards count] == 3) {

                // check for match
                if ([SetCard match:self.chosenCards]) {
                    for (Card *chosenCard in self.chosenCards) {
                        chosenCard.matched = YES;
                    }
                    [self dealCards];
                }

                for (Card *chosenCard in self.chosenCards) {
                    chosenCard.chosen = NO;
                }

                [self.chosenCards removeAllObjects];
            }
        }
    }
}

- (BOOL)containsSet:(NSArray *)cards
{
    for (int i = 0; i < self.cardCount; i++) {
        for (int j = i + 1; j < self.cardCount; j++) {
            for (int k = j + 1; k < self.cardCount; k++) {
                Card *card1 = [self.cards objectAtIndex:i];
                Card *card2 = [self.cards objectAtIndex:j];
                Card *card3 = [self.cards objectAtIndex:k];
                if ([SetCard match:@[card1, card2, card3]]) {
                    return YES;
                }
            }
        }
    }

    return NO;
}

@end
