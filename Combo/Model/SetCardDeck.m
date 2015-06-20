//
//  SetCardDeck.m
//  Combo
//
//  Created by Craig Maynard on 11/24/13.
//  Copyright (c) 2014-2015 Craig Maynard. All rights reserved.
//

#import "SetCardDeck.h"
#import "ComboCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];

    if (self) {

        NSMutableArray *cardDictArray = [NSMutableArray array];
        for (int rank = 1; rank <= [ComboCard maxRank]; rank++) {
            for (NSString* shape in [ComboCard validShapes]) {
                for (NSString* color in [ComboCard validColors]) {
                    for (NSString* shading in [ComboCard validShadings]) {
                        NSDictionary *dict = @{ @"rank":[NSNumber numberWithInteger:rank], @"shape":shape, @"color":color, @"shading":shading };
                        [self addCard:[[ComboCard alloc] initWithDictionary:dict]];
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
