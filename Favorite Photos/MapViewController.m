//
//  MapViewController.m
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/18/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#define METERS_PER_MILE 1609.344

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Photo.h"
#import "FavoritesAnnotationView.h"
#import "RootPhotosViewController.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property Photo *photoBeingLoaded;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    for (Photo *photo in self.favoritePhotos)
    {
        self.photoBeingLoaded = photo;
        [self.mapView addAnnotation:photo];
    }

    // Map view zooms to annotations and fits all of them in view
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

#pragma mark - MKMapViewDelegate Methods

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    pin.image = [UIImage imageNamed:@"pin"];

    // this would be cool to have so that the user could see photos as pins.
    // Then, ideally when a pin is tapped the pin's image would be set to a pin
    // And it's annotationView would show the image. Right now it is set so that all pins
    // show up as pins and then the annotation view shows on press. Which is the only time you
    // can see the image...
    /*Photo *selectedPhotoAnnotation = (Photo *)annotation;
    NSData *data = [[NSData alloc] initWithContentsOfURL:selectedPhotoAnnotation.thumbnail];
    UIImage *resizedImage = [[UIImage alloc] initWithData:data];
    UIImage *image = [self imageWithImage:resizedImage scaledToSize:CGSizeMake(20, 20)];
    pin.image = image; */

    //pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}

// This is a cool method that is passed an image and scales it down
/*
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
} */

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        FavoritesAnnotationView *calloutView = (FavoritesAnnotationView *)[[[NSBundle mainBundle] loadNibNamed:@"FavoritePhotoAnnotationView" owner:self options:nil] objectAtIndex:0];

        // This array will only ever hold one object, unless I enable users to select multipule annotations
        NSArray *selectedAnnotaion = [self.mapView selectedAnnotations];
        Photo *selectedPhotoAnnotation = (Photo *)selectedAnnotaion.firstObject;

        // Create an offeset so the image shows up above the pin
        CGRect calloutViewFrame = calloutView.frame;
        // The addition of 6 makes the image centered above the pin
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 6, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;

        NSData *data = [[NSData alloc] initWithContentsOfURL:selectedPhotoAnnotation.photoLowResUrl];
        calloutView.annotationImageView.image = [[UIImage alloc] initWithData:data];

        [self.mapView reloadInputViews];
        /* Not sure if I want this to be an asynchronousrequest or not. If it is, the image flashes for a second before staying... hmm
         NSURLRequest *request = [NSURLRequest requestWithURL:self.photoBeingLoaded.photoLowResUrl];

        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * error)
         {
             if (!error)
             {
                 calloutView.annotationImageView.image = [[UIImage alloc] initWithData:data];
             }
         }]; 
         */
        [view addSubview:calloutView];
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    for (UIView *subview in view.subviews ){
        [subview removeFromSuperview];
    }
}

- (IBAction)onCloseButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
