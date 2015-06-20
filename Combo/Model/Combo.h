//
//  Combo.h
//  Combo
//
//  Created by Craig Maynard on 11/16/13.
//  Copyright (c) 2014-2015 Craig Maynard. All rights reserved.
//

@class ComboCard, Deck;

@protocol ComboProtocol <NSObject>
- (void) gameDidFinish;
@end

@interface Combo : NSObject

@property (nonatomic, weak) id<ComboProtocol>delegate;

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingCardDeck:(Deck *)deck;

- (BOOL)chooseCardAtIndex:(NSUInteger)index;
- (ComboCard *)cardAtIndex:(NSUInteger)index;

- (CGFloat)gameProgress;

@end
