//
//  SetGame.h
//  Combo
//
//  Created by Craig Maynard on 11/16/13.
//  Copyright (c) 2014-2015 Craig Maynard. All rights reserved.
//

@class ComboCard, CardDeck;

@protocol SetGameProtocol <NSObject>
- (void) gameDidFinish;
@end

@interface SetGame : NSObject

@property (nonatomic, weak) id<SetGameProtocol>delegate;

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingCardDeck:(CardDeck *)deck;

- (BOOL)chooseCardAtIndex:(NSUInteger)index;
- (ComboCard *)cardAtIndex:(NSUInteger)index;

- (CGFloat)gameProgress;

@end
