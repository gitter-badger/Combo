//
//  SetCardDeck.m
//  SuperSet
//
//  Created by Craig Maynard on 11/24/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];

    if (self) {
        for (int rank = 1; rank <= [SetCard maxRank]; rank++) {
            for (NSString* shape in [SetCard validShapes]) {
                for (NSString* color in [SetCard validColors]) {
                    for (NSString* shading in [SetCard validShadings]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.rank = rank;
                        card.shape = shape;
                        card.color = color;
                        card.shading = shading;
                        [self addCard:card];
                    }
                }
            }
        }
    }

    return self;
}

@end
