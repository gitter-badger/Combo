//
//  SetCardCollectionViewCell.h
//  SuperSet
//
//  Created by Craig Maynard on 12/8/13.
//  Copyright (c) 2014 Craig Maynard. All rights reserved.
//

@class SetCardView;

@interface SetCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet SetCardView *cardView;
@property (nonatomic) BOOL animating;

@end
