//
//  ViewController.h
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/16/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RootPhotosViewControllerDelegate <NSObject>

- (void)amIComingBackFromSearchPhotosViewController: (BOOL)comingBackFromSearchPhotos;

@end

@interface RootPhotosViewController : UITableViewController

@property id<RootPhotosViewControllerDelegate> delegate;

@end

