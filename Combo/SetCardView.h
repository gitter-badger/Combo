//
//  SetCardView.h
//  SuperSet
//
//  Created by Craig Maynard on 12/5/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

@interface SetCardView : UIView

@property (nonatomic, assign) NSUInteger rank;
@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *shading;
@property (strong, nonatomic) UIColor *fillColor;

@end
