//
//  CardMatchingGame.m
//  Matchismo
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

@property (nonatomic, readwrite) NSString *lastMatchStatus;
@property (nonatomic, readwrite) NSString *cardStatus;
@property (nonatomic, readwrite) NSMutableArray *cardHistory;

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
    if (!_chosenCards)
        _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

- (NSMutableArray *)cardHistory
{
    if (!_cardHistory)
        _cardHistory = [[NSMutableArray alloc] init];
    return _cardHistory;
}

- (void)setCardStatus:(NSString *)cardStatus
{
    _cardStatus = cardStatus;
    if ([cardStatus length] != 0) {
        [self.cardHistory addObject:cardStatus];
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int CHOICE_PENALTY = 0;
static const int MISMATCH_PENALTY = 1;
static const int MATCH_BONUS = 4;

- (void)setMatchStatus:(Card *)card
           chosenCards:(NSMutableArray *)chosenCards
            matchScore:(NSInteger)matchScore
{
    self.lastMatchStatus = @"";
    if (matchScore) {
        self.lastMatchStatus = @"Match: ";
    } else {
        self.lastMatchStatus = @"No match: ";
    }
    self.lastMatchStatus = [self.lastMatchStatus stringByAppendingString:card.contents];
    for (Card* chosenCard in chosenCards) {
        self.lastMatchStatus = [self.lastMatchStatus stringByAppendingFormat:@" %@", chosenCard.contents];
    }
    if (matchScore) {
        self.lastMatchStatus = [self.lastMatchStatus stringByAppendingFormat:@" for %d points.", matchScore * MATCH_BONUS];
    } else {
        self.lastMatchStatus = [self.lastMatchStatus stringByAppendingFormat:@". Lost %d points.", MISMATCH_PENALTY];
    }
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = self.cards[index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            self.lastMatchStatus = @"";
            self.cardStatus = @"";
            [self.chosenCards removeObject:card];
        } else {
            card.chosen = YES;
            self.cardStatus = card.contents;
            if ([self.chosenCards count] == (self.cardsToMatch - 1)) {
                // match against other cards
                int matchScore = [card match:self.chosenCards];
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    for (Card *chosenCard in self.chosenCards) {
                        chosenCard.matched = YES;
                    }
                    card.matched = YES;
                } else {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *chosenCard in self.chosenCards) {
                        chosenCard.chosen = NO;
                    }
                    card.chosen = NO;
                }
                [self setMatchStatus:card chosenCards:self.chosenCards matchScore:matchScore];
                [self.chosenCards removeAllObjects];
            } else {
                // If we still haven't matched, add card for future consideration
                if (!card.isMatched) {
                    [self.chosenCards addObject:card];
                }
            }
        }
    }
    self.score -= CHOICE_PENALTY;
}

@end
