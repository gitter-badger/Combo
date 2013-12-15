//
//  SetCard.m
//  SuperSet
//
//  Created by Craig Maynard on 11/24/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

@synthesize shape = _shape;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.rank = [[dictionary objectForKey:@"rank"] integerValue];
        self.shape = [dictionary objectForKey:@"shape"];
        self.color = [dictionary objectForKey:@"color"];
        self.shading = [dictionary objectForKey:@"shading"];
    }

    return self;
}

- (NSDictionary *)dictionary
{
    return @{ @"rank" : [NSNumber numberWithInteger:self.rank], @"shape" : self.shape, @"color" : self.color, @"shading" : self.shading };
}

+ (BOOL)match:(NSArray *)cards
{
    int rankScore = 0;
    int shapeScore = 0;
    int colorScore = 0;
    int shadingScore = 0;

    SetCard *card1 = cards[0];
    SetCard *card2 = cards[1];
    SetCard *card3 = cards[2];

    if (card1.rank == card2.rank) { rankScore++; }
    if (card1.rank == card3.rank) { rankScore++; }
    if (card2.rank == card3.rank) { rankScore++; }

    if ([card1.shape isEqualToString:card2.shape]) { shapeScore++; }
    if ([card1.shape isEqualToString:card3.shape]) { shapeScore++; }
    if ([card2.shape isEqualToString:card3.shape]) { shapeScore++; }

    if ([card1.color isEqualToString:card2.color]) { colorScore++; }
    if ([card1.color isEqualToString:card3.color]) { colorScore++; }
    if ([card2.color isEqualToString:card3.color]) { colorScore++; }

    if ([card1.shading isEqualToString:card2.shading]) { shadingScore++; }
    if ([card1.shading isEqualToString:card3.shading]) { shadingScore++; }
    if ([card2.shading isEqualToString:card3.shading]) { shadingScore++; }

    BOOL matched = (rankScore % 3 == 0) && (shapeScore % 3 == 0) && (colorScore % 3 == 0) && (shadingScore % 3 == 0);
    return matched;
}

+ (NSUInteger) maxRank
{
    return 3;
}

+ (NSArray *)validShapes
{
    return @[@"diamond", @"rectangle", @"oval"];
}

+ (NSArray *)validColors
{
    return @[@"red", @"green", @"blue"];
}

+ (NSArray *)validShadings
{
    return @[@"solid", @"striped", @"open"];
}

- (void)setRank:(NSUInteger)rank
{
    if (rank >= 1 && rank <= 3) {
        _rank = rank;
    }
}

- (void)setShape:(NSString *)shape
{
    if ([[SetCard validShapes] containsObject:shape]) {
        _shape = shape;
    }
}

- (void) setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (void) setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

- (NSString *)shape
{
    return _shape ? _shape : @"?";
}

@end
