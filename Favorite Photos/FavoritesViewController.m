//
//  FavoritesViewController.m
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/16/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "FavoritesViewController.h"
#import "PhotosTableViewCell.h"
#import "Photo.h"

@interface FavoritesViewController () <PhotoTableViewCellDelegate>

@property NSMutableArray *favoritePhotos;
@property NSMutableArray *favoritePhotosNames;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self load];
    if (self.favoritePhotosNames == nil)
    {
        self.favoritePhotosNames = [NSMutableArray array];
    }
    if (self.favoritePhotos == nil)
    {
        self.favoritePhotos = [NSMutableArray array];
    }
    [self.tableView reloadData];
}


#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.favoritePhotos.count)
    {
        return self.favoritePhotos.count;
    }
    else
    {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];

        messageLabel.text = @"I'm feeling lonely... Where are my favorite photos?";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
        [messageLabel sizeToFit];

        self.tableView.backgroundView = messageLabel;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
    Photo *photo;
    NSData *photoData;
    NSString *photoId;
    if (self.favoritePhotos.count)
    {
        photo = [self.favoritePhotos objectAtIndex:indexPath.row];
        photoData = [NSData data];
        photoId = [NSString stringWithFormat:@"%@.png", photo.photoId];
    }

    //NSLog(@"photoid: %@", photoId);
    for (NSString *photoUrlName in self.favoritePhotosNames)
    {
        if ([photoUrlName isEqualToString:photoId])
        {
            photoData = [NSData dataWithContentsOfFile:[self documentsPathForFileName:photoUrlName]];
            [cell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_full"] forState:UIControlStateNormal];
        }
    }

    cell.photo.image = [UIImage imageWithData:photoData];

//    Photo *photo = [self.photos objectAtIndex:indexPath.row];
//    cell.delegate = self;
//    NSURLRequest *request = [NSURLRequest requestWithURL:photo.photoUrl];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error)
//     {
//         if (!error)
//         {
//             UIImage* image = [[UIImage alloc] initWithData:data];
//             cell.photo.image = image;
//             [cell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_empty"] forState:UIControlStateNormal];
//             cell.photo.layer.masksToBounds = YES;
//         }
//     }];
    cell.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400.0;
}

#pragma mark - NSUserDefaults

- (NSURL *)documentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return  files.firstObject;
}

- (void)load
{
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.plist"];
    self.favoritePhotosNames = [NSMutableArray arrayWithContentsOfURL:plist];
    self.favoritePhotos = [NSMutableArray array];
    //NSLog(@"FavNames: %@", self.favoritePhotosNames);
    for (NSString *imageUrlString in self.favoritePhotosNames)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [defaults objectForKey:imageUrlString];
        Photo *photo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (data)
        {
            [self.favoritePhotos addObject:photo];
        }
        //NSLog(@"Photo ID: %@", photo.photoId);
    }

    //NSLog(@"%@", self.favoritePhotosNames);
    //NSData *data = [NSKeyedArchiver archivedDataWithRootObj:obj];

    //Photo *obj = [NSKeyedUnarchiver unarchivedObjectWithData:data];
}

- (UIImage *)loadImage
{
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.plist"];

    //self.favoritePhotoUrlNames = [NSMutableArray arrayWithContentsOfURL:photoUrls];
//832847560751218225_744527078.png
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    //Photo *photo = [self.favoritePhotos objectAtIndex:indexPath.row];
    //NSData *pngData = [NSData dataWithContentsOfFile:[self documentsPathForFileName:[NSString stringWithFormat:@"%@.png", photo.photoId]]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"PersistenDataKey"];
    Photo *photo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //NSObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    NSData *pngData = [NSData dataWithContentsOfFile:[self documentsPathForFileName:[NSString stringWithFormat:@"%@.png", photo.photoId]]];
    //NSLog(@"%@", photo.photoId);
    return [UIImage imageWithData:pngData];
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];

    return [documentsPath stringByAppendingPathComponent:name];
}

#pragma mark - Helper Methods

- (void)setSelectedImageAsFavorite: (PhotosTableViewCell *)selectedCell tappedButton:(UIButton *)tappedButton
{
    // Turn the button that was tapped into a point so that you can get the index of that point in the tableview.
    CGPoint hitPoint = [tappedButton convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:hitPoint];

    NSData *currentImageData = UIImagePNGRepresentation(selectedCell.favoriteButton.currentBackgroundImage);
    //NSData *emptyHeartImageData = UIImagePNGRepresentation([UIImage imageNamed:@"heart_empty"]);
    //NSData *brokenHeartImageData = UIImagePNGRepresentation([UIImage imageNamed:@"heart_broken"]);
    NSData *fullHeartImageData = UIImagePNGRepresentation([UIImage imageNamed:@"heart_full"]);

    //BOOL currentValue = [[self.favoritePhotosIndexPaths objectAtIndex:indexPath.row] boolValue];
    //BOOL updatedValue = !currentValue;
    //self.favoritePhotosIndexPaths[indexPath.row] = [NSNumber numberWithBool:updatedValue];

    if ([currentImageData isEqual:fullHeartImageData])
    {
        Photo *photo = [self.favoritePhotos objectAtIndex:indexPath.row];
        [self.favoritePhotos removeObjectAtIndex:indexPath.row];
        [self.tableView performSelector:@selector(reloadData) withObject:indexPath afterDelay:0.3];

        [UIView animateWithDuration:0.3 animations:^{
            [selectedCell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_broken"] forState:UIControlStateNormal];
        }];

        [self deletePhoto:photo];

    }
}

- (void)reloadData: (NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];

}

- (void)deletePhoto: (Photo *)photo
{
    // Remove the photo being unfavorited from the plist of Photo names
    [self.favoritePhotosNames removeObject:[NSString stringWithFormat:@"%@.png", photo.photoId]];
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.plist"];
    [self.favoritePhotosNames writeToURL:plist atomically:YES];

    // Remove the photo with the name photo.photoId.png from the file system
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", photo.photoId]] error:nil];

    // Remove image object from user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:[NSString stringWithFormat:@"%@.png", photo.photoId]];
}

@end
