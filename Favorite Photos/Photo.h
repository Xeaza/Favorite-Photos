//
//  Photo.h
//  Favorite Photos
//
//  Created by Taylor Wright-Sanson on 10/16/14.
//  Copyright (c) 2014 Taylor Wright-Sanson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (readonly) NSURL *url;


@end
