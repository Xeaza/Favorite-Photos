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

- (NSURL *)url
{
    return [NSURL URLWithString:jsonDictionary[@"link"]];
}



@end
