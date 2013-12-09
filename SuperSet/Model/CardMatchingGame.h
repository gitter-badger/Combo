//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Craig Maynard on 11/16/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card, CardDeck;

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithNumberOfCardsToMatch:(NSUInteger)cardsToMatch
                               usingCardDeck:(CardDeck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSString *lastMatchStatus;
@property (nonatomic, readonly) NSString *cardStatus;
@property (nonatomic, readonly) NSMutableArray *cardHistory;

@end
