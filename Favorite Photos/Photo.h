//
//  Photo.h
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/16/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Photo : NSObject <NSCoding, MKAnnotation>

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (readonly) NSURL *photoUrl;
@property (readonly) NSURL *photoLowResUrl;
@property (readonly) CLLocation *photoLocation;
@property (readonly) NSString *photoId;

@property UIImage *image;

#pragma mark - MKAnnotation Properties

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;

@end
