//
//  CardDeck.h
//  SuperSet
//
//  Created by Craig Maynard on 11/16/13.
//  Copyright (c) 2014 Craig Maynard. All rights reserved.
//

@class Card;

@interface CardDeck : NSObject

@property (nonatomic, strong) NSArray *cardDeck;

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;
- (NSUInteger)cardCount;
- (Card *)cardAtIndex:(NSUInteger)index;

@end
