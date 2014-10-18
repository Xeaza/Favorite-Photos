//
//  MapViewController.m
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/18/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (IBAction)onCloseButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
