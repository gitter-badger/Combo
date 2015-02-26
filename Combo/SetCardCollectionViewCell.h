//
//  SetCardCollectionViewCell.h
//  Combo
//
//  Created by Craig Maynard on 12/8/13.
//  Copyright (c) 2014-2015 Craig Maynard. All rights reserved.
//

@interface SetCardCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) NSUInteger rank;
@property (nonatomic, strong) NSString *shape;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *shading;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) BOOL animating;

@end
