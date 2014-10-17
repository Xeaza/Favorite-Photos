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

@interface FavoritesViewController ()

@property NSMutableArray *favoritePhotos;
@property NSMutableArray *favoritePhotosNames;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FavoritesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self load];
    if (self.favoritePhotosNames == nil)
    {
        self.favoritePhotosNames = [NSMutableArray array];
    }
    if (self.favoritePhotos == nil)
    {
        self.favoritePhotos = [NSMutableArray array];
    }

}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.favoritePhotos.count;
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

    return cell;
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [self load];
//    if (self.favoritePhotosNames == nil)
//    {
//        self.favoritePhotosNames = [NSMutableArray array];
//        self.favoritePhotos = [NSMutableArray array];
//    }
//    [self.tableView reloadData];
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280.0;
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




@end
