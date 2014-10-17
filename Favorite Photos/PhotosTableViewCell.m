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


    // Configure the view for the selected state
}
- (IBAction)onFavoriteButtonPressed:(id)sender
{
    [self.delegate setSelectedImageAsFavorite:self];
}


@end
