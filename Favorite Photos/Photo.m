//
//  Photo.m
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/16/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import "Photo.h"

@implementation Photo
{
    NSDictionary *jsonDictionary;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super self];
    if (self)
    {
        jsonDictionary = dictionary;
    }
    return self;
}

- (NSURL *)photoUrl
{
    return [NSURL URLWithString:jsonDictionary[@"images"][@"standard_resolution"][@"url"]];
}

- (NSURL *)photoLowResUrl
{
    return [NSURL URLWithString:jsonDictionary[@"images"][@"low_resolution"][@"url"]];
}

- (NSURL *)thumbnail
{
    return [NSURL URLWithString:jsonDictionary[@"images"][@"thumbnail"][@"url"]];
}

- (BOOL)photoHasLocationData
{
    if (jsonDictionary[@"location"] != [NSNull null])
    {
        return YES;
    }
    return NO;
}

- (CLLocation *)photoLocation
{
    float latitude;
    float longitude;
    if (self.photoHasLocationData)
    {
        latitude = [jsonDictionary[@"location"][@"latitude"] floatValue];
        longitude = [jsonDictionary[@"location"][@"longitude"] floatValue];
    }
    return [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
}

- (NSString *)photoId
{
    return jsonDictionary[@"id"];
}

#pragma mark - MKAnnotation Protocal 

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordNew;

    if (self.photoHasLocationData)
    {
        coordNew.latitude  = [jsonDictionary[@"location"][@"latitude"] floatValue];
        coordNew.longitude = [jsonDictionary[@"location"][@"longitude"] floatValue];
    }

    return coordNew;
}

- (NSString *)title
{
    return jsonDictionary[@"caption"][@"text"];
}
# pragma mark - NSCoding Protocal Methods
// These are used to encode and decode the Photo object so it can be saved in NSUserDefaults
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        jsonDictionary = [aDecoder decodeObjectForKey:@"dict"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:jsonDictionary forKey:@"dict"];
}

@end
