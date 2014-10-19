//
//  PhotosTableViewCell.h
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/16/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@protocol PhotoTableViewCellDelegate <NSObject>

- (void)setSelectedImageAsFavorite:(id)selectedCell tappedButton:(UIButton *)tappedButton;

@end

@interface PhotosTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property Photo *instagramPost;

@property id<PhotoTableViewCellDelegate> delegate;

@end
