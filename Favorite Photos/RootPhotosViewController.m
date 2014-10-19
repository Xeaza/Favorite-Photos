//
//  ViewController.m
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/16/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#define INSTAGRAM_AUTH_URL @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_API_URl @"https://api.instagram.com/v1/users/"
#define INSTAGRAM_CLIENT_ID @"1ba6fd84eae843c086fd47bf99aaedc8"
#define INSTAGRAM_CLIENT_SECRET @"afa28b17d2104731ac4689a7393de53c”
#define INSTAGRAM_REDIRECT_URI @"localhost:// registered in Instagram."

#import "RootPhotosViewController.h"
#import "PhotosTableViewCell.h"
#import "Photo.h"
#import "FavoritesViewController.h"

@interface RootPhotosViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, PhotoTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSString *searchString;
@property NSMutableArray *photos;
@property NSMutableArray *favoritePhotosNames;
@property NSMutableArray *favoritePhotosIndexPaths;
@property(nonatomic, retain) UIRefreshControl *refreshControl;

@end

@implementation RootPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchString = @"circuseverydamnday";
    self.photos = [NSMutableArray array];

    self.favoritePhotosIndexPaths = [[NSMutableArray alloc]init];

    [self load];
    if (self.favoritePhotosNames == nil)
    {
        self.favoritePhotosNames = [NSMutableArray array];
    }

    [self getInstagramDataFromApiUrl:[NSURL URLWithString:[self getApiUrlRequestForSearch:self.searchString]]];

    // Initialize the refresh control.
    self.refreshControl                 = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor       = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
    Photo *photo = [self.photos objectAtIndex:indexPath.row];

    BOOL shouldBeChecked = [[self.favoritePhotosIndexPaths objectAtIndex:indexPath.row] boolValue];

    NSURLRequest *request = [NSURLRequest requestWithURL:photo.photoUrl];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error)
    {
           if (!error)
           {
               UIImage* image = [[UIImage alloc] initWithData:data];
               cell.photo.image = image;
               photo.image = image;
               if (shouldBeChecked)
               {
                   [cell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_full"] forState:UIControlStateNormal];
               }
               else
               {
                   [cell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_empty"] forState:UIControlStateNormal];
               }

               for (NSString *photoName in self.favoritePhotosNames)
               {
                   if ([photoName isEqualToString:[NSString stringWithFormat:@"%@.png", photo.photoId]])
                   {
                       [cell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_full"] forState:UIControlStateNormal];
                       [self.favoritePhotosIndexPaths insertObject:[NSNumber numberWithBool:YES] atIndex:indexPath.row];
                       break;
                   }
                   else
                   {
                       [cell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_empty"] forState:UIControlStateNormal];
                   }
               }
               //cell.photo.layer.masksToBounds = YES;
           }
       }];

    //NSData *data = [NSData dataWithContentsOfURL:photo.photoUrl];
    //UIImage* image = [[UIImage alloc] initWithData:data];
    //photo.image = image;

   // cell.photo.image = photo.image;
    cell.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%ld", (long)indexPath.row);
}

#pragma mark - Refresh Control
- (void)refresh
{
    [self getInstagramDataFromApiUrl:[NSURL URLWithString:[self getApiUrlRequestForSearch:self.searchString]]];

    // End the refreshing
    if (self.refreshControl)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;

        [self.refreshControl endRefreshing];
    }
}

#pragma mark - SearchBar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchString = searchBar.text;
    [self getInstagramDataFromApiUrl:[NSURL URLWithString:[self getApiUrlRequestForSearch:self.searchString]]];
}

#pragma mark - Helper Methods

- (NSString *)getApiUrlRequestForSearch: (NSString *)search
{
    return [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@", search, INSTAGRAM_CLIENT_ID];
}

- (void)getInstagramDataFromApiUrl: (NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.photos = [NSMutableArray array];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSError *jsonError;
         if (connectionError != nil)
         {
             NSLog(@"Connection error: %@", connectionError.localizedDescription);
         }
         if (jsonError != nil) {
             NSLog(@"JSON error: %@", jsonError.localizedDescription);
         }

         if (data)
         {
             //NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             //NSLog(@"%@", jsonString);
             NSDictionary *instagramJsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
             NSArray *arrayOfInstagramPosts =  [instagramJsonData objectForKey:@"data"];
             // Create a photo object for each dictionary in the json array of dicts.
             for (NSDictionary *photoJsonDict in arrayOfInstagramPosts)
             {
                 Photo *photo = [[Photo alloc] initWithDictionary:photoJsonDict];

                 // TODO - Get user's current location so the 10 photos can be the 10 closest photos
                 if (self.photos.count < 10)
                 {
                     [self.photos addObject:photo];
                     [self.favoritePhotosIndexPaths addObject:[NSNumber numberWithBool:NO]];
                 }
             }
             [self.tableView reloadData];
             [self.searchBar resignFirstResponder];
         }
         else
         {
             NSLog(@"Instagram data fail");
         }
     }];
}

- (void)setSelectedImageAsFavorite: (PhotosTableViewCell *)selectedCell tappedButton:(UIButton *)tappedButton
{
    // Turn the button that was tapped into a point so that you can get the index of that point in the tableview.
    CGPoint hitPoint = [tappedButton convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:hitPoint];

    NSData *currentImageData = UIImagePNGRepresentation(selectedCell.favoriteButton.currentBackgroundImage);
    NSData *emptyHeartImageData = UIImagePNGRepresentation([UIImage imageNamed:@"heart_empty"]);
    //NSData *brokenHeartImageData = UIImagePNGRepresentation([UIImage imageNamed:@"heart_broken"]);
    NSData *fullHeartImageData = UIImagePNGRepresentation([UIImage imageNamed:@"heart_full"]);

    BOOL currentValue = [[self.favoritePhotosIndexPaths objectAtIndex:indexPath.row] boolValue];
    BOOL updatedValue = !currentValue;
    self.favoritePhotosIndexPaths[indexPath.row] = [NSNumber numberWithBool:updatedValue];

    if ([currentImageData isEqual:emptyHeartImageData])
    {
        [UIView animateWithDuration:0.3 animations:^{
            [selectedCell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_full"] forState:UIControlStateNormal];
        }];
        Photo *photo = [self.photos objectAtIndex:indexPath.row];

        [self.favoritePhotosNames addObject:[NSString stringWithFormat:@"%@.png", photo.photoId]];
        [self savePhoto:photo];
    }
    else if ([currentImageData isEqual:fullHeartImageData])
    {
        [UIView animateWithDuration:0.3 animations:^{
            [selectedCell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_empty"] forState:UIControlStateNormal];
        }];

        Photo *photo = [self.photos objectAtIndex:indexPath.row];
        [self deletePhoto:photo];
    }
}

- (NSURL *)documentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return  files.firstObject;
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

- (void)savePhoto: (Photo *)photo
{
    // Create a plist that holds the array of self.favoritePhotoNames
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.plist"];
    [self.favoritePhotosNames writeToURL:plist atomically:YES];

    // Encode the photo object as NSData so it can be added to userDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *customObjectData = [NSKeyedArchiver archivedDataWithRootObject:photo];
    [userDefaults setObject:customObjectData forKey:[NSString stringWithFormat:@"%@.png", photo.photoId]];

    // Write photo to file system as .png
    NSData *imageData = UIImagePNGRepresentation(photo.image);
    NSURL *imagePath = [[self documentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", photo.photoId]];
    [imageData writeToURL:imagePath atomically:YES];
    [userDefaults synchronize];
}

- (void)load
{
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.plist"];
    self.favoritePhotosNames = [NSMutableArray arrayWithContentsOfURL:plist];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.delegate amIComingBackFromSearchPhotosViewController:YES];
    self.delegate = nil;
}


@end
