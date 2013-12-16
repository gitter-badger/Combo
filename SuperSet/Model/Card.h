//
//  Card.h
//  SuperSet
//
//  Created by Craig Maynard on 11/16/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

@interface Card : NSObject

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

@end

// subclasses should implement this protocol
@protocol CardProtocol <NSObject>

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (BOOL)match:(NSArray *)cards;

@end
