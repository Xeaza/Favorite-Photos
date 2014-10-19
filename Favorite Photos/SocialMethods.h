//
//  SocialMethods.h
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/19/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotosTableViewCell.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface SocialMethods : NSObject <MFMailComposeViewControllerDelegate>

+ (void)tweetFavorite: (PhotosTableViewCell *)selectedCell presentingViewController:(id)presentingViewController;
+ (void)emailFavorite: (PhotosTableViewCell *)selectedCell presentingViewController:(id)presentingViewController;

@end
