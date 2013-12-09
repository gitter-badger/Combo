//
//  SetCardCollectionViewCell.h
//  SuperSet
//
//  Created by Craig Maynard on 12/8/13.
//  Copyright (c) 2013 Craig Maynard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetCardView;

@interface SetCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet SetCardView *cardView;

@end
