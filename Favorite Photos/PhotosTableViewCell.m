//
//  PhotosTableViewCell.m
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/16/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "PhotosTableViewCell.h"

@implementation PhotosTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
   // [self.favoriteButton addTarget:self action:@selector(buttonClickedStopWatch) forControlEvents:UIControlEventTouchUpInside];

}

- (IBAction)onFavoriteButtonPressed:(UIButton *)button
{

    [self.delegate setSelectedImageAsFavorite:self tappedButton:button];
    /*
    - (NSIndexPath *)indexPathForRowAtPoint:(CGPoint)point;                         // returns nil if point is outside of any row in the table
    - (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;                      // returns nil if cell is not visible
    - (NSArray *)indexPathsForRowsInRect:(CGRect)rect;*/
}


@end
