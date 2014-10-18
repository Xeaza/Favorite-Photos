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

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

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
    pin.canShowCallout = YES;
    //pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];


    return pin;
}

- (IBAction)onCloseButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
