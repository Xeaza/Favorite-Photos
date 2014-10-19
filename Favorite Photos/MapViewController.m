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
    self.mapView.delegate = self;

    CLLocationCoordinate2D coordinate1;
    coordinate1.latitude = 40.740384;
    coordinate1.longitude = -73.991146;

    Photo *firstPhoto = self.favoritePhotos.firstObject;
    self.photoBeingLoaded = firstPhoto;
    
    [self.mapView addAnnotation:firstPhoto];

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(firstPhoto.coordinate, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
}

#pragma mark - MKMapViewDelegate Methods

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
    {
        return nil;
    }

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    //pin.canShowCallout = YES;
    pin.image = [UIImage imageNamed:@"pin"];
    //pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return pin;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
        FavoritesAnnotationView *calloutView = (FavoritesAnnotationView *)[[[NSBundle mainBundle] loadNibNamed:@"FavoritePhotoAnnotationView" owner:self options:nil] objectAtIndex:0];
        // Create an offeset so the image shows up above the pin
        CGRect calloutViewFrame = calloutView.frame;
        // The addition of 6 makes the image centered above the pin
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 6, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;

        NSData *data = [[NSData alloc] initWithContentsOfURL:self.photoBeingLoaded.photoLowResUrl];
        calloutView.annotationImageView.image = [[UIImage alloc] initWithData:data];
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
