//
//  SetCard.h
//  Combo
//
//  Created by Craig Maynard on 11/24/13.
//  Copyright (c) 2014-2015 Craig Maynard. All rights reserved.
//

#import "Card.h"

@interface ComboCard : Card <CardProtocol>

@property (nonatomic, assign) NSUInteger rank;
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shading;

+ (NSUInteger) maxRank;
+ (NSArray *)validShapes;
+ (NSArray *)validColors;
+ (NSArray *)validShadings;

@end
