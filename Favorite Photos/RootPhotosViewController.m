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

@interface RootPhotosViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *photos;

@end

@implementation RootPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [NSMutableArray array];

    NSString *userSearch = @"cows";

    NSString *instagramApiResponse = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=%@",userSearch, INSTAGRAM_CLIENT_ID];
    [self getInstagramData:[NSURL URLWithString:instagramApiResponse]];
}


- (void)getInstagramData: (NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

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
//             // Create a photo object for each dictionary in the json array of dicts.
             for (NSDictionary *photoJsonDict in arrayOfInstagramPosts)
             {
                 Photo *photo = [[Photo alloc] initWithDictionary:photoJsonDict];
                 [self.photos addObject:photo];
             }
             [self.tableView reloadData];
         }
         else
         {
             NSLog(@"Instagram data fail");
         }
     }];
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
    //NSLog(@"%@", photo.imageUrl);
    //NSURLRequest *request = [NSURLRequest requestWithURL:photo.imageUrl];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSData * data = [[[NSData alloc] initWithContentsOfURL:URL] autorelease];
//
//        UIImage * img = [UIImage :@"background.jpg"];
//
//        // Make a trivial (1x1) graphics context, and draw the image into it
//        UIGraphicsBeginImageContext(CGSizeMake(1,1));
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), [img CGImage]);
//        UIGraphicsEndImageContext();
//
//        // Now the image will have been loaded and decoded and is ready to rock for the main thread
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [[self imageView] setImage: img];
//        });
//    });
    NSURLRequest *request = []
    cell.photo.image = [UIImage alloc] initWithData:<#(NSData *)#>
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:photo.url];
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.photo.image = (id)[tableView cellForRowAtIndexPath:indexPath];
//                    if (updateCell)
//                        updateCell.poster.image = image;
                });
            }
        }
    });

    return cell;
}

@end
