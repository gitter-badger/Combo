//
//  SetCardGame.h
//  SuperSet
//
//  Created by Craig Maynard on 11/16/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

@class SetCard, CardDeck;

@protocol SetCardGameProtocol <NSObject>
- (void) didFinishGame;
@end

@interface SetCardGame : NSObject

@property (nonatomic, weak) id<SetCardGameProtocol>delegate;

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingCardDeck:(CardDeck *)deck;

- (BOOL)chooseCardAtIndex:(NSUInteger)index;
- (SetCard *)cardAtIndex:(NSUInteger)index;

- (CGFloat)gameProgress;

@end
