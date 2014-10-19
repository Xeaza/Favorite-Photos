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
}

- (IBAction)onFavoriteButtonPressed:(UIButton *)button
{
    [self.delegate setSelectedImageAsFavorite:self tappedButton:button];
}

- (IBAction)onTweetButtonTapped:(id)sender
{
    [self.delegate tweetFavorite:self];
}

- (IBAction)onEmailButtonTapped:(id)sender
{
    [self.delegate emailFavorite:self];
}

@end
