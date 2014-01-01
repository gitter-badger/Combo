//
//  SetCardDeck.m
//  Combo
//
//  Created by Craig Maynard on 11/24/13.
//  Copyright (c) 2014 Craig Maynard. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];

    if (self) {

        NSMutableArray *cardDictArray = [NSMutableArray array];
        for (int rank = 1; rank <= [SetCard maxRank]; rank++) {
            for (NSString* shape in [SetCard validShapes]) {
                for (NSString* color in [SetCard validColors]) {
                    for (NSString* shading in [SetCard validShadings]) {
                        NSDictionary *dict = @{ @"rank":[NSNumber numberWithInteger:rank], @"shape":shape, @"color":color, @"shading":shading };
                        [self addCard:[[SetCard alloc] initWithDictionary:dict]];
                        [cardDictArray addObject:dict];
                    }
                }
            }
        }

        [[NSUserDefaults standardUserDefaults] setObject:cardDictArray forKey:@"SetCardDeck"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return self;
}

@end
