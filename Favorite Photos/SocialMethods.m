//
//  SocialMethods.m
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/19/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "SocialMethods.h"

@implementation SocialMethods


+ (void)tweetFavorite: (PhotosTableViewCell *)selectedCell presentingViewController:(id)presentingViewController
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"I love this photo!"];
        [tweetSheet addImage:selectedCell.photo.image];
        [presentingViewController presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:presentingViewController
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }

}

+ (void)emailFavorite: (PhotosTableViewCell *)selectedCell presentingViewController:(id)presentingViewController
{
    // Check if device has email set up in default mail app. Otherwise display error message
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = presentingViewController;
        [mailer setSubject:@"This is my favorite photo of all time!"];
        NSData *imageData = [NSData dataWithContentsOfURL:selectedCell.instagramPost.photoUrl];
        [mailer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:@"MyFile.jpeg"];

        [presentingViewController presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aww, shucks!"
                                                        message:@"You need to set up your email from the default Mail app to send this email"
                                                       delegate:presentingViewController
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

@end
