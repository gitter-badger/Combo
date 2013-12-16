//
//  SetCardGame.h
//  SuperSet
//
//  Created by Craig Maynard on 11/16/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

@class SetCard, CardDeck;

@interface SetCardGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingCardDeck:(CardDeck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (SetCard *)cardAtIndex:(NSUInteger)index;

@end
