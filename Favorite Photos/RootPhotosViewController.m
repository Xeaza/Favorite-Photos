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

@interface RootPhotosViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray *photos;

@end

@implementation RootPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [NSMutableArray array];

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
           }
       }];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 280.0;
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

@end
