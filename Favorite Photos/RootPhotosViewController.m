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

@interface RootPhotosViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, PhotoTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *photos;
@property NSMutableArray *favoritePhotosNames;

@end

@implementation RootPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [NSMutableArray array];
    [self load];
    if (self.favoritePhotosNames == nil)
    {
        self.favoritePhotosNames = [NSMutableArray array];
    }

    [self getInstagramDataFromApiUrl:[NSURL URLWithString:[self getApiUrlRequestForSearch:@"circuseverydamnday"]]];
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

    
    NSURLRequest *request = [NSURLRequest requestWithURL:photo.photoUrl];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error)
    {
           if (!error)
           {
               UIImage* image = [[UIImage alloc] initWithData:data];
               cell.photo.image = image;
               photo.image = image;
               [cell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_empty"] forState:UIControlStateNormal];
               cell.photo.layer.masksToBounds = YES;
           }
       }];

    //NSData *data = [NSData dataWithContentsOfURL:photo.photoUrl];
    //UIImage* image = [[UIImage alloc] initWithData:data];
    //photo.image = image;

   // cell.photo.image = photo.image;
    cell.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Photo *photo = [self.photos objectAtIndex:indexPath.row];
    //NSData *data = [NSData dataWithContentsOfURL:photo.photoUrl];
    //UIImage* image = [[UIImage alloc] initWithData:data];
    //cell.photo.image = image;
    //return image.size.height;
    return 280.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%ld", (long)indexPath.row);
}

#pragma mark - SearchBar Delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getInstagramDataFromApiUrl:[NSURL URLWithString:[self getApiUrlRequestForSearch:searchBar.text]]];
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

- (void)setSelectedImageAsFavorite: (PhotosTableViewCell *)selectedCell
{
    NSData *currentImageData = UIImagePNGRepresentation(selectedCell.favoriteButton.currentBackgroundImage);
    NSData *emptyHeartImageData = UIImagePNGRepresentation([UIImage imageNamed:@"heart_empty"]);
    //NSData *brokenHeartImageData = UIImagePNGRepresentation([UIImage imageNamed:@"heart_broken"]);
    NSData *fullHeartImageData = UIImagePNGRepresentation([UIImage imageNamed:@"heart_full"]);

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if ([currentImageData isEqual:emptyHeartImageData])
    {
        [UIView animateWithDuration:0.3 animations:^{
            [selectedCell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_full"] forState:UIControlStateNormal];
        }];
        //[self.favoritePhotos addObject:@"Hello"];
        Photo *photo = [self.photos objectAtIndex:indexPath.row];

        [self.favoritePhotosNames addObject:[NSString stringWithFormat:@"%@.png", photo.photoId]];
        [self savePhoto:photo];

    }
    else if ([currentImageData isEqual:fullHeartImageData])
    {
        [UIView animateWithDuration:0.3 animations:^{
            [selectedCell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heart_empty"] forState:UIControlStateNormal];
        }];
    }
}

- (NSURL *)documentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return  files.firstObject;
}

- (void)savePhoto: (Photo *)photo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSData *imageData = UIImagePNGRepresentation(photo.image);
    NSURL *imagePath = [[self documentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", photo.photoId]];

    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.plist"];
    [self.favoritePhotosNames writeToURL:plist atomically:YES];

    NSData *customObjectData = [NSKeyedArchiver archivedDataWithRootObject:photo];
    [userDefaults setObject:customObjectData forKey:[NSString stringWithFormat:@"%@.png", photo.photoId]];

    //NSURL *imagePath = [[self documentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"image_%f.png", [NSDate timeIntervalSinceReferenceDate]]];

    // Write image data to user's folder
    [imageData writeToURL:imagePath atomically:YES];
    [userDefaults synchronize];
}

- (void)load
{
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.plist"];
    self.favoritePhotosNames = [NSMutableArray arrayWithContentsOfURL:plist];
}


@end
