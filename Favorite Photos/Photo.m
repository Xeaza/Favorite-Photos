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

- (CLLocation *)photoLocation
{
    float latitude = [jsonDictionary[@"location"][@"latitude"] floatValue];
    float longitude = [jsonDictionary[@"location"][@"longitude"] floatValue];
    return [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
}



@end
